import 'package:damilva/core/enums/product_badge.dart';

class CategoryProduct {
  const CategoryProduct({
    required this.id,
    required this.name,
    required this.price,
    this.previousPrice,
    this.badge,
    required this.soldOut,
    required this.imageUrl,
  });

  final String id;
  final String name;
  final double price;
  final double? previousPrice;
  final ProductBadge? badge;
  final bool soldOut;
  final String imageUrl;
}
