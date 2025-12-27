// test/services/house_service_api_test.dart
import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

import 'package:jawaramobile_1/services/house_service.dart';
import '../helpers/api_test_harness.dart';

void main() {
  ApiTestHarness.init();

  setUp(() async => ApiTestHarness.setUpPrefs());
  tearDown(() => ApiTestHarness.tearDownClient());

  test('HouseService endpoints', () async {
    ApiTestHarness.installMockClient({
      'GET /houses?search=': (_) => http.Response(jsonEncode([]), 200, headers: {'content-type': 'application/json'}),
      'GET /houses/1/families': (_) => http.Response(jsonEncode([]), 200, headers: {'content-type': 'application/json'}),
      'POST /houses': (_) => http.Response('', 201),
      'PUT /houses/1': (_) => http.Response('', 200),
      'DELETE /houses/1': (_) => http.Response('', 200),
    });

    final svc = HouseService.instance;

    await svc.fetchHouses(search: '');
    await svc.fetchFamiliesByHouse(1);

    expect(await svc.createHouse({'a': 1}), true);
    expect(await svc.updateHouse(1, {'a': 2}), true);
    expect(await svc.deleteHouse(1), true);
  });
}
