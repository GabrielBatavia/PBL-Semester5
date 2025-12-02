// lib/services/broadcast_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class BroadcastService {
  static const String baseUrl = "http://127.0.0.1:9000";

  static Future<Map<String, dynamic>> createBroadcast({
    required String title,
    required String content,
    required int senderId,
  }) async {
    final resp = await http.post(
      Uri.parse('$baseUrl/broadcast'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "title": title,
        "content": content,
        "sender_id": senderId,
      }),
    );

    if (resp.statusCode == 201 || resp.statusCode == 200) {
      return jsonDecode(resp.body) as Map<String, dynamic>;
    }
    throw Exception("Gagal membuat broadcast: ${resp.statusCode} ${resp.body}");
  }

  static Future<List<dynamic>> getBroadcastList() async {
    final resp = await http.get(Uri.parse('$baseUrl/broadcast'));
    if (resp.statusCode == 200) {
      return jsonDecode(resp.body) as List<dynamic>;
    }
    throw Exception("Gagal mengambil broadcast: ${resp.statusCode} ${resp.body}");
  }

  static Future<Map<String, dynamic>> updateBroadcast({
    required int id,
    required String title,
    required String content,
    required int senderId,
  }) async {
    final resp = await http.put(
      Uri.parse('$baseUrl/broadcast/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "title": title,
        "content": content,
        "sender_id": senderId,
      }),
    );

    if (resp.statusCode == 200) {
      return jsonDecode(resp.body) as Map<String, dynamic>;
    }
    throw Exception("Gagal update: ${resp.statusCode} ${resp.body}");
  }

  static Future<bool> deleteBroadcast(dynamic id) async {
    final resp = await http.delete(Uri.parse('$baseUrl/broadcast/$id'));
    return resp.statusCode == 200 || resp.statusCode == 204;
  }
}