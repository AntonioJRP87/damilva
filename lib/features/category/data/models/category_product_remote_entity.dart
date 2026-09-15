import 'package:damilva/core/enums/product_badge.dart';
import 'package:damilva/features/category/domain/entities/category_product.dart';

class CategoryProductRemoteEntity {
  const CategoryProductRemoteEntity({
    required this.id,
    required this.name,
    required this.price,
    this.previousPrice,
    this.label,
    required this.soldOut,
    required this.image,
  });

  factory CategoryProductRemoteEntity.fromJson(Map<String, dynamic> json) {
    return CategoryProductRemoteEntity(
      id: json['id'] as String,
      name: json['nombre'] as String,
      price: (json['precio'] as num).toDouble(),
      previousPrice: (json['precioAnterior'] as num?)?.toDouble(),
      label: json['etiqueta'] as String?,
      soldOut: json['agotado'] as bool,
      image: json['imagen'] as String,
    );
  }

  final String id;
  final String name;
  final double price;
  final double? previousPrice;
  final String? label;
  final bool soldOut;
  final String image;

  ProductBadge? get _badge => switch (label) {
    'nuevo' => ProductBadge.newIn,
    'oferta' => ProductBadge.offer,
    _ => null,
  };

  CategoryProduct toDomain() {
    return CategoryProduct(
      id: id,
      name: name,
      price: price,
      previousPrice: previousPrice,
      badge: _badge,
      soldOut: soldOut,
      imageUrl: image,
    );
  }
}
