// test/services/kegiatan_service_api_test.dart
import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

import 'package:jawaramobile_1/services/kegiatan_service.dart';
import '../helpers/api_test_harness.dart';

void main() {
  ApiTestHarness.init();

  setUp(() async {
    await ApiTestHarness.setUpPrefs(initial: {
      'auth_token': 'T',
      'user_id': 7,
      'role': 'warga',
    });
    await Session.saveSession(userId: 7, role: 'warga');
  });

  tearDown(() => ApiTestHarness.tearDownClient());

  test('KegiatanService endpoints', () async {
    ApiTestHarness.installMockClient({
      'POST /kegiatan/filter-by-role': (_) => http.Response(
            jsonEncode([]),
            200,
            headers: {'content-type': 'application/json'},
          ),
      'GET /kegiatan/1': (_) => http.Response(
            jsonEncode({'id': 1, 'name': 'X'}),
            200,
            headers: {'content-type': 'application/json'},
          ),
      'POST /kegiatan': (_) => http.Response('', 201),
      'POST /kegiatan/update/1': (_) => http.Response('', 200),
      'POST /kegiatan/delete/1': (_) => http.Response('', 200),
    });

    final list = await KegiatanService.getKegiatanByRole(userId: 7, role: 'warga');
    expect(list, isA<List>());

    final detail = await KegiatanService.getDetail(1);
    expect(detail?['id'], 1);

    expect(
      await KegiatanService.create({
        'name': 'A',
        'category': 'B',
        'pic_name': 'C',
        'location': 'D',
        'date': '2025-01-01',
        'description': 'E',
      }),
      true,
    );

    expect(await KegiatanService.update(1, {'name': 'U'}), true);
    expect(await KegiatanService.delete(1), true);
  });
}
