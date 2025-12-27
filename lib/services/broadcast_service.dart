// lib/services/broadcast_service.dart
import 'dart:convert';
import 'api_client.dart';

class BroadcastService {
  static Future<Map<String, dynamic>> createBroadcast({
    required String title,
    required String content,
    required int senderId,
  }) async {
    final resp = await ApiClient.post(
      '/broadcast',
      {
        "title": title,
        "content": content,
        "sender_id": senderId,
      },
      auth: false,
    );

    if (resp.statusCode == 201 || resp.statusCode == 200) {
      return jsonDecode(resp.body) as Map<String, dynamic>;
    }
    throw Exception("Gagal membuat broadcast: ${resp.statusCode} ${resp.body}");
  }

  static Future<List<dynamic>> getBroadcastList() async {
    final resp = await ApiClient.get('/broadcast', auth: false);
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
    final resp = await ApiClient.put(
      '/broadcast/$id',
      {
        "title": title,
        "content": content,
        "sender_id": senderId,
      },
      auth: false,
    );

    if (resp.statusCode == 200) {
      return jsonDecode(resp.body) as Map<String, dynamic>;
    }
    throw Exception("Gagal update: ${resp.statusCode} ${resp.body}");
  }

  static Future<bool> deleteBroadcast(dynamic id) async {
    final resp = await ApiClient.delete('/broadcast/$id', auth: false);
    return resp.statusCode == 200 || resp.statusCode == 204;
  }
}
