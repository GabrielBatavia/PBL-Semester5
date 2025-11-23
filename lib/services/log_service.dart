// lib/services/log_service.dart

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:jawaramobile_1/models/log_entry.dart';
import 'package:jawaramobile_1/services/api_client.dart';

class LogService {
  static Future<List<LogEntry>> fetchLogs() async {
    final http.Response res = await ApiClient.get(
      '/logs',
      auth: true,
    );

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body) as List<dynamic>;
      return data
          .map((e) => LogEntry.fromJson(e as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Gagal memuat log (status: ${res.statusCode})');
    }
  }

  /// Stream untuk materi #12 Streams
  static Stream<List<LogEntry>> logsStream({
    Duration interval = const Duration(seconds: 5),
  }) {
    return Stream.periodic(interval).asyncMap((_) => fetchLogs());
  }
}
