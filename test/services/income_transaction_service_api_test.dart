// test/services/income_transaction_service_api_test.dart
import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

import 'package:jawaramobile_1/services/income_transaction_service.dart';
import '../helpers/api_test_harness.dart';

void main() {
  ApiTestHarness.init();

  setUp(() async {
    await ApiTestHarness.setUpPrefs(initial: {'auth_token': 'T'});
  });

  tearDown(() {
    ApiTestHarness.tearDownClient();
  });

  test('IncomeTransactionService.getIncomeTransactions success', () async {
    ApiTestHarness.installMockClient({
      'GET /income-transactions': (_) => http.Response(
            jsonEncode([{'id': 1}]),
            200,
            headers: {'content-type': 'application/json'},
          ),
    });

    final res = await IncomeTransactionService.getIncomeTransactions();
    expect(res.length, 1);
  });

  test('IncomeTransactionService.createIncomeTransaction success', () async {
    ApiTestHarness.installMockClient({
      'POST /income-transactions/': (_) => http.Response(
            jsonEncode({'id': 2}),
            201,
            headers: {'content-type': 'application/json'},
          ),
    });

    final res = await IncomeTransactionService.createIncomeTransaction(
      name: 'X',
      type: 'income',
      amount: 1000,
      date: '2025-01-01',
    );

    expect(res['id'], 2);
  });

  test('IncomeTransactionService.getIncomeTransactions throws', () async {
    ApiTestHarness.installMockClient({
      'GET /income-transactions': (_) => http.Response(
            jsonEncode({'detail': 'bad'}),
            400,
            headers: {'content-type': 'application/json'},
          ),
    });

    expect(() => IncomeTransactionService.getIncomeTransactions(), throwsException);
  });
}
