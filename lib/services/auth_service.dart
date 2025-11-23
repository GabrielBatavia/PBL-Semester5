// lib/services/auth_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:jawaramobile_1/services/api_client.dart';

class AuthService {
  static Future<bool> login(String email, String password) async {
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
        await ApiClient.saveToken(token);
        return true;
      }
    }

    return false;
  }

  static Future<bool> register({
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
}
