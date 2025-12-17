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

  factory CitizenRequestModel.fromJson(Map<String, dynamic> json) {
    return CitizenRequestModel(
      id: json['id'],
      name: json['name'],
      nik: json['nik'],
      email: json['email'],
      gender: json['gender'],
      identityImageUrl: json['identity_image_url'],
      status: json['status'],
      processedBy: json['processed_by'],
      processedAt: json['processed_at'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
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
