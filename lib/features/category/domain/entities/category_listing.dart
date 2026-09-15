import 'package:damilva/features/category/domain/entities/category_filters.dart';
import 'package:damilva/features/category/domain/entities/category_product.dart';

class CategoryListing {
  const CategoryListing({
    required this.total,
    required this.products,
    required this.filters,
  });

  final int total;
  final List<CategoryProduct> products;
  final CategoryFilters filters;
}
