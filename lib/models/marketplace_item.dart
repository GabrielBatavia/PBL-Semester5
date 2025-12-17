// lib/models/marketplace_item.dart
class MarketplaceItem {
  final int id;
  final String title;
  final String? description;
  final double price;
  final String? unit;
  final String? imageUrl;
  final String? veggieClass;
  final int ownerId;
  final DateTime createdAt;

  MarketplaceItem({
    required this.id,
    required this.title,
    this.description,
    required this.price,
    this.unit,
    this.imageUrl,
    this.veggieClass,
    required this.ownerId,
    required this.createdAt,
  });

  static double _parsePrice(dynamic v) {
    if (v is num) return v.toDouble();
    if (v is String) return double.tryParse(v) ?? 0.0;
    return 0.0;
  }

  static int _parseId(dynamic v) {
    if (v is int) return v;
    if (v is String) return int.tryParse(v) ?? 0;
    return 0;
  }

  static DateTime _parseCreatedAt(dynamic v) {
    if (v == null) return DateTime.now();
    final s = v.toString();
    try {
      return DateTime.parse(s);
    } catch (_) {
      return DateTime.now();
    }
  }

  factory MarketplaceItem.fromJson(Map<String, dynamic> json) {
    return MarketplaceItem(
      id: _parseId(json['id']),
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString(),
      price: _parsePrice(json['price']),
      unit: json['unit']?.toString(),
      imageUrl: json['image_url']?.toString(),
      veggieClass: json['veggie_class']?.toString(),
      ownerId: _parseId(json['owner_id']),
      createdAt: _parseCreatedAt(json['created_at']),
    );
  }
}
