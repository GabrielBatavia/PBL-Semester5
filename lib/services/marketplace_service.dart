// lib/services/marketplace_service.dart
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

import '../models/marketplace_item.dart';
import 'api_client.dart';

class MarketplaceService {
  MarketplaceService();
  static MarketplaceService instance = MarketplaceService();

  final _itemsController = StreamController<List<MarketplaceItem>>.broadcast();
  Stream<List<MarketplaceItem>> get items$ => _itemsController.stream;

  List<MarketplaceItem> _cache = [];

  /// GET /marketplace/items
  Future<void> fetchItems() async {
    try {
      final res = await ApiClient.get('/marketplace/items', auth: true);

      if (res.statusCode == 200) {
        final decoded = jsonDecode(res.body);

        if (decoded is! List) {
          _itemsController.addError('Format data marketplace tidak valid (bukan list)');
          return;
        }

        final items = decoded
            .map((e) => MarketplaceItem.fromJson(e as Map<String, dynamic>))
            .toList()
            .cast<MarketplaceItem>();

        _cache = items;
        _itemsController.add(_cache);
      } else {
        _itemsController.addError('Gagal memuat marketplace (${res.statusCode})');
      }
    } catch (e) {
      _itemsController.addError('Error memuat marketplace: $e');
    }
  }

  /// POST /marketplace/items (multipart) – buat item baru
  Future<void> addItem({
    required String title,
    required double price,
    String? description,
    String? unit,
    String? veggieClass,
    File? imageFile,
  }) async {
    final uri = ApiClient.buildUri('/marketplace/items');
    final token = await ApiClient.getToken();

    final request = http.MultipartRequest('POST', uri);

    request.fields['title'] = title;
    request.fields['price'] = price.toString();
    if (description != null && description.isNotEmpty) {
      request.fields['description'] = description;
    }
    if (unit != null && unit.isNotEmpty) {
      request.fields['unit'] = unit;
    }
    if (veggieClass != null && veggieClass.isNotEmpty) {
      request.fields['veggie_class'] = veggieClass;
    }

    if (imageFile != null) {
      final mime = lookupMimeType(imageFile.path) ?? 'image/jpeg';
      final parts = mime.split('/');
      request.files.add(
        await http.MultipartFile.fromPath(
          'image',
          imageFile.path,
          contentType: MediaType(parts[0], parts[1]),
        ),
      );
    }

    if (token != null && token.isNotEmpty) {
      request.headers['Authorization'] = 'Bearer $token';
    }

    final streamed = await request.send();
    final resp = await http.Response.fromStream(streamed);

    if (resp.statusCode == 201) {
      final data = jsonDecode(resp.body) as Map<String, dynamic>;
      final item = MarketplaceItem.fromJson(data);
      _cache = [item, ..._cache];
      _itemsController.add(_cache);
    } else {
      throw Exception('Gagal menambahkan item (${resp.statusCode}): ${resp.body}');
    }
  }

  /// POST /marketplace/analyze-image – kirim foto ke backend AI
  Future<Map<String, dynamic>> analyzeImage(File imageFile) async {
    final uri = ApiClient.buildUri('/marketplace/analyze-image');
    final token = await ApiClient.getToken();

    final request = http.MultipartRequest('POST', uri);
    final mime = lookupMimeType(imageFile.path) ?? 'image/jpeg';
    final parts = mime.split('/');

    request.files.add(
      await http.MultipartFile.fromPath(
        'image',
        imageFile.path,
        contentType: MediaType(parts[0], parts[1]),
      ),
    );

    if (token != null && token.isNotEmpty) {
      request.headers['Authorization'] = 'Bearer $token';
    }

    final streamed = await request.send();
    final resp = await http.Response.fromStream(streamed);

    if (resp.statusCode == 200) {
      return jsonDecode(resp.body) as Map<String, dynamic>;
    } else {
      throw Exception('Gagal analisa gambar (${resp.statusCode}): ${resp.body}');
    }
  }

  void dispose() {
    _itemsController.close();
  }
}
