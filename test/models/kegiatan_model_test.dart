// test/models/kegiatan_model_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:jawaramobile_1/models/kegiatan.dart';

void main() {
  group('Kegiatan model', () {
    test('fromJson parses int, bool, and dates correctly (normal case)', () {
      final json = {
        'id': 5,
        'nama': 'Kerja Bakti',
        'kategori': 'Kebersihan',
        'pj': 'Pak RT',
        'lokasi': 'Lapangan RW',
        'tanggal': '2025-12-31',
        'deskripsi': 'Bersih-bersih lingkungan.',
        'image_url': null,
        'created_by_id': 2,
        'created_at': '2025-12-01T10:00:00Z',
        'updated_at': '2025-12-01T11:00:00Z',
        'is_deleted': false,
      };

      final keg = Kegiatan.fromJson(json);

      expect(keg.id, 5);
      expect(keg.nama, 'Kerja Bakti');
      expect(keg.kategori, 'Kebersihan');
      expect(keg.pj, 'Pak RT');
      expect(keg.lokasi, 'Lapangan RW');
      expect(keg.tanggal, DateTime.parse('2025-12-31'));
      expect(keg.deskripsi, 'Bersih-bersih lingkungan.');
      expect(keg.imageUrl, isNull);
      expect(keg.createdById, 2);
      expect(keg.createdAt, DateTime.parse('2025-12-01T10:00:00Z'));
      expect(keg.updatedAt, DateTime.parse('2025-12-01T11:00:00Z'));
      expect(keg.isDeleted, false);
    });

    test('fromJson converts string/int values to int correctly', () {
      final json = {
        'id': '10', // string
        'nama': 'Rapat RW',
        'tanggal': '2025-10-01',
        'created_by_id': '3', // string
        'created_at': '2025-10-01T08:00:00Z',
        'updated_at': '2025-10-01T08:00:00Z',
        'is_deleted': 0, // int
      };

      final keg = Kegiatan.fromJson(json);

      expect(keg.id, 10);
      expect(keg.createdById, 3);
      expect(keg.isDeleted, false);
    });

    test('fromJson converts various is_deleted representations to bool', () {
      // 1) "1" → true
      final json1 = {
        'id': 1,
        'nama': 'Tes 1',
        'tanggal': '2025-01-01',
        'created_by_id': 1,
        'created_at': '2025-01-01T00:00:00Z',
        'updated_at': '2025-01-01T00:00:00Z',
        'is_deleted': '1',
      };
      final k1 = Kegiatan.fromJson(json1);
      expect(k1.isDeleted, true);

      // 2) "true" → true
      final json2 = {
        'id': 2,
        'nama': 'Tes 2',
        'tanggal': '2025-01-01',
        'created_by_id': 1,
        'created_at': '2025-01-01T00:00:00Z',
        'updated_at': '2025-01-01T00:00:00Z',
        'is_deleted': 'true',
      };
      final k2 = Kegiatan.fromJson(json2);
      expect(k2.isDeleted, true);

      // 3) 0 → false
      final json3 = {
        'id': 3,
        'nama': 'Tes 3',
        'tanggal': '2025-01-01',
        'created_by_id': 1,
        'created_at': '2025-01-01T00:00:00Z',
        'updated_at': '2025-01-01T00:00:00Z',
        'is_deleted': 0,
      };
      final k3 = Kegiatan.fromJson(json3);
      expect(k3.isDeleted, false);
    });
  });
}
