import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:jawaramobile_1/services/api_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Session {
  static const String keyUserId = "user_id";
  static const String keyRole = "role";

  /// Simpan session setelah login
  static Future<void> saveSession({
    required int userId,
    required String role,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(keyUserId, userId);
    await prefs.setString(keyRole, role);
  }

  /// Ambil user id → selalu return int (tidak boleh null)
  static Future<int> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(keyUserId) ?? 0; // default: 0
  }

  /// Ambil role → selalu return String
  static Future<String> getUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(keyRole) ?? "warga"; // default
  }

  /// Hapus session
  static Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(keyUserId);
    await prefs.remove(keyRole);
  }
}

class KegiatanService {
  static String baseUrl = "http://127.0.0.1:9000";

  static Future<List<dynamic>> getKegiatanByRole({
    required int userId,
    required String role,
  }) async {
    final url = Uri.parse("$baseUrl/kegiatan/filter-by-role");

    final res = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "user_id": userId,
        "role": role,
      }),
    );

    if (res.statusCode != 200) {
      throw Exception("Gagal mengambil kegiatan: ${res.body}");
    }

    return jsonDecode(res.body);
  }

  // GET DETAIL
  static Future<Map<String, dynamic>?> getDetail(int id) async {
    final res = await ApiClient.get('/kegiatan/$id', auth: true);

    if (res.statusCode == 200) {
      return jsonDecode(res.body) as Map<String, dynamic>;
    }
    return null;
  }

  // CREATE
  static Future<bool> create(Map<String, dynamic> data) async {
    final res = await ApiClient.post('/kegiatan', data, auth: true);
    return res.statusCode == 201;
  }

  // UPDATE
  static Future<bool> update(int id, Map<String, dynamic> data) async {
    final res = await ApiClient.post('/kegiatan/update/$id', data, auth: true);
    return res.statusCode == 200;
  }

  // DELETE
  static Future<bool> delete(int id) async {
    final res = await ApiClient.post('/kegiatan/delete/$id', {}, auth: true);
    return res.statusCode == 200;
  }
}
