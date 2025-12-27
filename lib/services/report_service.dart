// lib/services/report_service.dart
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'api_client.dart';

class ReportService {
  static Future<String> generateReport({
    required String reportType,
    required String startDate,
    required String endDate,
  }) async {
    final path =
        '/reports/generate?report_type=$reportType&start_date=$startDate&end_date=$endDate';

    final response = await ApiClient.getRaw(
      path,
      auth: true,
      headers: {
        // optional
      },
    );

    if (response.statusCode == 200) {
      if (Platform.isAndroid) {
        final status = await Permission.storage.status;
        if (!status.isGranted) {
          await Permission.storage.request();
        }
      }

      Directory? directory;
      if (Platform.isAndroid) {
        directory = Directory('/storage/emulated/0/Download');
        if (!await directory.exists()) {
          directory = await getExternalStorageDirectory();
        }
      } else {
        directory = await getApplicationDocumentsDirectory();
      }

      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final filename = 'laporan_${reportType}_$timestamp.pdf';
      final filePath = '${directory!.path}/$filename';

      final file = File(filePath);
      await file.writeAsBytes(response.bodyBytes);

      return filePath;
    } else {
      throw Exception('Failed to generate report: ${response.statusCode} ${response.body}');
    }
  }
}
