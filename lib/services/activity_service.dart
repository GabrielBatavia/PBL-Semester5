// lib/services/activity_service.dart
import 'dart:convert';
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
      category: (json['category'] ?? '').toString(),
      count: (json['count'] as num).toInt(),
      percentage: (json['percentage'] as num).toDouble(),
    );
  }
}

class ActivityService {
  static Future<List<ActivityCategoryStats>> getCategoryStats() async {
    final response = await ApiClient.get('/activities/stats/by-category');

    if (response.statusCode != 200) {
      throw Exception('HTTP ${response.statusCode}: ${response.body}');
    }

    final decoded = jsonDecode(response.body);
    if (decoded is! List) {
      throw Exception('Invalid response format: expected List, got ${decoded.runtimeType}');
    }

    return decoded
        .map<ActivityCategoryStats>(
          (json) => ActivityCategoryStats.fromJson(json as Map<String, dynamic>),
        )
        .toList();
  }
}
