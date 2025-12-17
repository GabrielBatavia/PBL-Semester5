import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jawaramobile_1/models/kegiatan.dart';
import 'package:jawaramobile_1/screens/Kegiatan/daftar_kegiatan.dart';
import 'package:jawaramobile_1/services/kegiatan_service.dart';

class FakeKegiatanService extends KegiatanService {
  FakeKegiatanService(this._result);

  final List<Kegiatan> _result;

  @override
  Future<List<Kegiatan>> fetchKegiatan() async => _result;

  @override
  Future<void> deleteKegiatan(int id) async {
    // no-op
  }
}

class ErrorKegiatanService extends KegiatanService {
  @override
  Future<List<Kegiatan>> fetchKegiatan() async {
    throw Exception('Dummy kegiatan error');
  }

  @override
  Future<void> deleteKegiatan(int id) async {
    // no-op
  }
}

Kegiatan _sampleKegiatan() {
  return Kegiatan(
    id: 1,
    nama: 'Kerja Bakti',
    kategori: 'Kebersihan',
    pj: 'Pak RT',
    lokasi: 'Lapangan RW',
    tanggal: DateTime.parse('2025-12-31'),
    deskripsi: 'Bersih-bersih kampung.',
    imageUrl: null,
    createdById: 1,
    createdAt: DateTime.parse('2025-12-01T10:00:00Z'),
    updatedAt: DateTime.parse('2025-12-01T10:00:00Z'),
    isDeleted: false,
  );
}

void main() {
  testWidgets('KegiatanScreen shows empty text when no activities',
      (WidgetTester tester) async {
    final original = KegiatanService.instance;
    KegiatanService.instance = FakeKegiatanService([]);

    await tester.pumpWidget(
      const MaterialApp(home: KegiatanScreen()),
    );
    await tester.pumpAndSettle();

    expect(find.text('Belum ada kegiatan tercatat.'), findsOneWidget);

    KegiatanService.instance = original;
  });

  testWidgets('KegiatanScreen shows list of activities with formatted date',
      (WidgetTester tester) async {
    final original = KegiatanService.instance;
    KegiatanService.instance = FakeKegiatanService([_sampleKegiatan()]);

    await tester.pumpWidget(
      const MaterialApp(home: KegiatanScreen()),
    );
    await tester.pumpAndSettle();

    // nama kegiatan
    expect(find.text('Kerja Bakti'), findsOneWidget);

    // tanggal ter-format "31 Desember 2025"
    expect(find.text('31 Desember 2025'), findsOneWidget);

    KegiatanService.instance = original;
  });

  testWidgets('KegiatanScreen shows error text when service fails',
      (WidgetTester tester) async {
    final original = KegiatanService.instance;
    KegiatanService.instance = ErrorKegiatanService();

    await tester.pumpWidget(
      const MaterialApp(home: KegiatanScreen()),
    );

    await tester.pump(); // loading
    await tester.pump(); // error

    expect(
      find.textContaining('Error: Exception: Dummy kegiatan error'),
      findsOneWidget,
    );

    KegiatanService.instance = original;
  });
}
