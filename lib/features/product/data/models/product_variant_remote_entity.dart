import 'package:damilva/features/product/domain/entities/product_variant.dart';

class ProductVariantRemoteEntity {
  const ProductVariantRemoteEntity({
    required this.color,
    required this.colorHex,
    required this.size,
    required this.sku,
    required this.stock,
    required this.price,
  });

  factory ProductVariantRemoteEntity.fromJson(Map<String, dynamic> json) {
    return ProductVariantRemoteEntity(
      color: json['color'] as String,
      colorHex: json['colorHex'] as String,
      size: json['talla'] as String,
      sku: json['sku'] as String,
      stock: json['stock'] as int,
      price: (json['precio'] as num).toDouble(),
    );
  }

  final String color;
  final String colorHex;
  final String size;
  final String sku;
  final int stock;
  final double price;

  ProductVariant toDomain() {
    return ProductVariant(
      color: color,
      colorHex: colorHex,
      size: size,
      sku: sku,
      stock: stock,
      price: price,
    );
  }
}
