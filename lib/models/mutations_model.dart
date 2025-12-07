class MutasiModel {
  final int id;
  final int familyId;
  final String? familyName;
  final String? oldAddress;
  final String? newAddress;
  final String mutationType;
  final String? reason;
  final String date;


  MutasiModel({
    required this.id,
    required this.familyId,
    this.familyName,
    this.oldAddress,
    this.newAddress,
    required this.mutationType,
    this.reason,
    required this.date,
  });


  factory MutasiModel.fromJson(Map<String, dynamic> json) {
    return MutasiModel(
      id: json['id'],
      familyId: json['family_id'],
      familyName: json['family_name']as String?,
      oldAddress: json['old_address'],
      newAddress: json['new_address'],
      mutationType: json['mutation_type'],
      reason: json['reason'],
      date: json['date'],
    );
  }


  Map<String, dynamic> toJson() => {
    'family_id': familyId,
    'family_name':familyName,
    'old_address': oldAddress,
    'new_address': newAddress,
    'mutation_type': mutationType,
    'reason': reason,
    'date': date,
  };
}