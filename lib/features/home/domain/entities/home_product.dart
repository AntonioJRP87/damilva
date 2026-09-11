import 'package:damilva/features/home/domain/enums/product_badge.dart';

class HomeProduct {
  const HomeProduct({
    required this.id,
    required this.name,
    required this.price,
    this.previousPrice,
    this.badge,
    required this.imageUrl,
  });

  final String id;
  final String name;
  final double price;
  final double? previousPrice;
  final ProductBadge? badge;
  final String imageUrl;
}
