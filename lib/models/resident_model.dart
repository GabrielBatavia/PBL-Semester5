class ResidentModel {
  final int id;
  final int? familyId;
  final String name;
  final String? nik;
  final String? birthDate;
  final String? job;
  final String? gender;
  final int? userId;

  ResidentModel({
    required this.id,
    this.familyId,
    required this.name,
    this.nik,
    this.birthDate,
    this.job,
    this.gender,
    this.userId,
  });

  factory ResidentModel.fromJson(Map<String, dynamic> json) {
    return ResidentModel(
      id: json["id"],
      familyId: json["family_id"],
      name: json["name"],
      nik: json["nik"],
      birthDate: json["birth_date"],
      job: json["job"],
      gender: json["gender"],
      userId: json["user_id"],
    );
  }

  Object? toJson() {
    return {
      "name": name,
      "nik": nik,
      "birth_date": birthDate,
      "job": job,
      "gender": gender,
      "family_id": familyId,
    };
  }

}
