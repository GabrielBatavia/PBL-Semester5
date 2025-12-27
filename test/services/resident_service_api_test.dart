// test/services/resident_service_api_test.dart
import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

import 'package:jawaramobile_1/services/resident_service.dart';
import 'package:jawaramobile_1/models/resident_model.dart';
import '../helpers/api_test_harness.dart';

void main() {
  ApiTestHarness.init();

  setUp(() async => ApiTestHarness.setUpPrefs());
  tearDown(() => ApiTestHarness.tearDownClient());

  test('ResidentService endpoints', () async {
    ApiTestHarness.installMockClient({
      'GET /residents?search=': (_) => http.Response(jsonEncode([]), 200, headers: {'content-type': 'application/json'}),
      'POST /residents': (_) => http.Response('', 201),
      'PUT /residents/1': (_) => http.Response('', 200),
      'DELETE /residents/1': (_) => http.Response('', 200),
    });

    final svc = ResidentService.instance;

    await svc.fetchResidents(search: '');

    final dummy = ResidentModel(
      id: 1,
      name: 'A',
      nik: '1',
      birthDate: '2000-01-01',
      job: 'X',
      gender: 'L',
      familyId: 1,
    );

    expect(await svc.createResident(dummy), true);
    expect(await svc.updateResident(1, dummy), true);
    expect(await svc.deleteResident(1), true);
  });
}
