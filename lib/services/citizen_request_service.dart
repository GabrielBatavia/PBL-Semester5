// lib/services/citizen_request_service.dart
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import '../models/citizen_request_model.dart';
import 'api_client.dart';

class CitizenRequestService {
  /* ===================== GET ALL ===================== */
  Future<List<CitizenRequestModel>> getAll({String? search}) async {
    final path = (search != null && search.isNotEmpty)
        ? '/citizen-requests?search=${Uri.encodeQueryComponent(search)}'
        : '/citizen-requests';

    final res = await ApiClient.get(path, auth: false);
    if (res.statusCode != 200) {
      throw Exception("Gagal load data: ${res.body}");
    }

    final List data = jsonDecode(res.body);
    return data.map((e) => CitizenRequestModel.fromJson(e)).toList();
  }

  /* ===================== GET BY ID ===================== */
  Future<CitizenRequestModel> getById(int id) async {
    final res = await ApiClient.get('/citizen-requests/$id', auth: false);
    if (res.statusCode != 200) {
      throw Exception("Data tidak ditemukan");
    }
    return CitizenRequestModel.fromJson(jsonDecode(res.body));
  }

  /* ===================== CREATE (MULTIPART) ===================== */
  Future<bool> createWithImage(CitizenRequestModel data, File? img) async {
    final uri = ApiClient.buildUri('/citizen-requests');
    final req = http.MultipartRequest('POST', uri);

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

  /* ===================== CREATE (JSON) ===================== */
  Future<bool> create(CitizenRequestModel data) async {
    final res = await ApiClient.post(
      '/citizen-requests',
      {
        "name": data.name,
        "nik": data.nik,
        "email": data.email,
        "gender": data.gender,
        "status": data.status ?? "pending",
      },
      auth: false,
    );

    if (res.statusCode != 201 && res.statusCode != 200) {
      throw Exception("Gagal create: ${res.body}");
    }

    return true;
  }

  /* ===================== UPDATE (JSON PUT) ===================== */
  Future<bool> update(int id, CitizenRequestModel data) async {
    final res = await ApiClient.put(
      '/citizen-requests/$id',
      data.toJson(),
      auth: false,
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
    final res = await ApiClient.put(
      '/citizen-requests/$id',
      {
        "status": status,
        "processed_by": processedBy,
      },
      auth: false,
    );

    if (res.statusCode != 200) {
      throw Exception("Gagal update status: ${res.body}");
    }
    return true;
  }

  /* ===================== DELETE ===================== */
  Future<bool> delete(int id) async {
    final res = await ApiClient.delete('/citizen-requests/$id', auth: false);
    return res.statusCode == 200 || res.statusCode == 204;
  }
}
