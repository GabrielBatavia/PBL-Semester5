// test/models/marketplace_item_model_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:jawaramobile_1/models/marketplace_item.dart';

void main() {
  group('MarketplaceItem model', () {
    test('fromJson parses all fields correctly', () {
      final json = {
        'id': 7,
        'title': 'Tomat Merah',
        'description': 'Tomat segar dari kebun sendiri.',
        'price': 15000, // bisa int atau double
        'unit': 'kg',
        'image_url': 'http://example.com/tomat.jpg',
        'veggie_class': 'Tomato',
        'owner_id': 1,
        'created_at': '2025-12-09T09:00:00Z',
      };

      final item = MarketplaceItem.fromJson(json);

      expect(item.id, 7);
      expect(item.title, 'Tomat Merah');
      expect(item.description, 'Tomat segar dari kebun sendiri.');
      expect(item.price, 15000.0); // harus double
      expect(item.unit, 'kg');
      expect(item.imageUrl, 'http://example.com/tomat.jpg');
      expect(item.veggieClass, 'Tomato');
      expect(item.ownerId, 1);
      expect(item.createdAt, DateTime.parse('2025-12-09T09:00:00Z'));
    });

    test('fromJson handles null optional fields', () {
      final json = {
        'id': 8,
        'title': 'Bayam',
        'description': null,
        'price': 5000,
        'unit': null,
        'image_url': null,
        'veggie_class': null,
        'owner_id': 2,
        'created_at': '2025-12-09T09:30:00Z',
      };

      final item = MarketplaceItem.fromJson(json);

      expect(item.description, isNull);
      expect(item.unit, isNull);
      expect(item.imageUrl, isNull);
      expect(item.veggieClass, isNull);
    });
  });
}
