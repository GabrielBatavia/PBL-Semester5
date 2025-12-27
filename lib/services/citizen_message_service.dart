// lib/services/citizen_message_service.dart
import 'dart:convert';
import '../models/citizen_message.dart';
import 'api_client.dart';

class CitizenMessageService {
  CitizenMessageService();
  static CitizenMessageService instance = CitizenMessageService();

  Future<List<CitizenMessage>> fetchMessages({bool onlyMine = true}) async {
    final res = await ApiClient.get(
      '/messages?only_mine=$onlyMine',
      auth: true,
    );

    if (res.statusCode != 200) {
      throw Exception('Gagal memuat pesan (${res.statusCode})');
    }

    final data = jsonDecode(res.body) as List<dynamic>;
    return data
        .map((e) => CitizenMessage.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<CitizenMessage> createMessage({
    required String title,
    required String content,
  }) async {
    final res = await ApiClient.post(
      '/messages',
      {
        'title': title,
        'content': content,
      },
      auth: true,
    );

    if (res.statusCode != 201) {
      throw Exception('Gagal mengirim pesan (${res.statusCode})');
    }

    final data = jsonDecode(res.body) as Map<String, dynamic>;
    return CitizenMessage.fromJson(data);
  }
}
