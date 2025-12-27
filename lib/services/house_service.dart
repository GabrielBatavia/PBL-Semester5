// lib/services/house_service.dart
import 'dart:convert';
import '../models/house_model.dart';
import '../models/family_model.dart';
import 'api_client.dart';

class HouseService {
  HouseService._();
  static final HouseService instance = HouseService._();

  Future<List<HouseModel>> fetchHouses({String? search}) async {
    final path = '/houses?search=${Uri.encodeQueryComponent(search ?? "")}';
    final res = await ApiClient.get(path, auth: false);

    if (res.statusCode != 200) {
      throw Exception("Gagal mengambil data dari server");
    }

    final List data = jsonDecode(res.body);
    return data.map((e) => HouseModel.fromJson(e)).toList();
  }

  Future<List<FamilyModel>> fetchFamiliesByHouse(int houseId) async {
    final res = await ApiClient.get('/houses/$houseId/families', auth: false);

    if (res.statusCode != 200) {
      throw Exception("Gagal memuat keluarga penghuni rumah");
    }

    final List data = jsonDecode(res.body);
    return data.map((e) => FamilyModel.fromJson(e)).toList();
  }

  Future<bool> createHouse(Map<String, dynamic> body) async {
    final res = await ApiClient.post('/houses', body, auth: false);
    return res.statusCode == 201;
  }

  Future<bool> updateHouse(int id, Map<String, dynamic> body) async {
    final res = await ApiClient.put('/houses/$id', body, auth: false);
    return res.statusCode == 200;
  }

  Future<bool> deleteHouse(int id) async {
    final res = await ApiClient.delete('/houses/$id', auth: false);
    return res.statusCode == 200;
  }
}
