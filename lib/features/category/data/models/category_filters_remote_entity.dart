import 'package:damilva/features/category/domain/entities/category_filters.dart';

class CategoryFiltersRemoteEntity {
  const CategoryFiltersRemoteEntity({
    required this.sizes,
    required this.colors,
    required this.priceMin,
    required this.priceMax,
  });

  factory CategoryFiltersRemoteEntity.fromJson(Map<String, dynamic> json) {
    return CategoryFiltersRemoteEntity(
      sizes: (json['tallas'] as List).map((e) => e as String).toList(),
      colors: (json['colores'] as List).map((e) => e as String).toList(),
      priceMin: (json['precioMin'] as num).toDouble(),
      priceMax: (json['precioMax'] as num).toDouble(),
    );
  }

  final List<String> sizes;
  final List<String> colors;
  final double priceMin;
  final double priceMax;

  CategoryFilters toDomain() {
    return CategoryFilters(
      sizes: sizes,
      colors: colors,
      priceMin: priceMin,
      priceMax: priceMax,
    );
  }
}
