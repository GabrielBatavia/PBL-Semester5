import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  static const String keyUserId = "user_id";
  static const String keyRole = "role";

  /// Simpan data user setelah login
  static Future<void> saveUserSession({
    required int userId,
    required String role,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(keyUserId, userId);
    await prefs.setString(keyRole, role);
  }

  /// Ambil user ID
  static Future<int?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(keyUserId);
  }

  /// Ambil role user
  static Future<String?> getRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(keyRole);
  }

  /// Hapus session
  static Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(keyUserId);
    await prefs.remove(keyRole);
  }
}