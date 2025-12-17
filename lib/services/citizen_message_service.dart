// lib/services/citizen_message_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/citizen_message.dart';
import 'api_client.dart';

class CitizenMessageService {
  CitizenMessageService();

  static CitizenMessageService instance = CitizenMessageService();

  Future<List<CitizenMessage>> fetchMessages({bool onlyMine = true}) async {
    final token = await ApiClient.getToken();
    final uri = Uri.parse(
      '${ApiClient.baseUrl}/messages?only_mine=$onlyMine',
    );

    final resp = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );

    if (resp.statusCode != 200) {
      throw Exception('Gagal memuat pesan (${resp.statusCode})');
    }

    final data = jsonDecode(resp.body) as List<dynamic>;
    return data
        .map((e) => CitizenMessage.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<CitizenMessage> createMessage({
    required String title,
    required String content,
  }) async {
    final token = await ApiClient.getToken();
    final uri = Uri.parse('${ApiClient.baseUrl}/messages');

    final resp = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'title': title,
        'content': content,
      }),
    );

    if (resp.statusCode != 201) {
      throw Exception('Gagal mengirim pesan (${resp.statusCode})');
    }

    final data = jsonDecode(resp.body) as Map<String, dynamic>;
    return CitizenMessage.fromJson(data);
  }
}
