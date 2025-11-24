import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:jawaramobile_1/services/activity_service.dart';

class MockClient extends Mock implements http.Client {}

void main() {
  group('ActivityService Test', () {
    test('Fetch activities sesuai struktur SQL', () async {
      final client = MockClient();
      final service = ActivityService();

      final mockJson = jsonEncode([
        {
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
        }
      ]);

      when(client.get(Uri.parse("${service.baseUrl}/activities")))
          .thenAnswer((_) async => http.Response(mockJson, 200));

      final activities = await service.fetchActivities();

      expect(activities.isNotEmpty, true);
      expect(activities.first.id, 1);
      expect(activities.first.name, "Kerja Bakti Minggu 1");
    });
  });
}
