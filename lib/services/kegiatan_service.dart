// lib/services/kegiatan_service.dart
import 'dart:convert';
import 'dart:developer' as dev;

import 'package:intl/intl.dart';

import 'api_client.dart';

class KegiatanService {
  static KegiatanService instance = KegiatanService();

  // ======== STATIC API (compat) ========
  static Future<List<dynamic>> getKegiatanByRole({
    required int userId,
    required String role,
  }) =>
      instance.getKegiatanByRoleImpl(userId: userId, role: role);

  static Future<Map<String, dynamic>?> getDetail(int id) =>
      instance.getDetailImpl(id);

  static Future<bool> create(Map<String, dynamic> data) =>
      instance.createImpl(data);

  static Future<bool> update(int id, Map<String, dynamic> data) =>
      instance.updateImpl(id, data);

  static Future<bool> delete(int id) => instance.deleteImpl(id);

  // ======== IMPLEMENTATION (instance methods) ========
  Future<List<dynamic>> getKegiatanByRoleImpl({
    required int userId,
    required String role,
  }) async {
    final body = {
      "user_id": userId,
      "role": role,
    };

    dev.log("[KegiatanService] POST /kegiatan/filter-by-role",
        name: "KegiatanService");
    dev.log("[KegiatanService] body = ${jsonEncode(body)}",
        name: "KegiatanService");

    final res = await ApiClient.post(
      '/kegiatan/filter-by-role',
      body,
      auth: false,
    );

    dev.log("[KegiatanService] status = ${res.statusCode}",
        name: "KegiatanService");
    dev.log("[KegiatanService] resp = ${res.body}", name: "KegiatanService");

    if (res.statusCode != 200) {
      throw Exception("Gagal mengambil kegiatan: ${res.statusCode} ${res.body}");
    }

    final decoded = jsonDecode(res.body);
    if (decoded is List) return decoded;

    if (decoded is Map && decoded['data'] is List) {
      return decoded['data'] as List;
    }

    throw Exception("Format response kegiatan tidak valid: ${res.body}");
  }

  Future<Map<String, dynamic>?> getDetailImpl(int id) async {
    dev.log("[KegiatanService] GET /kegiatan/$id", name: "KegiatanService");

    final res = await ApiClient.get('/kegiatan/$id', auth: true);

    dev.log("[KegiatanService] status = ${res.statusCode}",
        name: "KegiatanService");
    dev.log("[KegiatanService] resp = ${res.body}", name: "KegiatanService");

    if (res.statusCode == 200) {
      final decoded = jsonDecode(res.body);
      return decoded is Map<String, dynamic>
          ? decoded
          : Map<String, dynamic>.from(decoded as Map);
    }
    return null;
  }

  String _toIsoDate(dynamic v) {
    if (v == null) return "";

    if (v is DateTime) {
      return DateFormat('yyyy-MM-dd').format(v);
    }

    final s = v.toString().trim();
    if (s.isEmpty) return "";

    final isoPrefix = RegExp(r'^\d{4}-\d{2}-\d{2}');
    if (isoPrefix.hasMatch(s)) {
      return s.substring(0, 10);
    }

    try {
      final dt = DateFormat('d MMM yyyy', 'en_US').parseStrict(s);
      return DateFormat('yyyy-MM-dd').format(dt);
    } catch (_) {}

    try {
      final dt = DateFormat('d MMMM yyyy', 'en_US').parseStrict(s);
      return DateFormat('yyyy-MM-dd').format(dt);
    } catch (_) {}

    try {
      final dt = DateTime.parse(s);
      return DateFormat('yyyy-MM-dd').format(dt);
    } catch (_) {}

    return s;
  }

  int? _asInt(dynamic v) {
    if (v == null) return null;
    if (v is int) return v;
    if (v is num) return v.toInt();
    if (v is String) return int.tryParse(v);
    return null;
  }

  Future<bool> createImpl(Map<String, dynamic> data) async {
    final sessionUserId = 0;

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
      "created_by": createdBy ?? sessionUserId,
    };

    dev.log("[KegiatanService] POST /kegiatan", name: "KegiatanService");
    dev.log("[KegiatanService] payload = ${jsonEncode(payload)}",
        name: "KegiatanService");

    final res = await ApiClient.post('/kegiatan', payload, auth: true);

    dev.log("[KegiatanService] status = ${res.statusCode}",
        name: "KegiatanService");
    dev.log("[KegiatanService] resp = ${res.body}", name: "KegiatanService");

    if (res.statusCode != 201) {
      throw Exception("Create kegiatan gagal: ${res.statusCode} ${res.body}");
    }

    return true;
  }

  Future<bool> updateImpl(int id, Map<String, dynamic> data) async {
    dev.log("[KegiatanService] POST /kegiatan/update/$id",
        name: "KegiatanService");
    dev.log("[KegiatanService] payload = ${jsonEncode(data)}",
        name: "KegiatanService");

    final res = await ApiClient.post('/kegiatan/update/$id', data, auth: true);

    dev.log("[KegiatanService] status = ${res.statusCode}",
        name: "KegiatanService");
    dev.log("[KegiatanService] resp = ${res.body}", name: "KegiatanService");

    if (res.statusCode != 200) {
      throw Exception("Update kegiatan gagal: ${res.statusCode} ${res.body}");
    }
    return true;
  }

  Future<bool> deleteImpl(int id) async {
    dev.log("[KegiatanService] POST /kegiatan/delete/$id",
        name: "KegiatanService");

    final res = await ApiClient.post('/kegiatan/delete/$id', {}, auth: true);

    dev.log("[KegiatanService] status = ${res.statusCode}",
        name: "KegiatanService");
    dev.log("[KegiatanService] resp = ${res.body}", name: "KegiatanService");

    if (res.statusCode != 200) {
      throw Exception("Delete kegiatan gagal: ${res.statusCode} ${res.body}");
    }
    return true;
  }
}
