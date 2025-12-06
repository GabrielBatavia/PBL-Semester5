// lib/services/fee_category_service.dart

import 'dart:convert';
import 'api_client.dart';

class FeeCategoryService {
  static Future<List<Map<String, dynamic>>> getCategories() async {
    final response = await ApiClient.get('/fee-categories', auth: true);
    
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.cast<Map<String, dynamic>>();
    } else {
      final error = json.decode(response.body);
      throw Exception(error['detail'] ?? 'Failed to load categories');
    }
  }

  static Future<Map<String, dynamic>> createCategory({
    required String name,
    required String type,
    required double defaultAmount,
  }) async {
    final response = await ApiClient.post(
      '/fee-categories/',
      {
        'name': name,
        'type': type,
        'default_amount': defaultAmount,
      },
      auth: true,
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      final error = json.decode(response.body);
      throw Exception(error['detail'] ?? 'Failed to create category');
    }
  }
}