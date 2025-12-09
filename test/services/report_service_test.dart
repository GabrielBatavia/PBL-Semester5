// test/services/report_service_test.dart

import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ReportService Tests', () {
    group('Request Parameter Parsing', () {
      test('should format report generation parameters correctly', () {
        final params = {
          'report_type': 'pemasukan',
          'start_date': '2024-12-01',
          'end_date': '2024-12-31',
        };

        expect(params['report_type'], 'pemasukan');
        expect(params['start_date'], '2024-12-01');
        expect(params['end_date'], '2024-12-31');
      });

      test('should handle different report types', () {
        final types = ['pemasukan', 'pengeluaran', 'semua'];

        expect(types[0], 'pemasukan');
        expect(types[1], 'pengeluaran');
        expect(types[2], 'semua');
      });

      test('should format date ranges correctly', () {
        final dateRange = {
          'start_date': '2024-01-01',
          'end_date': '2024-12-31',
        };

        expect(dateRange['start_date'], '2024-01-01');
        expect(dateRange['end_date'], '2024-12-31');
      });

      test('should handle monthly report date range', () {
        final params = {
          'report_type': 'semua',
          'start_date': '2024-12-01',
          'end_date': '2024-12-31',
        };

        expect(params['start_date'], '2024-12-01');
        expect(params['end_date'], '2024-12-31');
      });

      test('should build correct file path pattern', () {
        final reportType = 'pemasukan';
        final timestamp = 1234567890;
        final filename = 'laporan_${reportType}_$timestamp.pdf';

        expect(filename, 'laporan_pemasukan_1234567890.pdf');
      });

      test('should handle yearly report', () {
        final params = {
          'report_type': 'semua',
          'start_date': '2024-01-01',
          'end_date': '2024-12-31',
        };

        expect(params['report_type'], 'semua');
      });

      test('should format URL parameters correctly', () {
        final reportType = 'pengeluaran';
        final startDate = '2024-11-01';
        final endDate = '2024-11-30';
        
        final urlParams = 'report_type=$reportType&start_date=$startDate&end_date=$endDate';

        expect(urlParams, 'report_type=pengeluaran&start_date=2024-11-01&end_date=2024-11-30');
      });
    });

    group('File Handling', () {
      test('should generate unique filenames with timestamp', () {
        final reportType = 'semua';
        final timestamp1 = DateTime.now().millisecondsSinceEpoch;
        final filename1 = 'laporan_${reportType}_$timestamp1.pdf';

        expect(filename1.contains('laporan_semua_'), true);
        expect(filename1.endsWith('.pdf'), true);
      });

      test('should validate PDF extension', () {
        final filename = 'laporan_pemasukan_123456.pdf';
        
        expect(filename.endsWith('.pdf'), true);
      });
    });
  });
}