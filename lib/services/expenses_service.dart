// lib/services/expenses_service.dart
import 'dart:convert';
import 'api_client.dart';

class ExpenseService {
  ExpenseService._();

  static final ExpenseService instance = ExpenseService._();

  // ===== STATIC WRAPPERS (biar screen aman panggil ExpenseService.getExpenses()) =====
  static Future<List<Map<String, dynamic>>> getExpenses() {
    return instance._getExpenses();
  }

  static Future<Map<String, dynamic>> createExpense({
    required String name,
    required String category,
    required double amount,
    required String date, // YYYY-MM-DD
    String? proofImageUrl,
  }) {
    return instance._createExpense(
      name: name,
      category: category,
      amount: amount,
      date: date,
      proofImageUrl: proofImageUrl,
    );
  }

  // ===== IMPLEMENTATION =====
  Future<List<Map<String, dynamic>>> _getExpenses() async {
    final response = await ApiClient.get('/expenses', auth: true);

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);

      if (decoded is List) {
        return decoded.cast<Map<String, dynamic>>();
      }

      // kalau backend ternyata balikin {data:[...]}
      if (decoded is Map && decoded['data'] is List) {
        return (decoded['data'] as List).cast<Map<String, dynamic>>();
      }
    }

    throw Exception('Failed to load expenses (${response.statusCode})');
  }

  Future<Map<String, dynamic>> _createExpense({
    required String name,
    required String category,
    required double amount,
    required String date,
    String? proofImageUrl,
  }) async {
    final response = await ApiClient.post(
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
      return json.decode(response.body) as Map<String, dynamic>;
    }

    String errorMsg = 'Failed to create expense';
    try {
      final errorBody = json.decode(response.body);
      if (errorBody is Map && errorBody['detail'] != null) {
        errorMsg = errorBody['detail'].toString();
      } else {
        errorMsg = 'Status ${response.statusCode}: ${response.body}';
      }
    } catch (_) {
      errorMsg = 'Status ${response.statusCode}: ${response.body}';
    }

    throw Exception(errorMsg);
  }
}
