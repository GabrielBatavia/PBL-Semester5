// lib/models/marketplace_item.dart
class MarketplaceItem {
  final int id;
  final String title;
  final String? description;
  final double price;
  final String? unit;
  final String? imageUrl;
  final int ownerId;
  final DateTime createdAt;

  MarketplaceItem({
    required this.id,
    required this.title,
    this.description,
    required this.price,
    this.unit,
    this.imageUrl,
    required this.ownerId,
    required this.createdAt,
  });

  factory MarketplaceItem.fromJson(Map<String, dynamic> json) {
    return MarketplaceItem(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      price: (json['price'] as num).toDouble(),
      unit: json['unit'],
      imageUrl: json['image_url'],
      ownerId: json['owner_id'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
