// lib/services/kegiatan_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/kegiatan.dart';
import 'api_client.dart';

class KegiatanService {
  KegiatanService();

  static KegiatanService instance = KegiatanService();
  
  Future<List<Kegiatan>> fetchKegiatan() async {
    final token = await ApiClient.getToken();
    final uri = Uri.parse('${ApiClient.baseUrl}/kegiatan/'); // ← pakai slash

    print('[KegiatanService] GET $uri');
    print('[KegiatanService] token: ${token != null ? token.substring(0, 20) : "null"}');

    final resp = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );

    print('[KegiatanService] status: ${resp.statusCode}');
    print('[KegiatanService] body  : ${resp.body}');

    if (resp.statusCode == 401) {
      throw Exception('Tidak punya akses (401), pastikan sudah login.');
    }

    if (resp.statusCode != 200) {
      throw Exception('Gagal memuat kegiatan (${resp.statusCode}) - ${resp.body}');
    }

    final data = jsonDecode(resp.body) as List<dynamic>;
    return data
        .map((e) => Kegiatan.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> deleteKegiatan(int id) async {
    final token = await ApiClient.getToken();
    final uri = Uri.parse('${ApiClient.baseUrl}/kegiatan/$id');

    final resp = await http.delete(
      uri,
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );

    if (resp.statusCode != 204) {
      throw Exception('Gagal menghapus kegiatan (${resp.statusCode})');
    }
  }
}
