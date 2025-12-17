import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jawaramobile_1/models/marketplace_item.dart';
import 'package:jawaramobile_1/screens/marketplace/marketplace_screen.dart';
import 'package:jawaramobile_1/services/marketplace_service.dart';

class FakeMarketplaceService extends MarketplaceService {
  FakeMarketplaceService(this._items);

  final List<MarketplaceItem> _items;
  final _controller = StreamController<List<MarketplaceItem>>.broadcast();

  @override
  Stream<List<MarketplaceItem>> get items$ => _controller.stream;

  @override
  Future<void> fetchItems() async {
    // tidak emit di sini, kita kontrol manual lewat emitItems()
  }

  void emitItems() {
    _controller.add(_items);
  }

  void disposeFake() {
    _controller.close();
  }
}

class ErrorMarketplaceService extends MarketplaceService {
  ErrorMarketplaceService();

  @override
  Stream<List<MarketplaceItem>> get items$ =>
      Stream<List<MarketplaceItem>>.error(
        Exception('Dummy marketplace error'),
      );

  @override
  Future<void> fetchItems() async {
    // no-op, kita sengaja biarkan kosong
  }
}

MarketplaceItem _sampleItem() {
  return MarketplaceItem(
    id: 1,
    title: 'Tomat Merah',
    description: 'Tomat segar dari kebun.',
    price: 15000,
    unit: 'kg',
    imageUrl: null,
    veggieClass: 'Tomato',
    ownerId: 1,
    createdAt: DateTime.parse('2025-12-09T09:00:00Z'),
  );
}

void main() {
  testWidgets('MarketplaceScreen shows empty state when no items',
      (WidgetTester tester) async {
    final original = MarketplaceService.instance;
    final fake = FakeMarketplaceService([]);

    MarketplaceService.instance = fake;

    await tester.pumpWidget(
      const MaterialApp(home: MarketplaceScreen()),
    );

    await tester.pump(); // attach listener
    fake.emitItems();
    await tester.pump();

    expect(find.text('Belum ada sayuran yang dijual.'), findsOneWidget);

    fake.disposeFake();
    MarketplaceService.instance = original;
  });

  testWidgets('MarketplaceScreen shows list of items',
      (WidgetTester tester) async {
    final original = MarketplaceService.instance;
    final fake = FakeMarketplaceService([_sampleItem()]);

    MarketplaceService.instance = fake;

    await tester.pumpWidget(
      const MaterialApp(home: MarketplaceScreen()),
    );

    await tester.pump();
    fake.emitItems();
    await tester.pump();

    expect(find.text('Tomat Merah'), findsOneWidget);

    fake.disposeFake();
    MarketplaceService.instance = original;
  });

  testWidgets('MarketplaceScreen shows error text when stream has error',
      (WidgetTester tester) async {
    final original = MarketplaceService.instance;
    final fake = ErrorMarketplaceService();

    MarketplaceService.instance = fake;

    await tester.pumpWidget(
      const MaterialApp(home: MarketplaceScreen()),
    );

    // frame pertama: build + subscribe ke stream
    await tester.pump();
    // frame kedua: terima error dari Stream.error(...)
    await tester.pump();

    // cukup cek ada teks error berisi dummy error
    expect(
      find.textContaining('Dummy marketplace error'),
      findsOneWidget,
    );

    MarketplaceService.instance = original;
  });
}
