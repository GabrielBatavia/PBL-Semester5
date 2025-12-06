// lib/services/bill_service.dart

import 'dart:convert';
import 'api_client.dart';

class BillService {
  static Future<List<Map<String, dynamic>>> getBills() async {
    final response = await ApiClient.get('/bills', auth: true);
    
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.cast<Map<String, dynamic>>();
    } else {
      final error = json.decode(response.body);
      throw Exception(error['detail'] ?? 'Failed to load bills');
    }
  }

  static Future<Map<String, dynamic>> createBillsForAllFamilies({
    required int categoryId,
    required double amount,
    required String periodStart,
    required String periodEnd,
    String status = 'belum_lunas',
  }) async {
    final response = await ApiClient.post(
      '/bills/bulk-create/',
      {
        'category_id': categoryId,
        'amount': amount,
        'period_start': periodStart,
        'period_end': periodEnd,
        'status': status,
      },
      auth: true,
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      final error = json.decode(response.body);
      throw Exception(error['detail'] ?? 'Failed to create bills');
    }
  }
}