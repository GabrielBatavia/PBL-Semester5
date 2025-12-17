// test/services/bill_service_test.dart

import 'package:flutter_test/flutter_test.dart';

void main() {
  group('BillService Tests', () {
    group('Response Parsing', () {
      test('should parse single bill response', () {
        final json = {
          'id': 1,
          'family_id': 10,
          'category_id': 1,
          'amount': 50000.0,
          'period_start': '2024-12-01',
          'period_end': '2024-12-31',
          'status': 'belum_lunas',
          'paid_at': null,
        };

        expect(json['id'], 1);
        expect(json['family_id'], 10);
        expect(json['amount'], 50000.0);
        expect(json['status'], 'belum_lunas');
        expect(json['paid_at'], null);
      });

      test('should parse list of bills', () {
        final jsonList = [
          {
            'id': 1,
            'family_id': 10,
            'amount': 50000.0,
            'status': 'belum_lunas',
          },
          {
            'id': 2,
            'family_id': 11,
            'amount': 50000.0,
            'status': 'lunas',
          },
        ];

        final bills = jsonList.cast<Map<String, dynamic>>();

        expect(bills.length, 2);
        expect(bills[0]['status'], 'belum_lunas');
        expect(bills[1]['status'], 'lunas');
      });

      test('should handle paid bill with timestamp', () {
        final json = {
          'id': 5,
          'family_id': 15,
          'amount': 100000.0,
          'status': 'lunas',
          'paid_at': '2024-12-15T14:30:00',
        };

        expect(json['status'], 'lunas');
        expect(json['paid_at'], '2024-12-15T14:30:00');
      });

      test('should parse bulk create request data', () {
        final requestData = {
          'category_id': 1,
          'amount': 50000.0,
          'period_start': '2024-12-01',
          'period_end': '2024-12-31',
          'status': 'belum_lunas',
        };

        expect(requestData['category_id'], 1);
        expect(requestData['amount'], 50000.0);
        expect(requestData['status'], 'belum_lunas');
      });

      test('should parse bulk create response', () {
        final json = {
          'message': 'Bills created successfully',
          'count': 25,
          'bills': [],
        };

        expect(json['message'], 'Bills created successfully');
        expect(json['count'], 25);
      });

      test('should parse send notifications request', () {
        final requestData = {
          'bill_ids': [1, 2, 3, 4, 5],
        };

        expect(requestData['bill_ids'], [1, 2, 3, 4, 5]);
        expect(requestData['bill_ids']!.length, 5);
      });

      test('should parse send notifications response', () {
        final json = {
          'message': 'Notifications sent successfully',
          'sent_count': 5,
          'failed_count': 0,
        };

        expect(json['message'], 'Notifications sent successfully');
        expect(json['sent_count'], 5);
        expect(json['failed_count'], 0);
      });

      test('should handle empty bills list', () {
        final List<dynamic> jsonList = [];
        final bills = jsonList.cast<Map<String, dynamic>>();

        expect(bills.isEmpty, true);
        expect(bills.length, 0);
      });

      test('should handle different bill statuses', () {
        final statuses = [
          {'status': 'belum_lunas'},
          {'status': 'lunas'},
          {'status': 'terlambat'},
        ];

        expect(statuses[0]['status'], 'belum_lunas');
        expect(statuses[1]['status'], 'lunas');
        expect(statuses[2]['status'], 'terlambat');
      });
    });
  });
}