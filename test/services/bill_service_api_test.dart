// test/services/bill_service_api_test.dart
import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

import 'package:jawaramobile_1/services/bill_service.dart';
import '../helpers/api_test_harness.dart';

void main() {
  ApiTestHarness.init();

  setUp(() async {
    await ApiTestHarness.setUpPrefs(initial: {'auth_token': 'T'});
  });

  tearDown(() {
    ApiTestHarness.tearDownClient();
  });

  test('BillService.getBills success', () async {
    ApiTestHarness.installMockClient({
      'GET /bills': (_) => http.Response(
            jsonEncode([
              {'id': 1},
              {'id': 2},
            ]),
            200,
            headers: {'content-type': 'application/json'},
          ),
    });

    final bills = await BillService.getBills();
    expect(bills.length, 2);
  });

  test('BillService.getBills throws with detail', () async {
    ApiTestHarness.installMockClient({
      'GET /bills': (_) => http.Response(
            jsonEncode({'detail': 'Failed'}),
            400,
            headers: {'content-type': 'application/json'},
          ),
    });

    expect(() => BillService.getBills(), throwsException);
  });

  test('BillService.createBillsForAllFamilies success', () async {
    ApiTestHarness.installMockClient({
      'POST /bills/bulk-create/': (_) => http.Response(
            jsonEncode({'ok': true}),
            200,
            headers: {'content-type': 'application/json'},
          ),
    });

    final res = await BillService.createBillsForAllFamilies(
      categoryId: 1,
      amount: 1000,
      periodStart: '2025-01-01',
      periodEnd: '2025-01-31',
    );

    expect(res['ok'], true);
  });

  test('BillService.sendBillNotifications success', () async {
    ApiTestHarness.installMockClient({
      'POST /bills/send-notifications/': (_) => http.Response(
            jsonEncode({'sent': 2}),
            200,
            headers: {'content-type': 'application/json'},
          ),
    });

    final res = await BillService.sendBillNotifications([1, 2]);
    expect(res['sent'], 2);
  });
}
