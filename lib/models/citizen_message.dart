// lib/models/citizen_message.dart
class CitizenMessage {
  final int id;
  final String title;
  final String content;

  /// Bisa kosong kalau backend tidak mengirim field ini (mis. response create).
  final String status;

  /// Default ke epoch kalau backend tidak mengirim created_at.
  final DateTime createdAt;

  CitizenMessage({
    required this.id,
    required this.title,
    required this.content,
    required this.status,
    required this.createdAt,
  });

  static int _asInt(dynamic v) {
    if (v is int) return v;
    if (v is num) return v.toInt();
    if (v is String) return int.tryParse(v) ?? 0;
    return 0;
  }

  static DateTime _asDateTime(dynamic v) {
    if (v == null) return DateTime.fromMillisecondsSinceEpoch(0);
    if (v is DateTime) return v;

    final s = v.toString().trim();
    if (s.isEmpty) return DateTime.fromMillisecondsSinceEpoch(0);

    try {
      return DateTime.parse(s);
    } catch (_) {
      try {
        return DateTime.parse(s.replaceFirst(' ', 'T'));
      } catch (_) {
        return DateTime.fromMillisecondsSinceEpoch(0);
      }
    }
  }

  factory CitizenMessage.fromJson(Map<String, dynamic> json) {
    return CitizenMessage(
      id: _asInt(json['id']),
      title: json['title']?.toString() ?? '',
      content: json['content']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      createdAt: _asDateTime(json['created_at'] ?? json['createdAt']),
    );
  }

  Map<String, dynamic> toCreateJson() {
    return {
      'title': title,
      'content': content,
    };
  }
}
