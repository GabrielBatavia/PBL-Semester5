// test/services/report_service_api_test.dart
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

import 'package:jawaramobile_1/services/report_service.dart';
import '../helpers/api_test_harness.dart';
import '../helpers/test_channels.dart';

void main() {
  ApiTestHarness.init();

  setUp(() async {
    final tmp = Directory.systemTemp.createTempSync();
    TestChannels.mockPathProvider(tmp.path);

    await ApiTestHarness.setUpPrefs(initial: {'auth_token': 'T'});
  });

  tearDown(() {
    TestChannels.clearPathProviderMock();
    ApiTestHarness.tearDownClient();
  });

  test('ReportService.generateReport writes file when 200', () async {
    ApiTestHarness.installMockClient({
      'GET /reports/generate?report_type=semua&start_date=2025-01-01&end_date=2025-01-31': (_) =>
          http.Response.bytes([1, 2, 3, 4], 200),
    });

    final path = await ReportService.generateReport(
      reportType: 'semua',
      startDate: '2025-01-01',
      endDate: '2025-01-31',
    );

    final f = File(path);
    expect(await f.exists(), true);
    final bytes = await f.readAsBytes();
    expect(bytes.length, 4);
  });

  test('ReportService.generateReport throws when non-200', () async {
    ApiTestHarness.installMockClient({
      'GET /reports/generate?report_type=semua&start_date=2025-01-01&end_date=2025-01-31': (_) =>
          http.Response('fail', 500),
    });

    expect(
      () => ReportService.generateReport(
        reportType: 'semua',
        startDate: '2025-01-01',
        endDate: '2025-01-31',
      ),
      throwsException,
    );
  });
}
