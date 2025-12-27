// lib/models/citizen_request_model.dart
class CitizenRequestModel {
  final int? id;
  final String name;
  final String nik;
  final String email;
  final String? gender;
  final String? identityImageUrl;
  final String status;
  final int? processedBy;
  final String? processedAt;
  final String? createdAt;
  final String? updatedAt;

  CitizenRequestModel({
    this.id,
    required this.name,
    required this.nik,
    required this.email,
    this.gender,
    this.identityImageUrl,
    this.status = "pending",
    this.processedBy,
    this.processedAt,
    this.createdAt,
    this.updatedAt,
  });

  static int? _asIntNullable(dynamic v) {
    if (v == null) return null;
    if (v is int) return v;
    if (v is num) return v.toInt();
    if (v is String) return int.tryParse(v);
    return null;
  }

  factory CitizenRequestModel.fromJson(Map<String, dynamic> json) {
    return CitizenRequestModel(
      id: _asIntNullable(json['id']),
      name: json['name']?.toString() ?? '',
      nik: json['nik']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      gender: json['gender']?.toString(),
      identityImageUrl: json['identity_image_url']?.toString(),
      status: json['status']?.toString() ?? "pending",
      processedBy: _asIntNullable(json['processed_by']),
      processedAt: json['processed_at']?.toString(),
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "nik": nik,
      "email": email,
      "gender": gender,
      "identity_image_url": identityImageUrl,
      "status": status,
      "processed_by": processedBy,
      "processed_at": processedAt,
    };
  }
}
