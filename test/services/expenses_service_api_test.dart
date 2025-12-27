// test/services/expenses_service_api_test.dart
import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

import 'package:jawaramobile_1/services/expenses_service.dart';
import '../helpers/api_test_harness.dart';

void main() {
  ApiTestHarness.init();

  setUp(() async {
    await ApiTestHarness.setUpPrefs(initial: {'auth_token': 'T'});
  });

  tearDown(() {
    ApiTestHarness.tearDownClient();
  });

  test('ExpenseService.getExpenses supports List response', () async {
    ApiTestHarness.installMockClient({
      'GET /expenses': (_) => http.Response(
            jsonEncode([{'id': 1}]),
            200,
            headers: {'content-type': 'application/json'},
          ),
    });

    final res = await ExpenseService.getExpenses();
    expect(res.length, 1);
  });

  test('ExpenseService.getExpenses supports {data:[...]} response', () async {
    ApiTestHarness.installMockClient({
      'GET /expenses': (_) => http.Response(
            jsonEncode({'data': [{'id': 2}]}),
            200,
            headers: {'content-type': 'application/json'},
          ),
    });

    final res = await ExpenseService.getExpenses();
    expect(res.first['id'], 2);
  });

  test('ExpenseService.createExpense success', () async {
    ApiTestHarness.installMockClient({
      'POST /expenses/': (_) => http.Response(
            jsonEncode({'id': 10}),
            201,
            headers: {'content-type': 'application/json'},
          ),
    });

    final res = await ExpenseService.createExpense(
      name: 'A',
      category: 'B',
      amount: 10,
      date: '2025-01-01',
    );

    expect(res['id'], 10);
  });

  test('ExpenseService.createExpense throws with detail', () async {
    ApiTestHarness.installMockClient({
      'POST /expenses/': (_) => http.Response(
            jsonEncode({'detail': 'bad'}),
            400,
            headers: {'content-type': 'application/json'},
          ),
    });

    expect(
      () => ExpenseService.createExpense(
        name: 'A',
        category: 'B',
        amount: 10,
        date: '2025-01-01',
      ),
      throwsException,
    );
  });
}
