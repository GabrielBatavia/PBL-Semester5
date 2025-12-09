// test/models/katagori_iuran_item_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jawaramobile_1/models/kategori_iuran_item.dart';

void main() {
  group('PemasukanListItem Widget Tests', () {
    testWidgets('should display all provided information correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: PemasukanListItem(
              nama: 'Iuran Sampah',
              jenis: 'Bulanan',
              nominal: 'Rp 50.000',
            ),
          ),
        ),
      );

      expect(find.text('Nama Pemasukan'), findsOneWidget);
      expect(find.text('Iuran Sampah'), findsOneWidget);
      expect(find.text('Jenis Pemasukan'), findsOneWidget);
      expect(find.text('Bulanan'), findsOneWidget);
      expect(find.text('Nominal'), findsOneWidget);
      expect(find.text('Rp 50.000'), findsOneWidget);
    });

    testWidgets('should display empty strings when provided', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: PemasukanListItem(
              nama: '',
              jenis: '',
              nominal: '',
            ),
          ),
        ),
      );

      expect(find.text('Nama Pemasukan'), findsOneWidget);
      expect(find.text('Jenis Pemasukan'), findsOneWidget);
      expect(find.text('Nominal'), findsOneWidget);
    });

    testWidgets('should render as a Card widget', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: PemasukanListItem(
              nama: 'Test',
              jenis: 'Test',
              nominal: 'Test',
            ),
          ),
        ),
      );

      expect(find.byType(Card), findsOneWidget);
    });

    testWidgets('should display large nominal values correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: PemasukanListItem(
              nama: 'Dana Pembangunan',
              jenis: 'Tahunan',
              nominal: 'Rp 10.000.000',
            ),
          ),
        ),
      );

      expect(find.text('Rp 10.000.000'), findsOneWidget);
      expect(find.text('Dana Pembangunan'), findsOneWidget);
      expect(find.text('Tahunan'), findsOneWidget);
    });

    testWidgets('should display special characters in text', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: PemasukanListItem(
              nama: 'Iuran RT/RW & Keamanan',
              jenis: 'Bulanan (Wajib)',
              nominal: 'Rp 25.000,-',
            ),
          ),
        ),
      );

      expect(find.text('Iuran RT/RW & Keamanan'), findsOneWidget);
      expect(find.text('Bulanan (Wajib)'), findsOneWidget);
      expect(find.text('Rp 25.000,-'), findsOneWidget);
    });
  });
}