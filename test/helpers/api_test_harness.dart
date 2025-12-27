// test/helpers/api_test_harness.dart
import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:jawaramobile_1/services/api_client.dart';

typedef RouteKey = String; // "GET /path" or "POST /path?x=1"

class ApiTestHarness {
  static void init() {
    TestWidgetsFlutterBinding.ensureInitialized();
  }

  static Future<void> setUpPrefs({Map<String, Object> initial = const {}}) async {
    SharedPreferences.setMockInitialValues(initial);
  }

  /// routes: key contoh:
  /// - "GET /users"
  /// - "POST /auth/login"
  /// - "GET /messages?only_mine=true"
  static void installMockClient(Map<RouteKey, http.Response Function(http.Request)> routes) {
    ApiClient.baseUrl = 'http://test.local';

    ApiClient.setHttpClient(
      MockClient((req) async {
        final key = _key(req);
        final handler = routes[key];
        if (handler == null) {
          return http.Response(
            jsonEncode({'detail': 'No mock for $key'}),
            500,
            headers: {'content-type': 'application/json'},
          );
        }
        return handler(req);
      }),
    );
  }

  static void tearDownClient() {
    ApiClient.resetHttpClient();
  }

  static String _key(http.Request req) {
    final q = req.url.query.isEmpty ? '' : '?${req.url.query}';
    return '${req.method.toUpperCase()} ${req.url.path}$q';
  }
}
