// test/services/fee_category_service_api_test.dart
import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

import 'package:jawaramobile_1/services/fee_category_service.dart';
import '../helpers/api_test_harness.dart';

void main() {
  ApiTestHarness.init();

  setUp(() async {
    await ApiTestHarness.setUpPrefs(initial: {'auth_token': 'T'});
  });

  tearDown(() {
    ApiTestHarness.tearDownClient();
  });

  test('FeeCategoryService.getCategories success', () async {
    ApiTestHarness.installMockClient({
      'GET /fee-categories': (_) => http.Response(
            jsonEncode([{'id': 1, 'name': 'Kas'}]),
            200,
            headers: {'content-type': 'application/json'},
          ),
    });

    final res = await FeeCategoryService.getCategories();
    expect(res.length, 1);
  });

  test('FeeCategoryService.createCategory success', () async {
    ApiTestHarness.installMockClient({
      'POST /fee-categories/': (_) => http.Response(
            jsonEncode({'id': 2}),
            201,
            headers: {'content-type': 'application/json'},
          ),
    });

    final res = await FeeCategoryService.createCategory(
      name: 'Iuran',
      type: 'income',
      defaultAmount: 1000,
    );

    expect(res['id'], 2);
  });

  test('FeeCategoryService.updateStatus success', () async {
    ApiTestHarness.installMockClient({
      'PATCH /fee-categories/5/status': (_) => http.Response(
            jsonEncode({'ok': true}),
            200,
            headers: {'content-type': 'application/json'},
          ),
    });

    await FeeCategoryService.updateStatus(5, 1);
  });

  test('FeeCategoryService.updateStatus throws when not 200', () async {
    ApiTestHarness.installMockClient({
      'PATCH /fee-categories/5/status': (_) => http.Response(
            jsonEncode({'detail': 'fail'}),
            400,
            headers: {'content-type': 'application/json'},
          ),
    });

    expect(() => FeeCategoryService.updateStatus(5, 0), throwsException);
  });
}
