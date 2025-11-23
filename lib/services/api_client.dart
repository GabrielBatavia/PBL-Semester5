// lib/services/api_client.dart
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiClient {
  // Sesuaikan host berdasarkan platform
  // Web/desktop  : localhost
  // Android emu  : 10.0.2.2
  static const String _webBaseUrl = 'http://localhost:8000';
  static const String _androidEmulatorBaseUrl = 'http://10.0.2.2:8000';

  static String get baseUrl =>
      kIsWeb ? _webBaseUrl : _androidEmulatorBaseUrl;

  static Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

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
    final headers = <String, String>{
      'Content-Type': 'application/json',
    };

    if (auth) {
      final token = await _getToken();
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }
    }

    return http.post(uri, headers: headers, body: jsonEncode(body));
  }

  static Future<http.Response> get(
    String path, {
    bool auth = false,
  }) async {
    final uri = Uri.parse('$baseUrl$path');
    final headers = <String, String>{
      'Content-Type': 'application/json',
    };

    if (auth) {
      final token = await _getToken();
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }
    }

    return http.get(uri, headers: headers);
  }
}