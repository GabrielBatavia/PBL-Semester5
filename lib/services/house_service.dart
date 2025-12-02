import 'dart:convert';
import 'package:http/http.dart' as http;

import 'api_client.dart';
import '../models/house_model.dart';
import '../models/family_model.dart';

class HouseService {
  HouseService._();
  static final HouseService instance = HouseService._();
  final String baseUrl = "http://127.0.0.1:9000";

  Future<List<HouseModel>> fetchHouses({String? search}) async {
  final url = "$baseUrl/houses?search=${search ?? ''}";
  final response = await http.get(Uri.parse(url));

  if (response.statusCode != 200) {
    throw Exception("Gagal mengambil data dari server");
  }

  final List data = jsonDecode(response.body);
  return data.map((e) => HouseModel.fromJson(e)).toList();
}
Future<List<FamilyModel>> fetchFamiliesByHouse(int houseId) async {
  final url = "$baseUrl/houses/$houseId/families";
  final response = await http.get(Uri.parse(url));

  if (response.statusCode != 200) {
    throw Exception("Gagal memuat keluarga penghuni rumah");
  }

  final List data = jsonDecode(response.body);
  return data.map((e) => FamilyModel.fromJson(e)).toList();
}

}
