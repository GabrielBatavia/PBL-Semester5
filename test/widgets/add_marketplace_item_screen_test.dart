import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jawaramobile_1/models/marketplace_item.dart';
import 'package:jawaramobile_1/screens/marketplace/add_marketplace_item_screen.dart';
import 'package:jawaramobile_1/services/marketplace_service.dart';

class FakeAddMarketplaceService extends MarketplaceService {
  bool called = false;
  String? lastTitle;
  double? lastPrice;
  String? lastUnit;
  String? lastDescription;
  String? lastVeggieClass;

  @override
  Stream<List<MarketplaceItem>> get items$ =>
      const Stream<List<MarketplaceItem>>.empty();

  @override
  Future<void> fetchItems() async {
    // no-op
  }

  @override
  Future<void> addItem({
    required String title,
    required double price,
    String? description,
    String? unit,
    String? veggieClass,
    dynamic imageFile,
  }) async {
    called = true;
    lastTitle = title;
    lastPrice = price;
    lastUnit = unit;
    lastDescription = description;
    lastVeggieClass = veggieClass;
  }
}

void main() {
  testWidgets(
      'AddMarketplaceItemScreen shows validation errors when fields are empty',
      (WidgetTester tester) async {
    final original = MarketplaceService.instance;
    final fake = FakeAddMarketplaceService();
    MarketplaceService.instance = fake;

    await tester.binding.setSurfaceSize(const Size(800, 1000));

    await tester.pumpWidget(
      const MaterialApp(home: AddMarketplaceItemScreen()),
    );
    await tester.pumpAndSettle();

    // Tidak perlu scroll, height 1000 sudah cukup
    final submitButton =
        find.widgetWithText(ElevatedButton, 'Pasang di Marketplace');

    await tester.tap(submitButton);
    await tester.pumpAndSettle();

    // validasi nama & harga
    expect(find.text('Nama wajib diisi'), findsOneWidget);
    expect(find.text('Harga wajib diisi'), findsOneWidget);

    // service tidak boleh terpanggil
    expect(fake.called, false);

    MarketplaceService.instance = original;
    await tester.binding.setSurfaceSize(const Size(800, 600));
  });

  testWidgets(
      'AddMarketplaceItemScreen calls addItem with correct values when form valid',
      (WidgetTester tester) async {
    final original = MarketplaceService.instance;
    final fake = FakeAddMarketplaceService();
    MarketplaceService.instance = fake;

    await tester.binding.setSurfaceSize(const Size(800, 1000));

    await tester.pumpWidget(
      const MaterialApp(home: AddMarketplaceItemScreen()),
    );
    await tester.pumpAndSettle();

    // isi nama & harga
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Nama sayuran'),
      'Bayam Hijau',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Harga (Rp)'),
      '12000',
    );

    // satuan & deskripsi
    await tester.enterText(
      find.widgetWithText(
        TextFormField,
        'Satuan (contoh: kg, ikat, pcs)',
      ),
      'kg',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Deskripsi'),
      'Bayam segar',
    );

    final submitButton =
        find.widgetWithText(ElevatedButton, 'Pasang di Marketplace');

    await tester.tap(submitButton);
    await tester.pumpAndSettle();

    expect(fake.called, true);
    expect(fake.lastTitle, 'Bayam Hijau');
    expect(fake.lastPrice, 12000.0);
    expect(fake.lastUnit, 'kg');
    expect(fake.lastDescription, 'Bayam segar');

    MarketplaceService.instance = original;
    await tester.binding.setSurfaceSize(const Size(800, 600));
  });
}
