// lib/services/report_service.dart

import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'api_client.dart';

class ReportService {
  static Future<String> generateReport({
    required String reportType,  // pemasukan, pengeluaran, semua
    required String startDate,   // yyyy-MM-dd
    required String endDate,     // yyyy-MM-dd
  }) async {
    // Get token
    final token = await ApiClient.getToken();
    
    // Build URL
    final url = Uri.parse(
      '${ApiClient.baseUrl}/reports/generate?report_type=$reportType&start_date=$startDate&end_date=$endDate'
    );
    
    // Make request
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    
    if (response.statusCode == 200) {
      // Request storage permission
      if (Platform.isAndroid) {
        var status = await Permission.storage.status;
        if (!status.isGranted) {
          await Permission.storage.request();
        }
      }
      
      // Get downloads directory
      Directory? directory;
      if (Platform.isAndroid) {
        directory = Directory('/storage/emulated/0/Download');
        if (!await directory.exists()) {
          directory = await getExternalStorageDirectory();
        }
      } else {
        directory = await getApplicationDocumentsDirectory();
      }
      
      // Generate filename
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final filename = 'laporan_${reportType}_$timestamp.pdf';
      final filePath = '${directory!.path}/$filename';
      
      // Write file
      final file = File(filePath);
      await file.writeAsBytes(response.bodyBytes);
      
      return filePath;
    } else {
      throw Exception('Failed to generate report: ${response.statusCode}');
    }
  }
}