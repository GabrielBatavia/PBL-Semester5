// lib/models/kegiatan.dart

class Kegiatan {
  final int id;
  final String nama;
  final String? kategori;
  final String? pj;
  final String? lokasi;
  final DateTime tanggal;
  final String? deskripsi;
  final String? imageUrl;
  final int createdById;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isDeleted;

  Kegiatan({
    required this.id,
    required this.nama,
    this.kategori,
    this.pj,
    this.lokasi,
    required this.tanggal,
    this.deskripsi,
    this.imageUrl,
    required this.createdById,
    required this.createdAt,
    required this.updatedAt,
    required this.isDeleted,
  });

  factory Kegiatan.fromJson(Map<String, dynamic> json) {
    // bantu konversi int/string -> int
    int _asInt(dynamic v) {
      if (v is int) return v;
      if (v is String) return int.tryParse(v) ?? 0;
      return 0;
    }

    // bantu konversi ke bool (0/1, "0"/"1", true/false)
    bool _asBool(dynamic v) {
      if (v is bool) return v;
      if (v is int) return v != 0;
      if (v is String) return v == '1' || v.toLowerCase() == 'true';
      return false;
    }

    return Kegiatan(
      id: _asInt(json['id']),
      nama: json['nama'] as String,
      kategori: json['kategori'] as String?,
      pj: json['pj'] as String?,
      lokasi: json['lokasi'] as String?,
      tanggal: DateTime.parse(json['tanggal'] as String),
      deskripsi: json['deskripsi'] as String?,
      imageUrl: json['image_url'] as String?,
      createdById: _asInt(json['created_by_id']),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      isDeleted: _asBool(json['is_deleted']),
    );
  }
}
