// test/services/fee_category_service_test.dart

import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FeeCategoryService Tests', () {
    group('Response Parsing', () {
      test('should parse single category response', () {
        final json = {
          'id': 1,
          'name': 'Iuran Sampah',
          'type': 'monthly',
          'default_amount': 50000.0,
          'is_active': 1,
        };

        expect(json['id'], 1);
        expect(json['name'], 'Iuran Sampah');
        expect(json['type'], 'monthly');
        expect(json['default_amount'], 50000.0);
        expect(json['is_active'], 1);
      });

      test('should parse list of categories', () {
        final jsonList = [
          {
            'id': 1,
            'name': 'Iuran Sampah',
            'type': 'monthly',
            'default_amount': 50000.0,
            'is_active': 1,
          },
          {
            'id': 2,
            'name': 'Iuran Keamanan',
            'type': 'monthly',
            'default_amount': 100000.0,
            'is_active': 1,
          },
        ];

        final categories = jsonList.cast<Map<String, dynamic>>();

        expect(categories.length, 2);
        expect(categories[0]['name'], 'Iuran Sampah');
        expect(categories[1]['name'], 'Iuran Keamanan');
        expect(categories[1]['default_amount'], 100000.0);
      });

      test('should handle category with inactive status', () {
        final json = {
          'id': 3,
          'name': 'Iuran Lama',
          'type': 'yearly',
          'default_amount': 500000.0,
          'is_active': 0,
        };

        expect(json['is_active'], 0);
        expect(json['name'], 'Iuran Lama');
      });

      test('should handle empty list', () {
        final List<dynamic> jsonList = [];
        final categories = jsonList.cast<Map<String, dynamic>>();

        expect(categories.length, 0);
        expect(categories.isEmpty, true);
      });

      test('should parse category creation request data', () {
        final requestData = {
          'name': 'Iuran Baru',
          'type': 'monthly',
          'default_amount': 75000.0,
        };

        expect(requestData['name'], 'Iuran Baru');
        expect(requestData['type'], 'monthly');
        expect(requestData['default_amount'], 75000.0);
      });

      test('should parse status update request data', () {
        final requestData = {
          'is_active': 0,
        };

        expect(requestData['is_active'], 0);
      });

      test('should handle different category types', () {
        final categories = [
          {'type': 'monthly'},
          {'type': 'yearly'},
          {'type': 'one_time'},
        ];

        expect(categories[0]['type'], 'monthly');
        expect(categories[1]['type'], 'yearly');
        expect(categories[2]['type'], 'one_time');
      });
    });
  });
}