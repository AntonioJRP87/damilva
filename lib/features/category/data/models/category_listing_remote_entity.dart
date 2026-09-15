import 'package:damilva/features/category/data/models/category_filters_remote_entity.dart';
import 'package:damilva/features/category/data/models/category_product_remote_entity.dart';
import 'package:damilva/features/category/domain/entities/category_listing.dart';

class CategoryListingRemoteEntity {
  const CategoryListingRemoteEntity({
    required this.total,
    required this.products,
    required this.filters,
  });

  factory CategoryListingRemoteEntity.fromJson(Map<String, dynamic> json) {
    return CategoryListingRemoteEntity(
      total: json['total'] as int,
      products: (json['productos'] as List)
          .map(
            (e) =>
                CategoryProductRemoteEntity.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
      filters: CategoryFiltersRemoteEntity.fromJson(
        json['filtrosDisponibles'] as Map<String, dynamic>,
      ),
    );
  }

  final int total;
  final List<CategoryProductRemoteEntity> products;
  final CategoryFiltersRemoteEntity filters;

  CategoryListing toDomain() {
    return CategoryListing(
      total: total,
      products: products.map((e) => e.toDomain()).toList(),
      filters: filters.toDomain(),
    );
  }
}
