import 'package:flutter_test/flutter_test.dart';
import 'package:jawaramobile_1/models/activity.dart';

void main() {
  test('Activity model parses JSON sesuai database SQL', () {
    final json = {
      "id": 1,
      "name": "Kerja Bakti Minggu 1",
      "category": "kebersihan",
      "pic_name": "Pak RT",
      "location": "Lapangan",
      "date": "2025-01-10",
      "description": "Kerja bakti rutin.",
      "image_url": null,
      "created_by": 2,
      "created_at": "2025-11-24 11:54:33",
      "updated_at": "2025-11-24 11:54:33"
    };

    final activity = Activity.fromJson(json);

    // TAMPILKAN HASILNYA 🌟
    print("HASIL PARSE MODEL:");
    print(activity.toJson());

    expect(activity.id, 1);
    expect(activity.name, "Kerja Bakti Minggu 1");
    expect(activity.category, "kebersihan");
    expect(activity.picName, "Pak RT");
    expect(activity.location, "Lapangan");
    expect(activity.date, "2025-01-10");
    expect(activity.description, "Kerja bakti rutin.");
    expect(activity.createdBy, 2);
  });
}
