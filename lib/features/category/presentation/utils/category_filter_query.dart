import 'package:damilva/features/category/domain/enums/category_sort_option.dart';

const _unset = Object();

class CategoryFilterQuery {
  const CategoryFilterQuery({
    this.size,
    this.color,
    this.maxPrice,
    this.onlyInStock = false,
    this.sort = CategorySortOption.newestFirst,
  });

  factory CategoryFilterQuery.fromQueryParameters(Map<String, String> query) {
    return CategoryFilterQuery(
      size: query['talla'],
      color: query['color'],
      maxPrice: double.tryParse(query['precioMax'] ?? ''),
      onlyInStock: query['stock'] == 'true',
      sort: CategorySortOptionWire.fromWireValue(query['orden']),
    );
  }

  final String? size;
  final String? color;
  final double? maxPrice;
  final bool onlyInStock;
  final CategorySortOption sort;

  Map<String, String> toQueryParameters() => {
    'talla': ?size,
    'color': ?color,
    'precioMax': ?maxPrice?.toStringAsFixed(2),
    if (onlyInStock) 'stock': 'true',
    if (sort != CategorySortOption.newestFirst) 'orden': sort.wireValue,
  };

  CategoryFilterQuery copyWith({
    Object? size = _unset,
    Object? color = _unset,
    Object? maxPrice = _unset,
    bool? onlyInStock,
    CategorySortOption? sort,
  }) {
    return CategoryFilterQuery(
      size: identical(size, _unset) ? this.size : size as String?,
      color: identical(color, _unset) ? this.color : color as String?,
      maxPrice: identical(maxPrice, _unset)
          ? this.maxPrice
          : maxPrice as double?,
      onlyInStock: onlyInStock ?? this.onlyInStock,
      sort: sort ?? this.sort,
    );
  }
}
