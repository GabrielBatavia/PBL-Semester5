// lib/services/resident_service.dart
import 'dart:convert';
import '../models/resident_model.dart';
import 'api_client.dart';

class ResidentService {
  ResidentService._();
  static final instance = ResidentService._();

  Future<List<ResidentModel>> fetchResidents({String? search}) async {
    final path = '/residents?search=${Uri.encodeQueryComponent(search?.trim() ?? "")}';
    final res = await ApiClient.get(path, auth: false);

    if (res.statusCode != 200) {
      throw Exception("Gagal mengambil data dari server");
    }

    final List data = jsonDecode(res.body);
    return data.map((e) => ResidentModel.fromJson(e)).toList();
  }

  Future<bool> createResident(ResidentModel resident) async {
    final res = await ApiClient.post(
      '/residents',
      {
        "name": resident.name,
        "nik": resident.nik,
        "birth_date": resident.birthDate,
        "job": resident.job,
        "gender": resident.gender,
        "family_id": resident.familyId,
      },
      auth: false,
    );

    return res.statusCode == 200 || res.statusCode == 201;
  }

  Future<bool> updateResident(int id, ResidentModel resident) async {
    final res = await ApiClient.put(
      '/residents/$id',
      resident.toJson(),
      auth: false,
    );

    return res.statusCode == 200;
  }

  Future<bool> deleteResident(int id) async {
    final res = await ApiClient.delete('/residents/$id', auth: false);
    return res.statusCode == 200;
  }
}
