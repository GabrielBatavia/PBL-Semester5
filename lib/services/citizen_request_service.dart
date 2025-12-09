// lib/services/citizen_request_service.dart
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/citizen_request_model.dart';

class CitizenRequestService {
 
  final String baseUrl = "http://127.0.0.1:9000/citizen-registration-requests";

  // GET ALL (with optional search)
  Future<List<CitizenRequestModel>> getAll({String? search}) async {
    final encoded = Uri.encodeQueryComponent(search ?? "");
    final uri = Uri.parse(search != null && search.isNotEmpty ? "$baseUrl?search=$encoded" : baseUrl);
    final res = await http.get(uri);
    if (res.statusCode == 200) {
      final List data = jsonDecode(res.body);
      return data.map((e) => CitizenRequestModel.fromJson(e)).toList();
    } else {
      throw Exception("Gagal load citizen requests: ${res.statusCode} ${res.body}");
    }
  }

  // GET BY ID
  Future<CitizenRequestModel> getById(int id) async {
    final res = await http.get(Uri.parse("$baseUrl/$id"));
    if (res.statusCode == 200) {
      return CitizenRequestModel.fromJson(jsonDecode(res.body));
    } else {
      throw Exception("Data tidak ditemukan: ${res.statusCode}");
    }
  }

  // CREATE (multipart with image)
  Future<bool> createWithImage(CitizenRequestModel data, File? img) async {
    final uri = Uri.parse(baseUrl); // POST to collection
    final req = http.MultipartRequest('POST', uri);

    req.fields['name'] = data.name ?? '';
    req.fields['nik'] = data.nik ?? '';
    req.fields['email'] = data.email ?? '';
    if ((data.gender ?? '').isNotEmpty) req.fields['gender'] = data.gender!;
    if ((data.status ?? '').isNotEmpty) req.fields['status'] = data.status;

    if (img != null && await img.exists()) {
      req.files.add(await http.MultipartFile.fromPath('identity_image', img.path));
    }

    final streamed = await req.send();
    final res = await http.Response.fromStream(streamed);
    return res.statusCode == 201 || res.statusCode == 200;
  }

  // UPDATE (multipart + optional image)
  Future<bool> updateWithImage(int id, CitizenRequestModel data, File? img) async {
    // If backend supports PUT with multipart, use that. For some backends, use POST + _method=PUT.
    final uri = Uri.parse("$baseUrl/$id");
    final req = http.MultipartRequest('POST', uri);

    // Some backends require override:
    req.fields['_method'] = 'PUT';

    req.fields['name'] = data.name ?? '';
    req.fields['nik'] = data.nik ?? '';
    req.fields['email'] = data.email ?? '';
    if ((data.gender ?? '').isNotEmpty) req.fields['gender'] = data.gender!;
    req.fields['status'] = data.status;

    if (img != null && await img.exists()) {
      req.files.add(await http.MultipartFile.fromPath('identity_image', img.path));
    }

    final streamed = await req.send();
    final res = await http.Response.fromStream(streamed);
    return res.statusCode == 200;
  }

  // UPDATE STATUS (sets processed_by and processed_at via backend)
  Future<bool> updateStatus(int id, String newStatus, {required int processedBy}) async {
    // Endpoint: PATCH /{id}/status  (backend must accept processed_by)
    final uri = Uri.parse("$baseUrl/$id/status");
    final res = await http.patch(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'status': newStatus,
        'processed_by': processedBy,
      }),
    );

    return res.statusCode == 200;
  }

  // CREATE JSON (fallback)
  Future<bool> create(CitizenRequestModel data) async {
    final res = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data.toJson()),
    );
    return res.statusCode == 201 || res.statusCode == 200;
  }

  // UPDATE JSON (fallback)
  Future<bool> update(int id, CitizenRequestModel data) async {
    final res = await http.put(
      Uri.parse("$baseUrl/$id"),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data.toJson()),
    );
    return res.statusCode == 200;
  }

  // DELETE
  Future<bool> delete(int id) async {
    final res = await http.delete(Uri.parse("$baseUrl/$id"));
    return res.statusCode == 200 || res.statusCode == 204;
  }
}
