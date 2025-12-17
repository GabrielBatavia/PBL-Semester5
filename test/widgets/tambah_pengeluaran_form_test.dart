// test/widgets/tambah_pengeluaran_form_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jawaramobile_1/widgets/tambah_pengeluaran_form.dart';

void main() {
  group('TambahPengeluaranForm Widget Tests', () {
    testWidgets('should render all form fields', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: TambahPengeluaranForm(),
            ),
          ),
        ),
      );

      // Verify all fields exist
      expect(find.text('Nama Pengeluaran'), findsOneWidget);
      expect(find.text('Pilih Kategori'), findsOneWidget);
      expect(find.text('Nominal'), findsOneWidget);
      expect(find.text('Tanggal Pengeluaran'), findsOneWidget);
    });

    testWidgets('should show validation error when nama is empty', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: TambahPengeluaranForm(),
            ),
          ),
        ),
      );

      final submitButton = find.widgetWithText(ElevatedButton, 'Simpan');
      await tester.tap(submitButton);
      await tester.pumpAndSettle();

      expect(find.text('Nama pengeluaran tidak boleh kosong'), findsOneWidget);
    });

    testWidgets('should show validation error when kategori not selected', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: TambahPengeluaranForm(),
            ),
          ),
        ),
      );

      final namaField = find.byType(TextFormField).first;
      await tester.enterText(namaField, 'Beli Alat Tulis');
      await tester.pump();

      final submitButton = find.widgetWithText(ElevatedButton, 'Simpan');
      await tester.tap(submitButton);
      await tester.pumpAndSettle();

      expect(find.text('Silakan pilih kategori'), findsOneWidget);
    });

    testWidgets('should show validation error when nominal is empty', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: TambahPengeluaranForm(),
            ),
          ),
        ),
      );

      final namaField = find.byType(TextFormField).first;
      await tester.enterText(namaField, 'Test Pengeluaran');
      await tester.pump();

      final submitButton = find.widgetWithText(ElevatedButton, 'Simpan');
      await tester.tap(submitButton);
      await tester.pumpAndSettle();

      expect(find.text('Nominal tidak boleh kosong'), findsOneWidget);
    });

    testWidgets('should open date picker when tanggal field tapped', (WidgetTester tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: SingleChildScrollView(
          child: TambahPengeluaranForm(),
        ),
      ),
    ),
  );
  
  await tester.pumpAndSettle();

  final scrollView = find.byType(SingleChildScrollView);
  await tester.drag(scrollView, const Offset(0, -400));
  await tester.pumpAndSettle();

  final allTextFields = find.byType(TextFormField);
  await tester.tap(allTextFields.at(2));
  await tester.pumpAndSettle();

  expect(find.byType(Dialog), findsOneWidget);
  expect(find.text('OK'), findsOneWidget);
});

    testWidgets('should select kategori from dropdown', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: TambahPengeluaranForm(),
            ),
          ),
        ),
      );

      final dropdown = find.byType(DropdownButtonFormField<String>);
      await tester.tap(dropdown);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Operasional RT/RW').last);
      await tester.pumpAndSettle();

      expect(find.text('Operasional RT/RW'), findsWidgets);
    });

    testWidgets('should show all kategori options', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: TambahPengeluaranForm(),
            ),
          ),
        ),
      );

      await tester.tap(find.byType(DropdownButtonFormField<String>));
      await tester.pumpAndSettle();

      expect(find.text('Operasional RT/RW'), findsOneWidget);
      expect(find.text('Kegiatan Sosial'), findsOneWidget);
      expect(find.text('Pemeliharaan Fasilitas'), findsOneWidget);
      expect(find.text('Pembangunan'), findsOneWidget);
      expect(find.text('Kegiatan Warga'), findsOneWidget);
      expect(find.text('Keamanan & Kebersihan'), findsOneWidget);
      expect(find.text('Lain-lain'), findsOneWidget);
    });

    testWidgets('submit button should be enabled initially', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: TambahPengeluaranForm(),
            ),
          ),
        ),
      );
      
      await tester.pumpAndSettle();
      final scrollView = find.byType(SingleChildScrollView);
      await tester.drag(scrollView, const Offset(0, -500));
      await tester.pumpAndSettle();

      final submitButton = find.widgetWithText(ElevatedButton, 'Simpan');
      final buttonWidget = tester.widget<ElevatedButton>(submitButton);

      expect(buttonWidget.onPressed, isNotNull);
    });

    testWidgets('should accept valid form input', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: TambahPengeluaranForm(),
            ),
          ),
        ),
      );
      
      await tester.pumpAndSettle();

      // Fill nama (first TextFormField - index 0)
      final namaField = find.byType(TextFormField).at(0);
      await tester.enterText(namaField, 'Beli Alat Kebersihan');
      await tester.pumpAndSettle();

      // Select kategori
      await tester.tap(find.byType(DropdownButtonFormField<String>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Keamanan & Kebersihan').last);
      await tester.pumpAndSettle();

      // Fill nominal (second TextFormField - index 1)
      final nominalField = find.byType(TextFormField).at(1);
      await tester.enterText(nominalField, '500000');
      await tester.pumpAndSettle();

      // Manual scroll ke date field - GANTI scrollUntilVisible
      final scrollView = find.byType(SingleChildScrollView);
      await tester.drag(scrollView, const Offset(0, -400));
      await tester.pumpAndSettle();
      
      // Tap date field
      final tanggalField = find.byType(TextFormField).at(2);
      await tester.tap(tanggalField);
      await tester.pumpAndSettle();
      
      // Select today from date picker - find OK button
      final okButton = find.text('OK');
      if (okButton.evaluate().isNotEmpty) {
        await tester.tap(okButton);
        await tester.pumpAndSettle();
      }

      // Form should be valid (no validation errors visible)
      expect(find.textContaining('tidak boleh kosong'), findsNothing);
      expect(find.text('Silakan pilih kategori'), findsNothing);
    });
  });
}