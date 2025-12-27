// test/services/marketplace_service_api_test.dart
import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

import 'package:jawaramobile_1/services/marketplace_service.dart';
import '../helpers/api_test_harness.dart';
import '../helpers/fake_http_overrides.dart';

void main() {
  ApiTestHarness.init();

  setUp(() async => ApiTestHarness.setUpPrefs(initial: {'auth_token': 'T'}));
  tearDown(() => ApiTestHarness.tearDownClient());

  test('MarketplaceService.fetchItems success', () async {
    ApiTestHarness.installMockClient({
      'GET /marketplace/items': (_) => http.Response(
            jsonEncode([]),
            200,
            headers: {'content-type': 'application/json'},
          ),
    });

    final svc = MarketplaceService.instance;
    await svc.fetchItems();
  });

  test('MarketplaceService.addItem multipart success (HttpOverrides)', () async {
    // multipart tidak lewat ApiClient client, jadi pakai HttpOverrides
    final overrides = FakeHttpOverrides({
      'POST /marketplace/items': FakeRoute(
        statusCode: 201,
        headers: {'content-type': 'application/json'},
        bodyText: jsonEncode({'id': 1, 'title': 'A', 'price': 10}),
      ),
    });

    // bikin file dummy
    final tmp = Directory.systemTemp.createTempSync();
    final img = File('${tmp.path}/x.jpg')..writeAsBytesSync([0, 1, 2, 3]);

    await HttpOverrides.runZoned(
      () async {
        final svc = MarketplaceService.instance;

        // listen stream untuk memastikan addItem push cache
        final future = svc.items$.first;

        await svc.addItem(title: 'A', price: 10, imageFile: img);

        final items = await future;
        expect(items.isNotEmpty, true);
      },
      createHttpClient: (_) => overrides.createHttpClient(null),
    );
  });

  test('MarketplaceService.analyzeImage multipart success (HttpOverrides)', () async {
    final overrides = FakeHttpOverrides({
      'POST /marketplace/analyze-image': FakeRoute(
        statusCode: 200,
        headers: {'content-type': 'application/json'},
        bodyText: jsonEncode({'class': 'tomato'}),
      ),
    });

    final tmp = Directory.systemTemp.createTempSync();
    final img = File('${tmp.path}/x.jpg')..writeAsBytesSync([0, 1, 2, 3]);

    await HttpOverrides.runZoned(
      () async {
        final svc = MarketplaceService.instance;
        final res = await svc.analyzeImage(img);
        expect(res['class'], 'tomato');
      },
      createHttpClient: (_) => overrides.createHttpClient(null),
    );
  });
}
