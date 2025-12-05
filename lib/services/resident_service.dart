import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/resident_model.dart';

class ResidentService {
  ResidentService._();
  static final instance = ResidentService._();

  final String baseUrl = "http://127.0.0.1:9000";

  Future<List<ResidentModel>> fetchResidents({String? search}) async {
    final String url =
        "$baseUrl/residents?search=${search != null ? search.trim() : ''}";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode != 200) {
      throw Exception("Gagal mengambil data dari server");
    }

    final List data = jsonDecode(response.body);
    return data.map((e) => ResidentModel.fromJson(e)).toList();
  }
  Future<bool> createResident(ResidentModel resident) async {
    final url = Uri.parse("$baseUrl/residents");

    
  final response = await http.post(
    url,
    headers: {"Content-Type": "application/json"},
    body: jsonEncode({
      "name": resident.name,
      "nik": resident.nik,
      "birth_date": resident.birthDate,
      "job": resident.job,
      "gender": resident.gender,
      "family_id": resident.familyId,
    }),
  );

    return response.statusCode == 200 || response.statusCode == 201;
  }
  Future<bool> updateResident(int id, ResidentModel resident) async {
    final url = "$baseUrl/residents/$id";

    final res = await http.put(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(resident.toJson()),
    );

    return res.statusCode == 200;
  }

  Future<bool> deleteResident(int id) async {
    final url = "$baseUrl/residents/$id";
    final res = await http.delete(Uri.parse(url));
    return res.statusCode == 200;
  }
}

