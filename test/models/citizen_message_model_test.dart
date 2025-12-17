// test/models/citizen_message_model_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:jawaramobile_1/models/citizen_message.dart';

void main() {
  group('CitizenMessage model', () {
    test('fromJson parses all fields correctly', () {
      final json = {
        'id': 10,
        'title': 'Laporan Jalan Rusak',
        'content': 'Jalan depan rumah rusak parah.',
        'status': 'pending',
        'created_at': '2025-12-09T10:30:00Z',
      };

      final msg = CitizenMessage.fromJson(json);

      expect(msg.id, 10);
      expect(msg.title, 'Laporan Jalan Rusak');
      expect(msg.content, 'Jalan depan rumah rusak parah.');
      expect(msg.status, 'pending');
      expect(msg.createdAt, DateTime.parse('2025-12-09T10:30:00Z'));
    });

    test('toCreateJson only includes title and content', () {
      final msg = CitizenMessage(
        id: 1,
        title: 'Tes',
        content: 'Isi pesan',
        status: 'pending',
        createdAt: DateTime.parse('2025-12-09T10:30:00Z'),
      );

      final json = msg.toCreateJson();

      expect(json, {
        'title': 'Tes',
        'content': 'Isi pesan',
      });
      // memastikan tidak ada field lain
      expect(json.containsKey('status'), false);
      expect(json.containsKey('created_at'), false);
      expect(json.containsKey('id'), false);
    });
  });
}
