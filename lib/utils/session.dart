// lib/utils/session.dart
import 'package:shared_preferences/shared_preferences.dart';

class Session {
  static const String _kUserId = 'user_id';
  static const String _kRole = 'role';
  static const String _kToken = 'auth_token';

  static Future<void> saveSession({
    required int userId,
    required String role,
    String? token,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_kUserId, userId);
    await prefs.setString(_kRole, role);
    if (token != null) {
      await prefs.setString(_kToken, token);
    }
  }

  static Future<int> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_kUserId) ?? 0;
  }

  static Future<String> getUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_kRole) ?? '';
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_kToken);
  }

  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kUserId);
    await prefs.remove(_kRole);
    await prefs.remove(_kToken);
  }
}

/// Compatibility layer (biar code lama yang manggil SessionManager tidak error)
class SessionManager {
  static Future<void> saveUserSession({
    required int userId,
    required String role,
    String? token,
  }) async {
    await Session.saveSession(userId: userId, role: role, token: token);
  }

  static Future<String?> getRole() async {
    final prefs = await SharedPreferences.getInstance();
    // dukung dua kemungkinan key (biar aman)
    return prefs.getString('role') ?? prefs.getString('role_name');
  }

  static Future<int?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('user_id');
  }

  static Future<String?> getToken() async {
    return Session.getToken();
  }

  static Future<void> clear() async {
    await Session.clear();
  }
}
