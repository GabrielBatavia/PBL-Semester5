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
}

