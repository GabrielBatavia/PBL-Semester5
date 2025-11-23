// lib/models/log_entry.dart

class LogEntry {
  final int id;
  final String description;
  final String actorName;
  final DateTime createdAt;

  LogEntry({
    required this.id,
    required this.description,
    required this.actorName,
    required this.createdAt,
  });

  factory LogEntry.fromJson(Map<String, dynamic> json) {
    final actor = json['actor'] as Map<String, dynamic>?;

    return LogEntry(
      id: json['id'] as int,
      description: json['description'] as String? ?? '',
      actorName: actor != null ? (actor['name'] as String? ?? '-') : '-',
      createdAt: DateTime.tryParse(json['created_at']?.toString() ?? '') ??
          DateTime.now(),
    );
  }

  String get formattedDate {
    // Contoh sederhana: 2025-11-22 13:45
    final local = createdAt.toLocal();
    final y = local.year.toString().padLeft(4, '0');
    final m = local.month.toString().padLeft(2, '0');
    final d = local.day.toString().padLeft(2, '0');
    final hh = local.hour.toString().padLeft(2, '0');
    final mm = local.minute.toString().padLeft(2, '0');
    return '$d-$m-$y $hh:$mm';
  }
}
