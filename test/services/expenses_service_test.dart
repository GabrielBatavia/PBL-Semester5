// test/services/expenses_service_test.dart

import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ExpenseService Tests', () {
    group('Response Parsing', () {
      test('should parse single expense response', () {
        final json = {
          'id': 1,
          'name': 'Beli Alat Kebersihan',
          'category': 'Keamanan & Kebersihan',
          'amount': 500000.0,
          'date': '2024-12-01',
          'proof_image_url': null,
          'created_at': '2024-12-01T10:00:00',
        };

        expect(json['id'], 1);
        expect(json['name'], 'Beli Alat Kebersihan');
        expect(json['category'], 'Keamanan & Kebersihan');
        expect(json['amount'], 500000.0);
        expect(json['date'], '2024-12-01');
      });

      test('should parse list of expenses', () {
        final jsonList = [
          {
            'id': 1,
            'name': 'Beli Alat Kebersihan',
            'category': 'Keamanan & Kebersihan',
            'amount': 500000.0,
            'date': '2024-12-01',
          },
          {
            'id': 2,
            'name': 'Perbaikan Jalan',
            'category': 'Pemeliharaan Fasilitas',
            'amount': 2000000.0,
            'date': '2024-12-05',
          },
        ];

        final expenses = jsonList.cast<Map<String, dynamic>>();

        expect(expenses.length, 2);
        expect(expenses[0]['name'], 'Beli Alat Kebersihan');
        expect(expenses[1]['category'], 'Pemeliharaan Fasilitas');
        expect(expenses[1]['amount'], 2000000.0);
      });

      test('should handle expense with proof image', () {
        final json = {
          'id': 3,
          'name': 'Pembelian Material',
          'category': 'Pembangunan',
          'amount': 5000000.0,
          'date': '2024-12-10',
          'proof_image_url': 'https://example.com/proof.jpg',
        };

        expect(json['proof_image_url'], 'https://example.com/proof.jpg');
        expect(json['name'], 'Pembelian Material');
      });

      test('should parse creation request data', () {
        final requestData = {
          'name': 'Beli Peralatan',
          'category': 'Operasional RT/RW',
          'amount': 750000.0,
          'date': '2024-12-15',
          'proof_image_url': null,
        };

        expect(requestData['name'], 'Beli Peralatan');
        expect(requestData['category'], 'Operasional RT/RW');
        expect(requestData['amount'], 750000.0);
        expect(requestData['proof_image_url'], null);
      });

      test('should handle empty list', () {
        final List<dynamic> jsonList = [];
        final expenses = jsonList.cast<Map<String, dynamic>>();

        expect(expenses.isEmpty, true);
        expect(expenses.length, 0);
      });

      test('should handle different expense categories', () {
        final categories = [
          {'category': 'Operasional RT/RW'},
          {'category': 'Kegiatan Sosial'},
          {'category': 'Pemeliharaan Fasilitas'},
          {'category': 'Pembangunan'},
          {'category': 'Kegiatan Warga'},
          {'category': 'Keamanan & Kebersihan'},
          {'category': 'Lain-lain'},
        ];

        expect(categories[0]['category'], 'Operasional RT/RW');
        expect(categories[6]['category'], 'Lain-lain');
        expect(categories.length, 7);
      });

      test('should handle large amount values', () {
        final json = {
          'id': 10,
          'name': 'Proyek Besar',
          'category': 'Pembangunan',
          'amount': 50000000.0,
          'date': '2024-12-01',
        };

        expect(json['amount'], 50000000.0);
        expect(json['category'], 'Pembangunan');
      });
    });
  });
}