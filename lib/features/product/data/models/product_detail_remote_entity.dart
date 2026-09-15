import 'package:damilva/features/product/data/models/product_variant_remote_entity.dart';
import 'package:damilva/features/product/data/models/related_product_remote_entity.dart';
import 'package:damilva/features/product/domain/entities/product_detail.dart';

class ProductDetailRemoteEntity {
  const ProductDetailRemoteEntity({
    required this.name,
    required this.description,
    required this.composition,
    required this.returnsInfo,
    required this.price,
    this.previousPrice,
    required this.images,
    required this.variants,
    required this.related,
  });

  factory ProductDetailRemoteEntity.fromJson(Map<String, dynamic> json) {
    return ProductDetailRemoteEntity(
      name: json['nombre'] as String,
      description: json['descripcion'] as String,
      composition: json['composicion'] as String,
      returnsInfo: json['devoluciones'] as String,
      price: (json['precio'] as num).toDouble(),
      previousPrice: (json['precioAnterior'] as num?)?.toDouble(),
      images: (json['imagenes'] as List).map((e) => e as String).toList(),
      variants: (json['variantes'] as List)
          .map(
            (e) =>
                ProductVariantRemoteEntity.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
      related: (json['relacionados'] as List)
          .map(
            (e) =>
                RelatedProductRemoteEntity.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
    );
  }

  final String name;
  final String description;
  final String composition;
  final String returnsInfo;
  final double price;
  final double? previousPrice;
  final List<String> images;
  final List<ProductVariantRemoteEntity> variants;
  final List<RelatedProductRemoteEntity> related;

  ProductDetail toDomain() {
    return ProductDetail(
      name: name,
      description: description,
      composition: composition,
      returnsInfo: returnsInfo,
      price: price,
      previousPrice: previousPrice,
      images: images,
      variants: variants.map((e) => e.toDomain()).toList(),
      related: related.map((e) => e.toDomain()).toList(),
    );
  }
}
