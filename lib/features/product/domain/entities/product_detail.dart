import 'package:damilva/features/product/domain/entities/product_variant.dart';
import 'package:damilva/features/product/domain/entities/related_product.dart';

class ProductDetail {
  const ProductDetail({
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

  final String name;
  final String description;
  final String composition;
  final String returnsInfo;
  final double price;
  final double? previousPrice;
  final List<String> images;
  final List<ProductVariant> variants;
  final List<RelatedProduct> related;

  bool get soldOut => variants.every((variant) => variant.soldOut);

  List<String> get colors {
    final seen = <String>{};
    return [
      for (final variant in variants)
        if (seen.add(variant.color)) variant.color,
    ];
  }

  List<String> get allSizes {
    final seen = <String>{};
    return [
      for (final variant in variants)
        if (seen.add(variant.size)) variant.size,
    ];
  }

  String colorHexFor(String color) =>
      variants.firstWhere((variant) => variant.color == color).colorHex;

  List<ProductVariant> variantsForColor(String color) =>
      variants.where((variant) => variant.color == color).toList();

  ProductVariant? variantFor({required String color, required String size}) {
    for (final variant in variants) {
      if (variant.color == color && variant.size == size) return variant;
    }
    return null;
  }
}
