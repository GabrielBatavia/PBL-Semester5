// lib/services/broadcast_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class BroadcastService {
  static const String baseUrl = "http://127.0.0.1:9000";

  /// ================================
  /// CREATE BROADCAST
  /// ================================
  static Future<Map<String, dynamic>> createBroadcast({
    required String title,
    required String content,
    required int senderId,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/broadcast'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "title": title,
        "content": content,
        "sender_id": senderId, // FIXED
      }),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Gagal membuat broadcast: ${response.body}");
    }
  }

  /// ================================
  /// GET ALL BROADCAST
  /// ================================
  static Future<List<Map<String, dynamic>>> getBroadcastList() async {
    final response = await http.get(Uri.parse('$baseUrl/broadcast'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return List<Map<String, dynamic>>.from(data);
    } else {
      throw Exception("Gagal mengambil data broadcast: ${response.body}");
    }
  }

  /// ================================
  /// UPDATE BROADCAST
  /// ================================
  static Future<Map<String, dynamic>> updateBroadcast({
    required int id,
    required String title,
    required String content,
    required int senderId,
  }) async {
    final response = await http.put(
      Uri.parse('$baseUrl/broadcast/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "title": title,
        "content": content,
        "sender_id": senderId, // FIXED
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Gagal update broadcast: ${response.body}");
    }
  }

  /// ================================
  /// DELETE BROADCAST
  /// ================================
  static Future<bool> deleteBroadcast(dynamic id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/broadcast/$id'),
    );

    return response.statusCode == 200 || response.statusCode == 204;
  }
}