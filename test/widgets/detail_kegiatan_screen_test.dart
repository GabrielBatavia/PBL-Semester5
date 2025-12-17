import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:jawaramobile_1/screens/Kegiatan/detail_kegiatan.dart';
import 'package:jawaramobile_1/screens/Kegiatan/edit_kegiatan.dart';
import 'package:jawaramobile_1/widgets/kegiatan/tambah_kegiatan_form.dart';

final Map<String, String> sampleKegiatanData = {
  'id': '1',
  'nama': 'Kerja Bakti',
  'kategori': 'Kebersihan',
  'pj': 'Pak RT',
  'lokasi': 'Lapangan RW',
  'tanggal': '31 Desember 2025',
  'deskripsi': 'Bersih-bersih kampung.',
};

void main() {
  testWidgets(
    'DetailKegiatanScreen: Edit button navigates to EditKegiatanScreen with initial data',
    (WidgetTester tester) async {
      // Perbesar height supaya layout muat semua
      await tester.binding.setSurfaceSize(const Size(800, 1000));

      final router = GoRouter(
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) =>
                DetailKegiatanScreen(kegiatanData: sampleKegiatanData),
          ),
          GoRoute(
            path: '/edit-kegiatan',
            builder: (context, state) {
              final extra = state.extra as Map<String, String>;
              return EditKegiatanScreen(kegiatanData: extra);
            },
          ),
        ],
      );

      await tester.pumpWidget(MaterialApp.router(
        routerConfig: router,
      ));
      await tester.pumpAndSettle();

      // Cek title layar
      expect(find.text('Detail Kegiatan'), findsOneWidget);
      // Tidak perlu assert 'Kerja Bakti' exactly one (muncul 2x di UI)

      // Tekan tombol Edit
      await tester.tap(find.text('Edit'));
      await tester.pumpAndSettle();

      // Sekarang harus di EditKegiatanScreen
      expect(find.text('Edit Kegiatan'), findsOneWidget);
      expect(find.byType(TambahKegiatanForm), findsOneWidget);

      // cek initialData di form
      final formWidget = tester.widget<TambahKegiatanForm>(
        find.byType(TambahKegiatanForm),
      );

      final initial = formWidget.initialData;
      expect(initial, isNotNull);
      expect(initial!['nama'], 'Kerja Bakti');
      expect(initial['kategori'], 'Kebersihan');
      expect(initial['lokasi'], 'Lapangan RW');
      expect(initial['tanggal'], '31 Desember 2025');

      // optional: kembalikan surface size
      await tester.binding.setSurfaceSize(const Size(800, 600));
    },
  );

  testWidgets(
    'DetailKegiatanScreen: Delete button shows confirmation dialog and cancel closes it',
    (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 1000));

      await tester.pumpWidget(
        MaterialApp(
          home: DetailKegiatanScreen(kegiatanData: sampleKegiatanData),
        ),
      );
      await tester.pumpAndSettle();

      // GANTI bagian ini:
      // await tester.tap(
      //   find.widgetWithText(OutlinedButton, 'Hapus'),
      // );

      // MENJADI:
      final deleteTextFinder = find.text('Hapus');
      expect(deleteTextFinder, findsWidgets); // boleh >1
      await tester.tap(deleteTextFinder.first);
      await tester.pumpAndSettle();

      // Dialog konfirmasi harus muncul
      expect(find.text('Konfirmasi Hapus'), findsOneWidget);
      expect(
        find.text(
          'Apakah Anda yakin ingin menghapus kegiatan ini? Aksi ini tidak dapat dibatalkan.',
        ),
        findsOneWidget,
      );

      // Tekan Batal
      await tester.tap(find.text('Batal'));
      await tester.pumpAndSettle();

      // Dialog hilang
      expect(find.text('Konfirmasi Hapus'), findsNothing);

      await tester.binding.setSurfaceSize(const Size(800, 600));
    },
  );

}
