// lib/services/income_transaction_service.dart
import 'dart:convert';
import 'api_client.dart';

class IncomeTransactionService {
  static Future<List<Map<String, dynamic>>> getIncomeTransactions() async {
    final response = await ApiClient.get('/income-transactions', auth: true);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.cast<Map<String, dynamic>>();
    } else {
      final error = json.decode(response.body);
      throw Exception(error['detail'] ?? 'Failed to load income transactions');
    }
  }

  static Future<Map<String, dynamic>> createIncomeTransaction({
    int? categoryId,
    int? familyId,
    required String name,
    required String type,
    required double amount,
    required String date,
  }) async {
    final response = await ApiClient.post(
      '/income-transactions/',
      {
        'category_id': categoryId,
        'family_id': familyId,
        'name': name,
        'type': type,
        'amount': amount,
        'date': date,
      },
      auth: true,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return json.decode(response.body);
    } else {
      final error = json.decode(response.body);
      throw Exception(error['detail'] ?? 'Failed to create income transaction');
    }
  }
}
