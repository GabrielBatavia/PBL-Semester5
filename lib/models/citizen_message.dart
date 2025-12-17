// lib/models/citizen_message.dart
class CitizenMessage {
  final int id;
  final String title;
  final String content;
  final String status;
  final DateTime createdAt;

  CitizenMessage({
    required this.id,
    required this.title,
    required this.content,
    required this.status,
    required this.createdAt,
  });

  factory CitizenMessage.fromJson(Map<String, dynamic> json) {
    return CitizenMessage(
      id: json['id'] as int,
      title: json['title'] as String,
      content: json['content'] as String,
      status: json['status'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toCreateJson() {
    return {
      'title': title,
      'content': content,
    };
  }
}
