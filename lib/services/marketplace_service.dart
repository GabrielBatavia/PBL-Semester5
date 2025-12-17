// lib/services/marketplace_service.dart
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/marketplace_item.dart';
import 'api_client.dart';

class MarketplaceService {
  MarketplaceService();

  static MarketplaceService instance = MarketplaceService();

  final _itemsController = StreamController<List<MarketplaceItem>>.broadcast();
  Stream<List<MarketplaceItem>> get items$ => _itemsController.stream;

  List<MarketplaceItem> _cache = [];

  // Ambil token yang sama seperti ApiClient
  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  /// GET /marketplace/items
  Future<void> fetchItems() async {
    final res = await ApiClient.get(
      '/marketplace/items',
      auth: true,
    );

    if (res.statusCode == 200) {
      final List<dynamic> data = jsonDecode(res.body) as List<dynamic>;
      _cache = data
          .map((e) => MarketplaceItem.fromJson(e as Map<String, dynamic>))
          .toList();
      _itemsController.add(_cache);
    } else {
      throw Exception('Gagal memuat marketplace (${res.statusCode})');
    }
  }

  /// POST /marketplace/items (multipart) – buat item baru
  Future<void> addItem({
    required String title,
    required double price,
    String? description,
    String? unit,
    String? veggieClass,   // 🔹
    File? imageFile,
  }) async {
    final uri = Uri.parse('${ApiClient.baseUrl}/marketplace/items');
    final token = await _getToken();

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
      request.fields['veggie_class'] = veggieClass;   // 🔹
    }

    // kirim file gambar (opsional)
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

    if (token != null) {
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
      throw Exception('Gagal menambahkan item (${resp.statusCode})');
    }
  }


  /// POST /marketplace/analyze-image – kirim foto ke backend AI (mock)
  /// (pastikan endpoint ini sudah ada di FastAPI, kalau belum, tombol di UI jangan dipakai dulu)
  Future<Map<String, dynamic>> analyzeImage(File imageFile) async {
    final uri =
        Uri.parse('${ApiClient.baseUrl}/marketplace/analyze-image');
    final token = await _getToken();

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

    if (token != null) {
      request.headers['Authorization'] = 'Bearer $token';
    }

    final streamed = await request.send();
    final resp = await http.Response.fromStream(streamed);

    if (resp.statusCode == 200) {
      return jsonDecode(resp.body) as Map<String, dynamic>;
    } else {
      throw Exception(
        'Gagal analisa gambar (${resp.statusCode}): ${resp.body}',
      );
    }
  }

  void dispose() {
    _itemsController.close();
  }
}
