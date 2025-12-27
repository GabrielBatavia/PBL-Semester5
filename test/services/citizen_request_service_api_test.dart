// test/services/citizen_request_service_api_test.dart
import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

import 'package:jawaramobile_1/services/citizen_request_service.dart';
import 'package:jawaramobile_1/models/citizen_request_model.dart';
import '../helpers/api_test_harness.dart';
import '../helpers/fake_http_overrides.dart';

void main() {
  ApiTestHarness.init();

  setUp(() async => ApiTestHarness.setUpPrefs());
  tearDown(() => ApiTestHarness.tearDownClient());

  test('CitizenRequestService getAll/getById/create/update/delete via ApiClient', () async {
    ApiTestHarness.installMockClient({
      'GET /citizen-requests': (_) => http.Response(jsonEncode([]), 200, headers: {'content-type': 'application/json'}),
      'GET /citizen-requests/1': (_) => http.Response(jsonEncode({'id': 1}), 200, headers: {'content-type': 'application/json'}),
      'POST /citizen-requests': (_) => http.Response('', 201),
      'PUT /citizen-requests/1': (_) => http.Response('', 200),
      'DELETE /citizen-requests/1': (_) => http.Response('', 204),
    });

    final svc = CitizenRequestService();
    await svc.getAll();
    await svc.getById(1);

    final m = CitizenRequestModel(name: 'A', nik: '1', email: 'a@a.com', gender: 'L', status: 'pending');
    expect(await svc.create(m), true);
    expect(await svc.update(1, m), true);
    expect(await svc.delete(1), true);
  });

  test('CitizenRequestService.createWithImage multipart success (HttpOverrides)', () async {
    final overrides = FakeHttpOverrides({
      'POST /citizen-requests': FakeRoute(statusCode: 201, bodyText: '{"ok":true}'),
    });

    final tmp = Directory.systemTemp.createTempSync();
    final img = File('${tmp.path}/id.jpg')..writeAsBytesSync([1, 2, 3]);

    await HttpOverrides.runZoned(
      () async {
        final svc = CitizenRequestService();
        final m = CitizenRequestModel(name: 'A', nik: '1', email: 'a@a.com', gender: 'L', status: 'pending');
        final ok = await svc.createWithImage(m, img);
        expect(ok, true);
      },
      createHttpClient: (_) => overrides.createHttpClient(null),
    );
  });
}
