// test/services/citizen_message_service_api_test.dart
import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

import 'package:jawaramobile_1/services/citizen_message_service.dart';
import '../helpers/api_test_harness.dart';

void main() {
  ApiTestHarness.init();

  setUp(() async {
    await ApiTestHarness.setUpPrefs(initial: {'auth_token': 'T'});
  });

  tearDown(() {
    ApiTestHarness.tearDownClient();
  });

  test('CitizenMessageService.fetchMessages success', () async {
    ApiTestHarness.installMockClient({
      'GET /messages?only_mine=true': (_) => http.Response(
            jsonEncode([
              {'id': 1, 'title': 'A', 'content': 'B'}
            ]),
            200,
            headers: {'content-type': 'application/json'},
          ),
    });

    final svc = CitizenMessageService.instance;
    final res = await svc.fetchMessages(onlyMine: true);
    expect(res.length, 1);
  });

  test('CitizenMessageService.createMessage success', () async {
    ApiTestHarness.installMockClient({
      'POST /messages': (_) => http.Response(
            jsonEncode({'id': 2, 'title': 'T', 'content': 'C'}),
            201,
            headers: {'content-type': 'application/json'},
          ),
    });

    final svc = CitizenMessageService.instance;
    final msg = await svc.createMessage(title: 'T', content: 'C');
    expect(msg.title, 'T');
  });

  test('CitizenMessageService.fetchMessages throws on non-200', () async {
    ApiTestHarness.installMockClient({
      'GET /messages?only_mine=true': (_) => http.Response('bad', 500),
    });

    final svc = CitizenMessageService.instance;
    expect(() => svc.fetchMessages(onlyMine: true), throwsException);
  });
}
