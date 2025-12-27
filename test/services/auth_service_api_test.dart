// test/services/auth_service_api_test.dart
import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

import 'package:jawaramobile_1/services/auth_service.dart';
import 'package:jawaramobile_1/services/api_client.dart';
import '../helpers/api_test_harness.dart';

void main() {
  ApiTestHarness.init();

  setUp(() async {
    await ApiTestHarness.setUpPrefs();
  });

  tearDown(() {
    ApiTestHarness.tearDownClient();
  });

  test('AuthService.login success saves token and returns true', () async {
    ApiTestHarness.installMockClient({
      'POST /auth/login': (_) => http.Response(
            jsonEncode({'access_token': 'TOKEN123'}),
            200,
            headers: {'content-type': 'application/json'},
          ),
      'GET /auth/me': (_) => http.Response(
            jsonEncode({'id': 7, 'role': {'name': 'warga'}}),
            200,
            headers: {'content-type': 'application/json'},
          ),
    });

    final ok = await AuthService.login('a@a.com', '123');
    expect(ok, true);

    final token = await ApiClient.getToken();
    expect(token, 'TOKEN123');
  });

  test('AuthService.login wrong credential returns false', () async {
    ApiTestHarness.installMockClient({
      'POST /auth/login': (_) => http.Response('{"detail":"invalid"}', 401),
    });

    final ok = await AuthService.login('a@a.com', 'wrong');
    expect(ok, false);
  });

  test('AuthService.register success returns true when 201', () async {
    ApiTestHarness.installMockClient({
      'POST /auth/register': (_) => http.Response('', 201),
    });

    final ok = await AuthService.register(
      name: 'X',
      email: 'x@x.com',
      password: '123',
      nik: null,
      phone: null,
      address: null,
    );

    expect(ok, true);
  });

  test('AuthService.register returns false when not 201', () async {
    ApiTestHarness.installMockClient({
      'POST /auth/register': (_) => http.Response('{"detail":"bad"}', 400),
    });

    final ok = await AuthService.register(
      name: 'X',
      email: 'x@x.com',
      password: '123',
    );

    expect(ok, false);
  });
}
