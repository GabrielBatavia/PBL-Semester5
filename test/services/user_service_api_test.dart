// test/services/user_service_api_test.dart
import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

import 'package:jawaramobile_1/services/user_service.dart';
import '../helpers/api_test_harness.dart';

void main() {
  ApiTestHarness.init();

  setUp(() async => ApiTestHarness.setUpPrefs(initial: {'auth_token': 'T'}));
  tearDown(() => ApiTestHarness.tearDownClient());

  test('UserService.getUsers success', () async {
    ApiTestHarness.installMockClient({
      'GET /users': (_) => http.Response(
            jsonEncode([{'id': 1, 'name': 'A'}]),
            200,
            headers: {'content-type': 'application/json'},
          ),
    });

    final users = await UserService.getUsers();
    expect(users.length, 1);
  });

  test('UserService.getUsers throws on non-200', () async {
    ApiTestHarness.installMockClient({
      'GET /users': (_) => http.Response('bad', 500),
    });

    expect(() => UserService.getUsers(), throwsException);
  });
}
