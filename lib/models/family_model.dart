class FamilyModel {
  final int id;
  final String name;
  final int? houseId;
  final String status;

  // Tambahan dari JOIN (bukan kolom database asli)
  final String? address;     
  final int jumlahAnggota;   

  FamilyModel({
    required this.id,
    required this.name,
    required this.houseId,
    required this.status,
    this.address,
    this.jumlahAnggota = 0,
  });

  factory FamilyModel.fromJson(Map<String, dynamic> json) {
    return FamilyModel(
      id: json['id'],
      name: json['name'],
      houseId: json['house_id'],
      status: json['status'],
      address: json['address'],              // dari join
      jumlahAnggota: json['jumlah_anggota'] ?? 0, // dari join
    );
  }
}
