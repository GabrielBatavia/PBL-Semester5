// lib/services/family_service.dart
import 'dart:convert';
import '../models/family_model.dart';
import 'api_client.dart';

class FamilyService {
  FamilyService._();
  static final FamilyService instance = FamilyService._();

  Future<List<FamilyModel>> fetchFamilies({String? search}) async {
    final path = '/families/extended?search=${Uri.encodeQueryComponent(search ?? "")}';
    final res = await ApiClient.get(path, auth: false);

    if (res.statusCode != 200) {
      throw Exception("Gagal mengambil data dari server");
    }

    final List data = jsonDecode(res.body);
    return data.map((e) => FamilyModel.fromJson(e)).toList();
  }

  Future<Map<String, dynamic>?> getFamilyById(int id) async {
    final res = await ApiClient.get('/families/$id', auth: true);
    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    }
    return null;
  }

  Future<bool> createFamily({
    required String name,
    required int? houseId,
    required String? status,
  }) async {
    final res = await ApiClient.post(
      '/families',
      {
        'name': name,
        'house_id': houseId,
        'status': status,
      },
      auth: true,
    );

    return res.statusCode == 201;
  }

  Future<bool> updateFamily({
    required int id,
    required String name,
    required int? houseId,
    required String? status,
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

  Future<bool> deleteFamily(int id) async {
    final res = await ApiClient.delete('/families/$id', auth: true);
    return res.statusCode == 200;
  }

  Future<List<Map<String, dynamic>>> getFamilyMembers(int familyId) async {
    final res = await ApiClient.get('/families/$familyId/residents', auth: true);

    if (res.statusCode == 200) {
      final List data = jsonDecode(res.body);
      return data.cast<Map<String, dynamic>>();
    }

    return [];
  }
}
