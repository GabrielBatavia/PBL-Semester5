// test/services/activity_service_api_test.dart
import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

import 'package:jawaramobile_1/services/activity_service.dart';
import '../helpers/api_test_harness.dart';

void main() {
  ApiTestHarness.init();

  setUp(() async {
    await ApiTestHarness.setUpPrefs();
  });

  tearDown(() {
    ApiTestHarness.tearDownClient();
  });

  test('ActivityService.getCategoryStats success', () async {
    ApiTestHarness.installMockClient({
      'GET /activities/stats/by-category': (_) => http.Response(
            jsonEncode([
              {'category': 'A', 'count': 2, 'percentage': 50.0},
              {'category': 'B', 'count': 2, 'percentage': 50.0},
            ]),
            200,
            headers: {'content-type': 'application/json'},
          ),
    });

    final stats = await ActivityService.getCategoryStats();
    expect(stats.length, 2);
    expect(stats.first.category, 'A');
    expect(stats.first.count, 2);
  });

  test('ActivityService.getCategoryStats non-200 throws', () async {
    ApiTestHarness.installMockClient({
      'GET /activities/stats/by-category': (_) => http.Response('err', 500),
    });

    expect(() => ActivityService.getCategoryStats(), throwsException);
  });

  test('ActivityService.getCategoryStats invalid format throws', () async {
    ApiTestHarness.installMockClient({
      'GET /activities/stats/by-category': (_) => http.Response(
            jsonEncode({'oops': true}),
            200,
            headers: {'content-type': 'application/json'},
          ),
    });

    expect(() => ActivityService.getCategoryStats(), throwsException);
  });
}
