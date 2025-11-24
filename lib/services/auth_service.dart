// lib/services/auth_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'api_client.dart';

class AuthService {
  AuthService._();

  /// Singleton – bisa dipanggil dengan AuthService.instance
  static final AuthService instance = AuthService._();

  static const _keyToken = 'auth_token';
  static const _keyRoleName = 'role_name';
  static const _keyUserName = 'user_name';

  // ─────────────────────────────────────────────
  // LOGIN & REGISTER (dipakai LoginPage)
  // ─────────────────────────────────────────────

  /// Versi static biar kode lama tetap jalan:
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

  Future<bool> _login(String email, String password) async {
    final http.Response res = await ApiClient.post(
      '/auth/login',
      {
        'email': email,
        'password': password,
      },
    );

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body) as Map<String, dynamic>;
      final token = data['token'] as String?;
      if (token != null) {
        // simpan token untuk dipakai ApiClient
        await ApiClient.saveToken(token);

        // coba ambil profil + role (kalau endpoint /auth/me sudah ada)
        await fetchAndCacheProfile();

        return true;
      }
    }

    return false;
  }

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
  // PROFILE & ROLE CACHE
  // ─────────────────────────────────────────────

  /// Panggil endpoint profil (misal /auth/me) lalu cache role & nama.
  Future<void> fetchAndCacheProfile() async {
    try {
      // SESUAIKAN dengan endpoint backend-mu
      final res = await ApiClient.get(
        '/auth/me', // sementara kalau belum ada, kamu bisa ganti mock
        auth: true,
      );

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body) as Map<String, dynamic>;
        final prefs = await SharedPreferences.getInstance();

        final roleName =
            (data['role']?['name'] as String?)?.toLowerCase() ?? 'warga';
        final userName = data['name'] as String? ?? '';

        await prefs.setString(_keyRoleName, roleName);
        await prefs.setString(_keyUserName, userName);
      }
    } catch (_) {
      // kalau gagal, biarkan saja – nanti default-nya dianggap 'warga'
    }
  }

  /// Dipakai di MenuScreen untuk baca role terakhir.
  Future<String?> getCachedRoleName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyRoleName);
  }

  Future<String?> getCachedUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUserName);
  }

  // ─────────────────────────────────────────────
  // LOGOUT
  // ─────────────────────────────────────────────

  Future<void> logout() async {
    await ApiClient.clearToken();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyRoleName);
    await prefs.remove(_keyUserName);
  }
}
