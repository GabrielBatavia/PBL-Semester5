// test/services/family_service_api_test.dart
import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

import 'package:jawaramobile_1/services/family_service.dart';
import '../helpers/api_test_harness.dart';

void main() {
  ApiTestHarness.init();

  setUp(() async {
    await ApiTestHarness.setUpPrefs(initial: {'auth_token': 'T'});
  });

  tearDown(() => ApiTestHarness.tearDownClient());

  test('FamilyService endpoints', () async {
    ApiTestHarness.installMockClient({
      'GET /families/extended?search=': (_) => http.Response(
            jsonEncode([]),
            200,
            headers: {'content-type': 'application/json'},
          ),
      'GET /families/1': (_) => http.Response(
            jsonEncode({'id': 1}),
            200,
            headers: {'content-type': 'application/json'},
          ),
      'POST /families': (_) => http.Response('', 201),
      'PUT /families/1': (_) => http.Response('', 200),
      'DELETE /families/1': (_) => http.Response('', 200),
      'GET /families/1/residents': (_) => http.Response(
            jsonEncode([{'id': 1}]),
            200,
            headers: {'content-type': 'application/json'},
          ),
    });

    final svc = FamilyService.instance;

    final list = await svc.fetchFamilies(search: '');
    expect(list, isA<List>());

    final detail = await svc.getFamilyById(1);
    expect(detail?['id'], 1);

    final c = await svc.createFamily(name: 'X', houseId: 1, status: 'aktif');
    expect(c, true);

    final u = await svc.updateFamily(id: 1, name: 'Y', houseId: 1, status: 'aktif');
    expect(u, true);

    final d = await svc.deleteFamily(1);
    expect(d, true);

    final members = await svc.getFamilyMembers(1);
    expect(members.length, 1);
  });
}
