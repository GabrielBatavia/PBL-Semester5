// lib/services/citizen_request_service.dart
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/citizen_request_model.dart';

class CitizenRequestService {
  final String baseUrl = "http://127.0.0.1:9000/citizen-requests";

  /* ===================== GET ALL ===================== */
  Future<List<CitizenRequestModel>> getAll({String? search}) async {
    final uri = Uri.parse(
      search != null && search.isNotEmpty
          ? "$baseUrl?search=${Uri.encodeQueryComponent(search)}"
          : baseUrl,
    );

    final res = await http.get(uri);
    if (res.statusCode != 200) {
      throw Exception("Gagal load data: ${res.body}");
    }

    final List data = jsonDecode(res.body);
    return data.map((e) => CitizenRequestModel.fromJson(e)).toList();
  }

  /* ===================== GET BY ID ===================== */
  Future<CitizenRequestModel> getById(int id) async {
    final res = await http.get(Uri.parse("$baseUrl/$id"));
    if (res.statusCode != 200) {
      throw Exception("Data tidak ditemukan");
    }
    return CitizenRequestModel.fromJson(jsonDecode(res.body));
  }

  /* ===================== CREATE (MULTIPART) ===================== */
  Future<bool> createWithImage(CitizenRequestModel data, File? img) async {
    final req = http.MultipartRequest('POST', Uri.parse(baseUrl));

    req.fields['name'] = data.name ?? '';
    req.fields['nik'] = data.nik ?? '';
    req.fields['email'] = data.email ?? '';
    req.fields['gender'] = data.gender ?? '';
    req.fields['status'] = data.status ?? 'pending';

    if (img != null && await img.exists()) {
      req.files.add(await http.MultipartFile.fromPath(
        'identity_image',
        img.path,
      ));
    }

    final res = await http.Response.fromStream(await req.send());
    return res.statusCode == 201 || res.statusCode == 200;
  }
  /* ===================== CREATE (JSON - WEB SAFE) ===================== */
  Future<bool> create(CitizenRequestModel data) async {
    final res = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "name": data.name,
        "nik": data.nik,
        "email": data.email,
        "gender": data.gender,
        "status": data.status ?? "pending",
      }),
    );

    if (res.statusCode != 201 && res.statusCode != 200) {
      throw Exception("Gagal create: ${res.body}");
    }

    return true;
  }


  /* ===================== UPDATE (JSON PUT) ===================== */
  Future<bool> update(int id, CitizenRequestModel data) async {
    final res = await http.put(
      Uri.parse("$baseUrl/$id"),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data.toJson()),
    );

    if (res.statusCode != 200) {
      throw Exception("Gagal update: ${res.body}");
    }
    return true;
  }

  /* ===================== APPROVE / REJECT ===================== */
  Future<bool> updateStatus({
    required int id,
    required String status,
    required int processedBy,
  }) async {
    final res = await http.put(
      Uri.parse("$baseUrl/$id"),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "status": status,
        "processed_by": processedBy,
      }),
    );

    if (res.statusCode != 200) {
      throw Exception("Gagal update status: ${res.body}");
    }
    return true;
  }

  /* ===================== DELETE ===================== */
  Future<bool> delete(int id) async {
    final res = await http.delete(Uri.parse("$baseUrl/$id"));
    return res.statusCode == 200 || res.statusCode == 204;
  }
}
