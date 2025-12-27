// test/services/log_service_api_test.dart
import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

import 'package:jawaramobile_1/services/log_service.dart';
import '../helpers/api_test_harness.dart';

void main() {
  ApiTestHarness.init();

  setUp(() async => ApiTestHarness.setUpPrefs(initial: {'auth_token': 'T'}));
  tearDown(() => ApiTestHarness.tearDownClient());

  test('LogService.fetchLogs success', () async {
    ApiTestHarness.installMockClient({
      'GET /log-activity': (_) => http.Response(
            jsonEncode([{'id': 1, 'action': 'x'}]),
            200,
            headers: {'content-type': 'application/json'},
          ),
    });

    final logs = await LogService.fetchLogs();
    expect(logs.length, 1);
  });

  test('LogService.fetchLatestLogs success (no auth)', () async {
    ApiTestHarness.installMockClient({
      'GET /logs/latest?limit=3': (_) => http.Response(
            jsonEncode([{'id': 1}]),
            200,
            headers: {'content-type': 'application/json'},
          ),
    });

    final logs = await LogService.fetchLatestLogs(limit: 3);
    expect(logs.length, 1);
  });

  test('LogService.logsStream emits list', () async {
    ApiTestHarness.installMockClient({
      'GET /log-activity': (_) => http.Response(
            jsonEncode([]),
            200,
            headers: {'content-type': 'application/json'},
          ),
    });

    final stream = LogService.logsStream(interval: const Duration(milliseconds: 10));
    final first = await stream.first;
    expect(first, isA<List>());
  });
}
