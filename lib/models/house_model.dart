class HouseModel {
  final int id;
  final String address;
  final String? area;
  final String? status;
  final int? familyId;

  HouseModel({
    required this.id,
    required this.address,
    this.area,
    this.status,
    this.familyId,
  });

  factory HouseModel.fromJson(Map<String, dynamic> json) {
    return HouseModel(
      id: json['id'],
      address: json['address'],
      area: json['area'],
      status: json['status'],
      familyId: json['family_id'] as int?,
    );
  }
}
