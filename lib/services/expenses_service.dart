import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_client.dart';

class ExpenseService {
  final IApiClient _apiClient;

  // Constructor dengan dependency injection
  ExpenseService({IApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient();

  Future<List<Map<String, dynamic>>> getExpenses() async {
    final response = await _apiClient.get('/expenses', auth: true);
    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.cast<Map<String, dynamic>>();
    }
    throw Exception('Failed to load expenses');
  }

  Future<Map<String, dynamic>> createExpense({
    required String name,
    required String category,
    required double amount,
    required String date, // format: YYYY-MM-DD
    String? proofImageUrl,
  }) async {
    final response = await _apiClient.post(
      '/expenses/',
      {
        'name': name,
        'category': category,
        'amount': amount,
        'date': date,
        'proof_image_url': proofImageUrl,
      },
      auth: true,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return json.decode(response.body);
    }

    // Better error message
    String errorMsg = 'Failed to create expense';
    try {
      final errorBody = json.decode(response.body);
      if (errorBody['detail'] != null) {
        errorMsg = errorBody['detail'].toString();
      }
    } catch (e) {
      errorMsg = 'Status ${response.statusCode}: ${response.body}';
    }

    throw Exception(errorMsg);
  }
}