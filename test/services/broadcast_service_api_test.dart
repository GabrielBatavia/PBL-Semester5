// test/services/broadcast_service_api_test.dart
import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

import 'package:jawaramobile_1/services/broadcast_service.dart';
import '../helpers/api_test_harness.dart';

void main() {
  ApiTestHarness.init();

  setUp(() async {
    await ApiTestHarness.setUpPrefs();
  });

  tearDown(() {
    ApiTestHarness.tearDownClient();
  });

  test('BroadcastService create/get/update/delete', () async {
    ApiTestHarness.installMockClient({
      'POST /broadcast': (_) => http.Response(
            jsonEncode({'id': 1, 'title': 'A'}),
            201,
            headers: {'content-type': 'application/json'},
          ),
      'GET /broadcast': (_) => http.Response(
            jsonEncode([{'id': 1}]),
            200,
            headers: {'content-type': 'application/json'},
          ),
      'PUT /broadcast/1': (_) => http.Response(
            jsonEncode({'id': 1, 'title': 'B'}),
            200,
            headers: {'content-type': 'application/json'},
          ),
      'DELETE /broadcast/1': (_) => http.Response('', 204),
    });

    final created = await BroadcastService.createBroadcast(
      title: 'A',
      content: 'X',
      senderId: 1,
    );
    expect(created['id'], 1);

    final list = await BroadcastService.getBroadcastList();
    expect(list.length, 1);

    final updated = await BroadcastService.updateBroadcast(
      id: 1,
      title: 'B',
      content: 'Y',
      senderId: 1,
    );
    expect(updated['title'], 'B');

    final ok = await BroadcastService.deleteBroadcast(1);
    expect(ok, true);
  });
}
