// Create file: lib/services/activity_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_client.dart';

class ActivityCategoryStats {
  final String category;
  final int count;
  final double percentage;

  ActivityCategoryStats({
    required this.category,
    required this.count,
    required this.percentage,
  });

  factory ActivityCategoryStats.fromJson(Map<String, dynamic> json) {
    return ActivityCategoryStats(
      category: json['category'] as String,
      count: json['count'] as int,
      percentage: (json['percentage'] as num).toDouble(),
    );
  }
}

class ActivityService {
  static Future<List<ActivityCategoryStats>> getCategoryStats() async {
    try {
      final response = await ApiClient.get('/activities/stats/by-category');
      
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => ActivityCategoryStats.fromJson(json)).toList();
      }
      
      return [];
    } catch (e) {
      print('Error fetching activity stats: $e');
      return [];
    }
  }
}