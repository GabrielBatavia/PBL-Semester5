// lib/services/log_service.dart

import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/log_entry.dart';
import 'api_client.dart';

class LogService {
  LogService._();

  /// Ambil daftar log sekali
  static Future<List<LogEntry>> fetchLogs() async {
    final token = await ApiClient.getToken();
    // SESUAIKAN endpoint dengan backend kamu
    final uri = Uri.parse('${ApiClient.baseUrl}/log-activity');

    final resp = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );

    print('GET /log-activity -> ${resp.statusCode}');
    print(resp.body);

    if (resp.statusCode != 200) {
      throw Exception('Gagal memuat log (${resp.statusCode})');
    }

    final data = jsonDecode(resp.body) as List<dynamic>;
    return data
        .map((e) => LogEntry.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Stream dengan polling tiap [interval]
  static Stream<List<LogEntry>> logsStream({
    Duration interval = const Duration(seconds: 5),
  }) async* {
    // emit pertama
    yield await fetchLogs();

    // polling berkala
    yield* Stream.periodic(interval).asyncMap((_) => fetchLogs());
  }
}
