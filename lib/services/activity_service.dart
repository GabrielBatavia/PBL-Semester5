import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/activity.dart';

class ActivityService {
  final String baseUrl = "https://api.jawara.com";

  Future<List<Activity>> fetchActivities() async {
    final url = Uri.parse("$baseUrl/activities");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => Activity.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load activities");
    }
  }
}
