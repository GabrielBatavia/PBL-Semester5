// test/services/mutation_service_api_test.dart
import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

import 'package:jawaramobile_1/services/mutation_service.dart';
import 'package:jawaramobile_1/models/mutations_model.dart';
import '../helpers/api_test_harness.dart';

void main() {
  ApiTestHarness.init();

  setUp(() async => ApiTestHarness.setUpPrefs(initial: {'auth_token': 'T'}));
  tearDown(() => ApiTestHarness.tearDownClient());

  test('MutasiService endpoints', () async {
    ApiTestHarness.installMockClient({
      'GET /mutasi?search=': (_) => http.Response(jsonEncode([]), 200, headers: {'content-type': 'application/json'}),
      'GET /mutasi/1': (_) => http.Response(jsonEncode({'id': 1}), 200, headers: {'content-type': 'application/json'}),
      'POST /mutasi': (_) => http.Response('', 201),
      'PUT /mutasi/1': (_) => http.Response('', 200),
      'DELETE /mutasi/1': (_) => http.Response('', 200),
    });

    final svc = MutasiService.instance;

    await svc.fetchMutations(search: '');
    final byId = await svc.getById(1);
    expect(byId?['id'], 1);

    final m = MutasiModel(
      id: 1,
      familyId: 1,
      oldAddress: 'A',
      newAddress: 'B',
      mutationType: 'pindah',
      reason: 'x',
      date: '2025-01-01',
    );

    expect(await svc.create(m), true);
    expect(await svc.update(1, m), true);
    expect(await svc.delete(1), true);
  });
}
