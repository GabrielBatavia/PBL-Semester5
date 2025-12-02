import 'dart:convert';
import 'package:http/http.dart' as http;

import 'api_client.dart';
import '../models/family_model.dart';

class FamilyService {
  FamilyService._();

  static final FamilyService instance = FamilyService._();
  final String baseUrl = "http://127.0.0.1:9000";

  // ─────────────────────────────────────────────
  // GET ALL FAMILIES (untuk Data Keluarga)
  // ─────────────────────────────────────────────
  Future<List<FamilyModel>> fetchFamilies({String? search}) async {
  final url = "$baseUrl/families/extended?search=${search ?? ""}";
  final response = await http.get(Uri.parse(url));

  if (response.statusCode != 200) {
    throw Exception("Gagal mengambil data dari server");
  }

  final List data = jsonDecode(response.body);
  return data.map((e) => FamilyModel.fromJson(e)).toList();
}


  
  // ─────────────────────────────────────────────
  // GET FAMILY BY ID
  // ─────────────────────────────────────────────
  Future<Map<String, dynamic>?> getFamilyById(int id) async {
    final res = await ApiClient.get(
      '/families/$id',
      auth: true,
    );

    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    }

    return null;
  }

  // ─────────────────────────────────────────────
  // CREATE FAMILY
  // ─────────────────────────────────────────────
  Future<bool> createFamily({
    required String name,
    required int? houseId,
  }) async {
    final res = await ApiClient.post(
      '/families',
      {
        'name': name,
        'house_id': houseId,
      },
      auth: true,
    );

    return res.statusCode == 201;
  }

  // ─────────────────────────────────────────────
  // UPDATE FAMILY
  // ─────────────────────────────────────────────
  Future<bool> updateFamily({
    required int id,
    required String name,
    required int? houseId,
    String status = "aktif",
  }) async {
    final res = await ApiClient.put(
      '/families/$id',
      {
        'name': name,
        'house_id': houseId,
        'status': status,
      },
      auth: true,
    );

    return res.statusCode == 200;
  }

  // ─────────────────────────────────────────────
  // DELETE FAMILY
  // ─────────────────────────────────────────────
  Future<bool> deleteFamily(int id) async {
    final res = await ApiClient.delete(
      '/families/$id',
      auth: true,
    );

    return res.statusCode == 200;
  }

  // ─────────────────────────────────────────────
  // GET FAMILY MEMBERS (RESIDENTS) BY FAMILY ID
  // ─────────────────────────────────────────────
  Future<List<Map<String, dynamic>>> getFamilyMembers(int familyId) async {
    final res = await ApiClient.get(
      '/families/$familyId/residents',
      auth: true,
    );

    if (res.statusCode == 200) {
      final List data = jsonDecode(res.body);
      return data.cast<Map<String, dynamic>>();
    }

    return [];
  }
}
