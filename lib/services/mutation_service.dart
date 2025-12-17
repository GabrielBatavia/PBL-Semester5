 import 'dart:convert';
import 'package:http/http.dart' as http;

import 'api_client.dart';
import '../models/mutations_model.dart';

class MutasiService {
  MutasiService._();
  static final MutasiService instance = MutasiService._();

  final String baseUrl = "http://127.0.0.1:9000";

  // =====================================================
  // GET ALL MUTASI (mendukung search bila backend menambahkan)
  // =====================================================
  Future<List<MutasiModel>> fetchMutations({String? search}) async {
    final url = "$baseUrl/mutasi?search=${search ?? ""}";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode != 200) {
      throw Exception("Gagal memuat data mutasi");
    }

    final List data = jsonDecode(response.body);
    return data.map((e) => MutasiModel.fromJson(e)).toList();
  }

  // =====================================================
  // GET MUTASI BY ID
  // =====================================================
  Future<Map<String, dynamic>?> getById(int id) async {
    final res = await ApiClient.get(
      '/mutasi/$id',
      auth: true,
    );

    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    }
    return null;
  }

  // =====================================================
  // CREATE MUTASI
  // =====================================================
  Future<bool> create(MutasiModel m) async {
    final body = {
      "family_id": m.familyId,
      "old_address": m.oldAddress,
      "new_address": m.newAddress,
      "mutation_type": m.mutationType,
      "reason": m.reason,
      "date": m.date,
    };

    final res = await ApiClient.post(
      '/mutasi',
      body,
      auth: true,
    );

    return res.statusCode == 201 || res.statusCode == 200;
  }

  // =====================================================
  // UPDATE MUTASI
  // =====================================================
  Future<bool> update(int id, MutasiModel m) async {
    final body = {
      "family_id": m.familyId,
      "old_address": m.oldAddress,
      "new_address": m.newAddress,
      "mutation_type": m.mutationType,
      "reason": m.reason,
      "date": m.date,
    };

    final res = await ApiClient.put(
      '/mutasi/$id',
      body,
      auth: true,
    );

    return res.statusCode == 200;
  }

  // =====================================================
  // DELETE MUTASI
  // =====================================================
  Future<bool> delete(int id) async {
    final res = await ApiClient.delete(
      '/mutasi/$id',
      auth: true,
    );

    return res.statusCode == 200;
  }
}
