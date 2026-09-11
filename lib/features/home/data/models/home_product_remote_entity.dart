import 'package:damilva/features/home/domain/entities/home_product.dart';
import 'package:damilva/features/home/domain/enums/product_badge.dart';

class HomeProductRemoteEntity {
  const HomeProductRemoteEntity({
    required this.id,
    required this.name,
    required this.price,
    this.previousPrice,
    this.label,
    required this.image,
  });

  factory HomeProductRemoteEntity.fromJson(Map<String, dynamic> json) {
    return HomeProductRemoteEntity(
      id: json['id'] as String,
      name: json['nombre'] as String,
      price: (json['precio'] as num).toDouble(),
      previousPrice: (json['precioAnterior'] as num?)?.toDouble(),
      label: json['etiqueta'] as String?,
      image: json['imagen'] as String,
    );
  }

  final String id;
  final String name;
  final double price;
  final double? previousPrice;
  final String? label;
  final String image;

  ProductBadge? get _badge => switch (label) {
    'nuevo' => ProductBadge.newIn,
    'oferta' => ProductBadge.offer,
    _ => null,
  };

  HomeProduct toDomain() {
    return HomeProduct(
      id: id,
      name: name,
      price: price,
      previousPrice: previousPrice,
      badge: _badge,
      imageUrl: image,
    );
  }
}
