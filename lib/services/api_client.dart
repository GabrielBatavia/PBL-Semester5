// lib/services/api_client.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiClient {
  ApiClient._();

  static const String _tokenKey = 'auth_token';

  static String baseUrl = const String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://127.0.0.1:9000',
  );

  static http.Client _client = http.Client();

  static void setHttpClient(http.Client client) {
    _client = client;
  }

  static void resetHttpClient() {
    _client = http.Client();
  }

  static Uri buildUri(String path) {
    final p = path.trim();
    if (p.startsWith('http://') || p.startsWith('https://')) {
      return Uri.parse(p);
    }

    final b = baseUrl.endsWith('/')
        ? baseUrl.substring(0, baseUrl.length - 1)
        : baseUrl;
    final r = p.startsWith('/') ? p : '/$p';
    return Uri.parse('$b$r');
  }

  static String resolveImageUrl(String? imageUrl) {
    final v = (imageUrl ?? '').trim();
    if (v.isEmpty) return '';
    if (v.startsWith('http://') || v.startsWith('https://')) return v;

    final b = baseUrl.endsWith('/')
        ? baseUrl.substring(0, baseUrl.length - 1)
        : baseUrl;

    final path = v.startsWith('/') ? v : '/$v';
    return '$b$path';
  }

  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  static Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }

  static Future<Map<String, String>> _headers({
    bool auth = false,
    Map<String, String>? extra,
    bool jsonContentType = true,
  }) async {
    final headers = <String, String>{};

    if (jsonContentType) {
      headers['Content-Type'] = 'application/json';
    }

    if (auth) {
      final token = await getToken();
      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }
    }

    if (extra != null) {
      headers.addAll(extra);
    }

    return headers;
  }

  static Future<http.Response> get(
    String path, {
    bool auth = false,
    Map<String, String>? headers,
  }) async {
    final uri = buildUri(path);
    return _client.get(
      uri,
      headers: await _headers(auth: auth, extra: headers, jsonContentType: true),
    );
  }

  static Future<http.Response> post(
    String path,
    Object? body, {
    bool auth = false,
    Map<String, String>? headers,
  }) async {
    final uri = buildUri(path);
    return _client.post(
      uri,
      headers: await _headers(auth: auth, extra: headers, jsonContentType: true),
      body: jsonEncode(body ?? {}),
    );
  }

  static Future<http.Response> put(
    String path,
    Object? body, {
    bool auth = false,
    Map<String, String>? headers,
  }) async {
    final uri = buildUri(path);
    return _client.put(
      uri,
      headers: await _headers(auth: auth, extra: headers, jsonContentType: true),
      body: jsonEncode(body ?? {}),
    );
  }

  static Future<http.Response> patch(
    String path,
    Object? body, {
    bool auth = false,
    Map<String, String>? headers,
  }) async {
    final uri = buildUri(path);
    return _client.patch(
      uri,
      headers: await _headers(auth: auth, extra: headers, jsonContentType: true),
      body: jsonEncode(body ?? {}),
    );
  }

  static Future<http.Response> delete(
    String path, {
    bool auth = false,
    Map<String, String>? headers,
  }) async {
    final uri = buildUri(path);
    return _client.delete(
      uri,
      headers: await _headers(auth: auth, extra: headers, jsonContentType: true),
    );
  }

  static Future<http.Response> getRaw(
    String path, {
    bool auth = false,
    Map<String, String>? headers,
  }) async {
    final uri = buildUri(path);
    final h = await _headers(auth: auth, extra: headers, jsonContentType: false);
    return _client.get(uri, headers: h);
  }
}
