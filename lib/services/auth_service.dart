// lib/services/auth_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import 'api_client.dart';

class AuthService {
  AuthService._();

  static final AuthService instance = AuthService._();

  static const _keyToken     = 'auth_token';
  static const _keyRoleName  = 'role_name';
  static const _keyUserName  = 'user_name';

  // ─────────────────────────────────────────────

  static Future<bool> login(String email, String password) =>
      instance._login(email, password);

  static Future<bool> register({
    required String name,
    required String email,
    required String password,
    String? nik,
    String? phone,
    String? address,
  }) =>
      instance._register(
        name: name,
        email: email,
        password: password,
        nik: nik,
        phone: phone,
        address: address,
      );

  // ─────────────────────────────────────────────

  Future<bool> _login(String email, String password) async {
    final http.Response res = await ApiClient.post(
      '/auth/login',
      {
        'email': email,
        'password': password,
      },
    );

    if (res.statusCode == 200 && res.body.isNotEmpty) {
      final data = jsonDecode(res.body) as Map<String, dynamic>?;

      final token = data?['token'] as String?;
      if (token != null && token.isNotEmpty) {
        await ApiClient.saveToken(token);
        await fetchAndCacheProfile(); // safe now
        return true;
      }
    }

    return false;
  }

  // ─────────────────────────────────────────────

  Future<bool> _register({
    required String name,
    required String email,
    required String password,
    String? nik,
    String? phone,
    String? address,
  }) async {
    final res = await ApiClient.post(
      '/auth/register',
      {
        'name': name,
        'email': email,
        'password': password,
        'nik': nik,
        'phone': phone,
        'address': address,
      },
    );

    return res.statusCode == 201;
  }

  // ─────────────────────────────────────────────
  // PROFILE CACHE (NO NULL)
  // ─────────────────────────────────────────────

  Future<void> fetchAndCacheProfile() async {
    try {
      final res = await ApiClient.get('/auth/me', auth: true);

      if (res.statusCode != 200) {
        debugPrint("⚠ /auth/me gagal: ${res.statusCode}");
        return;
      }

      if (res.body.isEmpty) {
        debugPrint("⚠ /auth/me empty body");
        return;
      }

      final data = jsonDecode(res.body) as Map<String, dynamic>?;

      if (data == null) {
        debugPrint("⚠ /auth/me returned null JSON");
        return;
      }


      final prefs = await SharedPreferences.getInstance();

      final roleName =
          (data['role']?['name'] as String?)?.toLowerCase() ?? 'warga';
      final userName = data['name'] as String? ?? '';

      await prefs.setString(_keyRoleName, roleName);
      await prefs.setString(_keyUserName, userName);
    } catch (e) {
      debugPrint("⚠ fetchAndCacheProfile error: $e");
    }
  }

  // ─────────────────────────────────────────────

  Future<String?> getCachedRoleName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyRoleName);
  }

  Future<String?> getCachedUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUserName);
  }

  // ─────────────────────────────────────────────

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyToken);
    await prefs.remove(_keyRoleName);
    await prefs.remove(_keyUserName);
  }
}
