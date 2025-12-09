// lib/services/api_client.dart
import 'dart:convert';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io' show Platform;

class ApiClient {
  static const String _pcLocalBaseUrl    = 'http://127.0.0.1:9000'; // backend di laptop
  static const String _webBaseUrl        = 'http://127.0.0.1:9000'; // flutter web
  static const String _androidAdbBaseUrl = 'http://127.0.0.1:9000'; // HP fisik via adb reverse
  static const String _androidEmuBaseUrl = 'http://10.0.2.2:9000';  // emulator Android

  static String get baseUrl {
    if (kIsWeb) return _webBaseUrl;

    if (Platform.isAndroid) {
      // HP fisik pakai kabel + `adb reverse tcp:9000 tcp:9000`
      const bool useAdbReverse = true;
      const bool useEmulator   = false;

      if (useEmulator) {
        return _androidEmuBaseUrl;
      }
      if (useAdbReverse) {
        return _androidAdbBaseUrl;
      }

      // fallback kalau suatu saat mau pakai LAN langsung
      return _pcLocalBaseUrl;
    }

    // desktop / iOS
    return _pcLocalBaseUrl;
  }

  static Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  static Future<String?> getToken() => _getToken();

  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  static Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }

  static Future<http.Response> post(
    String path,
    Map<String, dynamic> body, {
    bool auth = false,
  }) async {
    final uri = Uri.parse('$baseUrl$path');
    final headers = <String, String>{'Content-Type': 'application/json'};

    if (auth) {
      final token = await _getToken();
      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }
    }

    try {
      debugPrint('POST $uri');
      final resp = await http
          .post(uri, headers: headers, body: jsonEncode(body))
          .timeout(const Duration(seconds: 10));

      debugPrint('→ ${resp.statusCode} body=${resp.body.isNotEmpty ? resp.body : "(empty)"}');
      return resp;
    } on TimeoutException {
      debugPrint('⚠ Timeout ke $uri');
      rethrow;
    }
  }

  static Future<http.Response> get(
    String path, {
    bool auth = false,
  }) async {
    final uri = Uri.parse('$baseUrl$path');
    final headers = <String, String>{'Content-Type': 'application/json'};

    if (auth) {
      final token = await _getToken();
      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }
    }

    try {
      debugPrint('GET  $uri');
      final resp = await http
          .get(uri, headers: headers)
          .timeout(const Duration(seconds: 10));

      debugPrint('→ ${resp.statusCode} body=${resp.body.isNotEmpty ? resp.body : "(empty)"}');
      return resp;
    } on TimeoutException {
      debugPrint('⚠ Timeout ke $uri');
      rethrow;
    }
  }
}
