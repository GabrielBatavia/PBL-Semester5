// lib/services/user_service.dart
import 'dart:convert';
import 'package:jawaramobile_1/models/user.dart';
import 'api_client.dart';

class UserService {
  static Future<List<User>> getUsers() async {
    final res = await ApiClient.get('/users', auth: true);

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body) as List<dynamic>;
      return data.map((e) => User.fromJson(e as Map<String, dynamic>)).toList();
    } else {
      throw Exception('Gagal memuat daftar pengguna (status: ${res.statusCode})');
    }
  }
}
