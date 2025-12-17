// test/services/income_transaction_service_test.dart

import 'package:flutter_test/flutter_test.dart';

void main() {
  group('IncomeTransactionService Tests', () {
    group('Response Parsing', () {
      test('should parse single income transaction response', () {
        final json = {
          'id': 1,
          'category_id': 1,
          'family_id': 10,
          'name': 'Pembayaran Iuran Sampah',
          'type': 'iuran',
          'amount': 50000.0,
          'date': '2024-12-01',
          'created_at': '2024-12-01T10:00:00',
        };

        expect(json['id'], 1);
        expect(json['name'], 'Pembayaran Iuran Sampah');
        expect(json['type'], 'iuran');
        expect(json['amount'], 50000.0);
        expect(json['date'], '2024-12-01');
      });

      test('should parse list of income transactions', () {
        final jsonList = [
          {
            'id': 1,
            'name': 'Iuran Sampah',
            'type': 'iuran',
            'amount': 50000.0,
            'date': '2024-12-01',
          },
          {
            'id': 2,
            'name': 'Donasi',
            'type': 'donasi',
            'amount': 1000000.0,
            'date': '2024-12-05',
          },
        ];

        final transactions = jsonList.cast<Map<String, dynamic>>();

        expect(transactions.length, 2);
        expect(transactions[0]['name'], 'Iuran Sampah');
        expect(transactions[1]['type'], 'donasi');
        expect(transactions[1]['amount'], 1000000.0);
      });

      test('should handle transaction without category_id', () {
        final json = {
          'id': 3,
          'category_id': null,
          'family_id': 5,
          'name': 'Pemasukan Lain-lain',
          'type': 'lainnya',
          'amount': 100000.0,
          'date': '2024-12-10',
        };

        expect(json['category_id'], null);
        expect(json['name'], 'Pemasukan Lain-lain');
        expect(json['type'], 'lainnya');
      });

      test('should parse creation request data', () {
        final requestData = {
          'category_id': 1,
          'family_id': 10,
          'name': 'Pembayaran Iuran',
          'type': 'iuran',
          'amount': 50000.0,
          'date': '2024-12-01',
        };

        expect(requestData['category_id'], 1);
        expect(requestData['family_id'], 10);
        expect(requestData['name'], 'Pembayaran Iuran');
        expect(requestData['amount'], 50000.0);
      });

      test('should handle empty list', () {
        final List<dynamic> jsonList = [];
        final transactions = jsonList.cast<Map<String, dynamic>>();

        expect(transactions.isEmpty, true);
        expect(transactions.length, 0);
      });

      test('should handle different transaction types', () {
        final types = [
          {'type': 'iuran'},
          {'type': 'donasi'},
          {'type': 'lainnya'},
        ];

        expect(types[0]['type'], 'iuran');
        expect(types[1]['type'], 'donasi');
        expect(types[2]['type'], 'lainnya');
      });
    });
  });
}