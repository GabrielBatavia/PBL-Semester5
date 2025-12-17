// lib/services/kegiatan_service.dart

import 'dart:convert';
import 'dart:developer' as dev;

import 'package:http/http.dart' as http;
import 'package:jawaramobile_1/services/api_client.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class Session {
  static const String keyUserId = "user_id";
  static const String keyRole = "role";

  static Future<void> saveSession({
    required int userId,
    required String role,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(keyUserId, userId);
    await prefs.setString(keyRole, role);
  }

  static Future<int> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(keyUserId) ?? 0;
  }

  static Future<String> getUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(keyRole) ?? "warga";
  }

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

    final body = {
      "user_id": userId,
      "role": role,
    };

    dev.log("[KegiatanService] POST $url", name: "KegiatanService");
    dev.log("[KegiatanService] body = ${jsonEncode(body)}",
        name: "KegiatanService");

    final res = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body),
    );

    dev.log("[KegiatanService] status = ${res.statusCode}",
        name: "KegiatanService");
    dev.log("[KegiatanService] resp = ${res.body}",
        name: "KegiatanService");

    if (res.statusCode != 200) {
      throw Exception("Gagal mengambil kegiatan: ${res.statusCode} ${res.body}");
    }

    return jsonDecode(res.body);
  }

  static Future<Map<String, dynamic>?> getDetail(int id) async {
    dev.log("[KegiatanService] GET /kegiatan/$id", name: "KegiatanService");

    final res = await ApiClient.get('/kegiatan/$id', auth: true);

    dev.log("[KegiatanService] status = ${res.statusCode}",
        name: "KegiatanService");
    dev.log("[KegiatanService] resp = ${res.body}",
        name: "KegiatanService");

    if (res.statusCode == 200) {
      return jsonDecode(res.body) as Map<String, dynamic>;
    }
    return null;
  }

  /// Konversi date jadi "YYYY-MM-DD" dengan aman.
  /// - Kalau DateTime: langsung
  /// - Kalau String ISO "YYYY-MM-DD..." : ambil 10 char
  /// - Kalau String "18 Dec 2025" : parse lalu format
  static String _toIsoDate(dynamic v) {
    if (v == null) return "";

    // DateTime langsung aman
    if (v is DateTime) {
      return DateFormat('yyyy-MM-dd').format(v);
    }

    final s = v.toString().trim();
    if (s.isEmpty) return "";

    // Kalau sudah ISO: 2025-12-18 atau 2025-12-18T...
    final isoPrefix = RegExp(r'^\d{4}-\d{2}-\d{2}');
    if (isoPrefix.hasMatch(s)) {
      return s.substring(0, 10);
    }

    // Kalau format "18 Dec 2025" / "8 Dec 2025"
    // (pakai locale en_US karena month "Dec")
    try {
      final dt = DateFormat('d MMM yyyy', 'en_US').parseStrict(s);
      return DateFormat('yyyy-MM-dd').format(dt);
    } catch (_) {}

    // Kalau format "18 December 2025"
    try {
      final dt = DateFormat('d MMMM yyyy', 'en_US').parseStrict(s);
      return DateFormat('yyyy-MM-dd').format(dt);
    } catch (_) {}

    // Terakhir: coba DateTime.parse (kadang stringnya ISO tapi beda)
    try {
      final dt = DateTime.parse(s);
      return DateFormat('yyyy-MM-dd').format(dt);
    } catch (_) {}

    // Kalau gagal semua, return apa adanya biar kelihatan di log
    return s;
  }

  static int? _asInt(dynamic v) {
    if (v == null) return null;
    if (v is int) return v;
    if (v is String) return int.tryParse(v);
    return null;
  }

  // CREATE
  static Future<bool> create(Map<String, dynamic> data) async {
    // fallback created_by kalau null
    final sessionUserId = await Session.getUserId();

    final createdBy = _asInt(
      data["created_by"] ??
          data["createdById"] ??
          data["created_by_id"] ??
          data["createdById"],
    );

    final payload = <String, dynamic>{
      "name": data["name"] ?? data["nama"],
      "category": data["category"] ?? data["kategori"],
      "pic_name": data["pic_name"] ?? data["pj"] ?? data["picName"],
      "location": data["location"] ?? data["lokasi"],
      "date": _toIsoDate(data["date"] ?? data["tanggal"]),
      "description": data["description"] ?? data["deskripsi"],
      "image_url": data["image_url"] ?? data["imageUrl"],
      "created_by": createdBy ?? sessionUserId, // ✅ fix null
    };

    dev.log("[KegiatanService] POST /kegiatan", name: "KegiatanService");
    dev.log("[KegiatanService] raw data = ${jsonEncode(data)}",
        name: "KegiatanService");
    dev.log("[KegiatanService] payload = ${jsonEncode(payload)}",
        name: "KegiatanService");

    final res = await ApiClient.post('/kegiatan', payload, auth: true);

    dev.log("[KegiatanService] status = ${res.statusCode}",
        name: "KegiatanService");
    dev.log("[KegiatanService] resp = ${res.body}",
        name: "KegiatanService");

    if (res.statusCode != 201) {
      throw Exception("Create kegiatan gagal: ${res.statusCode} ${res.body}");
    }

    return true;
  }

  static Future<bool> update(int id, Map<String, dynamic> data) async {
    dev.log("[KegiatanService] POST /kegiatan/update/$id",
        name: "KegiatanService");
    dev.log("[KegiatanService] payload = ${jsonEncode(data)}",
        name: "KegiatanService");

    final res = await ApiClient.post('/kegiatan/update/$id', data, auth: true);

    dev.log("[KegiatanService] status = ${res.statusCode}",
        name: "KegiatanService");
    dev.log("[KegiatanService] resp = ${res.body}",
        name: "KegiatanService");

    if (res.statusCode != 200) {
      throw Exception("Update kegiatan gagal: ${res.statusCode} ${res.body}");
    }
    return true;
  }

  static Future<bool> delete(int id) async {
    dev.log("[KegiatanService] POST /kegiatan/delete/$id",
        name: "KegiatanService");

    final res = await ApiClient.post('/kegiatan/delete/$id', {}, auth: true);

    dev.log("[KegiatanService] status = ${res.statusCode}",
        name: "KegiatanService");
    dev.log("[KegiatanService] resp = ${res.body}",
        name: "KegiatanService");

    if (res.statusCode != 200) {
      throw Exception("Delete kegiatan gagal: ${res.statusCode} ${res.body}");
    }
    return true;
  }
}
