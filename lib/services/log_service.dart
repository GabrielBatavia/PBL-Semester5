// lib/services/log_service.dart

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:jawaramobile_1/models/log_entry.dart';
import 'api_client.dart';

class LogService {
  static Future<List<LogEntry>> fetchLogs() async {
    final http.Response res = await ApiClient.get(
      '/logs',
      auth: true,
    );

    if (res.statusCode == 200 && res.body.isNotEmpty) {
      final data = jsonDecode(res.body) as List<dynamic>;
      return data
          .map((e) => LogEntry.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    throw Exception('Gagal memuat log (status: ${res.statusCode})');
  }

  // ─────────────────────────────────────────────
  // GET LATEST LOGS (3 terbaru, tanpa auth)
  // ─────────────────────────────────────────────
  
  static Future<List<LogEntry>> fetchLatestLogs({int limit = 3}) async {
    try {
      final http.Response res = await ApiClient.get(
        '/logs/latest?limit=$limit',
        auth: false, // Tidak perlu auth untuk dashboard
      );

      if (res.statusCode == 200 && res.body.isNotEmpty) {
        final data = jsonDecode(res.body) as List<dynamic>;
        return data
            .map((e) => LogEntry.fromJson(e as Map<String, dynamic>))
            .toList();
      }

      return [];
    } catch (e) {
      print('Error fetching latest logs: $e');
      return [];
    }
  }

  // ─────────────────────────────────────────────
  // STREAM FIX (tidak boleh kirim null)
  // ─────────────────────────────────────────────

  static Stream<List<LogEntry>> logsStream({
    Duration interval = const Duration(seconds: 5),
  }) {
    return Stream.periodic(interval).asyncMap((_) async {
      try {
        return await fetchLogs();
      } catch (e) {
        return <LogEntry>[]; // fallback aman
      }
    });
  }
}
