class Activity {
  final int id;
  final String name;
  final String? category;
  final String? picName;
  final String? location;
  final String date;
  final String? description;
  final String? imageUrl;
  final int? createdBy;
  final String? createdAt;
  final String? updatedAt;

  Activity({
    required this.id,
    required this.name,
    this.category,
    this.picName,
    this.location,
    required this.date,
    this.description,
    this.imageUrl,
    this.createdBy,
    this.createdAt,
    this.updatedAt,
  });

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      id: json["id"],
      name: json["name"],
      category: json["category"],
      picName: json["pic_name"],
      location: json["location"],
      date: json["date"],
      description: json["description"],
      imageUrl: json["image_url"],
      createdBy: json["created_by"],
      createdAt: json["created_at"],
      updatedAt: json["updated_at"],
    );
  }

  // ✅ Inilah yang tadi hilang
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "category": category,
      "pic_name": picName,
      "location": location,
      "date": date,
      "description": description,
      "image_url": imageUrl,
      "created_by": createdBy,
      "created_at": createdAt,
      "updated_at": updatedAt,
    };
  }
}
