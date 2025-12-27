// test/services/payment_channel_service_api_test.dart
import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

import 'package:jawaramobile_1/services/payment_channel_service.dart';
import '../helpers/api_test_harness.dart';

void main() {
  ApiTestHarness.init();

  setUp(() async {
    await ApiTestHarness.setUpPrefs(initial: {'auth_token': 'T'});
  });

  tearDown(() {
    ApiTestHarness.tearDownClient();
  });

  test('PaymentChannelService.getChannels success', () async {
    ApiTestHarness.installMockClient({
      'GET /payment-channels': (_) => http.Response(
            jsonEncode([
              {
                'id': 1,
                'name': 'BCA',
                'type': 'bank',
                'account_name': 'A',
                'account_number': '123'
              }
            ]),
            200,
            headers: {'content-type': 'application/json'},
          ),
    });

    final res = await PaymentChannelService.getChannels();
    expect(res.length, 1);
  });

  test('PaymentChannelService.createChannel success', () async {
    ApiTestHarness.installMockClient({
      'POST /payment-channels/': (_) => http.Response(
            jsonEncode({'id': 9}),
            201,
            headers: {'content-type': 'application/json'},
          ),
    });

    final res = await PaymentChannelService.createChannel(
      name: 'BCA',
      type: 'bank',
      accountName: 'A',
      accountNumber: '123',
    );

    expect(res['id'], 9);
  });

  test('PaymentChannelService.getChannels throws on non-200', () async {
    ApiTestHarness.installMockClient({
      'GET /payment-channels': (_) => http.Response('no', 500),
    });

    expect(() => PaymentChannelService.getChannels(), throwsException);
  });
}
