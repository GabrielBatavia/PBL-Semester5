// lib/services/mutation_service.dart
import 'dart:convert';
import '../models/mutations_model.dart';
import 'api_client.dart';

class MutasiService {
  MutasiService._();
  static final MutasiService instance = MutasiService._();

  Future<List<MutasiModel>> fetchMutations({String? search}) async {
    final path = '/mutasi?search=${Uri.encodeQueryComponent(search ?? "")}';
    final res = await ApiClient.get(path, auth: false);

    if (res.statusCode != 200) {
      throw Exception("Gagal memuat data mutasi");
    }

    final List data = jsonDecode(res.body);
    return data.map((e) => MutasiModel.fromJson(e)).toList();
  }

  Future<Map<String, dynamic>?> getById(int id) async {
    final res = await ApiClient.get('/mutasi/$id', auth: true);
    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    }
    return null;
  }

  Future<bool> create(MutasiModel m) async {
    final body = {
      "family_id": m.familyId,
      "old_address": m.oldAddress,
      "new_address": m.newAddress,
      "mutation_type": m.mutationType,
      "reason": m.reason,
      "date": m.date,
    };

    final res = await ApiClient.post('/mutasi', body, auth: true);
    return res.statusCode == 201 || res.statusCode == 200;
  }

  Future<bool> update(int id, MutasiModel m) async {
    final body = {
      "family_id": m.familyId,
      "old_address": m.oldAddress,
      "new_address": m.newAddress,
      "mutation_type": m.mutationType,
      "reason": m.reason,
      "date": m.date,
    };

    final res = await ApiClient.put('/mutasi/$id', body, auth: true);
    return res.statusCode == 200;
  }

  Future<bool> delete(int id) async {
    final res = await ApiClient.delete('/mutasi/$id', auth: true);
    return res.statusCode == 200;
  }
}
