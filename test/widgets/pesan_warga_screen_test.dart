import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jawaramobile_1/models/citizen_message.dart';
import 'package:jawaramobile_1/screens/pesan_warga/pesan_warga_screen.dart';
import 'package:jawaramobile_1/services/citizen_message_service.dart';

class FakeCitizenMessageService extends CitizenMessageService {
  FakeCitizenMessageService(this._messages);

  final List<CitizenMessage> _messages;

  bool createCalled = false;
  String? lastTitle;
  String? lastContent;

  @override
  Future<List<CitizenMessage>> fetchMessages({bool onlyMine = true}) async {
    return _messages;
  }

  @override
  Future<CitizenMessage> createMessage({
    required String title,
    required String content,
  }) async {
    createCalled = true;
    lastTitle = title;
    lastContent = content;

    return CitizenMessage(
      id: 999,
      title: title,
      content: content,
      status: 'pending',
      createdAt: DateTime.parse('2025-12-09T10:00:00Z'),
    );
  }
}

class ErrorFetchCitizenMessageService extends CitizenMessageService {
  @override
  Future<List<CitizenMessage>> fetchMessages({bool onlyMine = true}) async {
    throw Exception('Dummy fetch error');
  }

  @override
  Future<CitizenMessage> createMessage({
    required String title,
    required String content,
  }) {
    throw UnimplementedError();
  }
}

class ErrorCreateCitizenMessageService extends CitizenMessageService {
  ErrorCreateCitizenMessageService(this._messages);

  final List<CitizenMessage> _messages;

  @override
  Future<List<CitizenMessage>> fetchMessages({bool onlyMine = true}) async {
    return _messages;
  }

  @override
  Future<CitizenMessage> createMessage({
    required String title,
    required String content,
  }) async {
    throw Exception('Dummy create error');
  }
}

void main() {
  testWidgets('PesanWargaScreen shows empty text when no messages',
      (WidgetTester tester) async {
    final original = CitizenMessageService.instance;
    final fake = FakeCitizenMessageService([]);

    CitizenMessageService.instance = fake;

    await tester.pumpWidget(
      const MaterialApp(home: PesanWargaScreen()),
    );

    await tester.pumpAndSettle();

    expect(
      find.text('Belum ada pesan. Kirim pesan pertama kamu!'),
      findsOneWidget,
    );

    CitizenMessageService.instance = original;
  });

  testWidgets('PesanWargaScreen shows list of messages',
      (WidgetTester tester) async {
    final original = CitizenMessageService.instance;
    final fake = FakeCitizenMessageService([
      CitizenMessage(
        id: 1,
        title: 'Laporan Jalan',
        content: 'Jalan depan rumah rusak.',
        status: 'pending',
        createdAt: DateTime.parse('2025-12-09T10:00:00Z'),
      ),
    ]);

    CitizenMessageService.instance = fake;

    await tester.pumpWidget(
      const MaterialApp(home: PesanWargaScreen()),
    );
    await tester.pumpAndSettle();

    expect(find.text('Laporan Jalan'), findsOneWidget);
    expect(find.byType(ListTile), findsOneWidget);

    CitizenMessageService.instance = original;
  });

  testWidgets('PesanWargaScreen sends message via dialog',
      (WidgetTester tester) async {
    final original = CitizenMessageService.instance;
    final fake = FakeCitizenMessageService([]);

    CitizenMessageService.instance = fake;

    await tester.pumpWidget(
      const MaterialApp(home: PesanWargaScreen()),
    );
    await tester.pumpAndSettle();

    // buka dialog
    await tester.tap(find.text('Kirim Pesan'));
    await tester.pumpAndSettle();

    // isi form
    await tester.enterText(
        find.byType(TextField).at(0), 'Judul Test Widget');
    await tester.enterText(
        find.byType(TextField).at(1), 'Isi Pesan Test');

    // kirim
    await tester.tap(find.text('Kirim'));
    await tester.pumpAndSettle();

    expect(fake.createCalled, true);
    expect(fake.lastTitle, 'Judul Test Widget');
    expect(fake.lastContent, 'Isi Pesan Test');

    CitizenMessageService.instance = original;
  });

  testWidgets('PesanWargaScreen shows error text when fetch fails',
      (WidgetTester tester) async {
    final original = CitizenMessageService.instance;
    CitizenMessageService.instance = ErrorFetchCitizenMessageService();

    await tester.pumpWidget(
      const MaterialApp(home: PesanWargaScreen()),
    );

    await tester.pump(); // loading -> error
    await tester.pump();

    expect(find.textContaining('Error: Exception: Dummy fetch error'),
        findsOneWidget);

    CitizenMessageService.instance = original;
  });

  testWidgets('PesanWargaScreen shows snackbar when createMessage fails',
      (WidgetTester tester) async {
    final original = CitizenMessageService.instance;
    final fake = ErrorCreateCitizenMessageService([]);

    CitizenMessageService.instance = fake;

    await tester.pumpWidget(
      const MaterialApp(home: PesanWargaScreen()),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Kirim Pesan'));
    await tester.pumpAndSettle();

    await tester.enterText(
        find.byType(TextField).at(0), 'Judul Error Test');
    await tester.enterText(
        find.byType(TextField).at(1), 'Isi Error');

    await tester.tap(find.text('Kirim'));
    await tester.pumpAndSettle();

    expect(
      find.textContaining('Gagal mengirim pesan'),
      findsOneWidget,
    );

    CitizenMessageService.instance = original;
  });
}
