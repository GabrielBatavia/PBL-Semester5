// lib/services/log_service.dart
import 'dart:async';
import 'dart:convert';
import '../models/log_entry.dart';
import 'api_client.dart';

class LogService {
  LogService._();

  static Future<List<LogEntry>> fetchLogs() async {
    final res = await ApiClient.get('/log-activity', auth: true);

    if (res.statusCode != 200) {
      throw Exception('Gagal memuat log (${res.statusCode})');
    }

    final data = jsonDecode(res.body) as List<dynamic>;
    return data
        .map((e) => LogEntry.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  static Future<List<LogEntry>> fetchLatestLogs({int limit = 3}) async {
    try {
      final res = await ApiClient.get('/logs/latest?limit=$limit', auth: false);

      if (res.statusCode == 200 && res.body.isNotEmpty) {
        final data = jsonDecode(res.body) as List<dynamic>;
        return data
            .map((e) => LogEntry.fromJson(e as Map<String, dynamic>))
            .toList();
      }

      return [];
    } catch (_) {
      return [];
    }
  }

  static Stream<List<LogEntry>> logsStream({
    Duration interval = const Duration(seconds: 5),
  }) async* {
    yield await fetchLogs();
    yield* Stream.periodic(interval).asyncMap((_) => fetchLogs());
  }
}
