import 'package:damilva/features/category/data/models/category_listing_remote_entity.dart';
import 'package:damilva/features/category/domain/enums/category_sort_option.dart';

abstract class CategoryDataSourceContract {
  Future<CategoryListingRemoteEntity> getCategoryListing({
    required String categoryId,
    String? size,
    String? color,
    double? maxPrice,
    required bool onlyInStock,
    required CategorySortOption sort,
    required int page,
  });

  Future<CategoryListingRemoteEntity> getSearchListing({
    required String query,
    String? size,
    String? color,
    double? maxPrice,
    required bool onlyInStock,
    required CategorySortOption sort,
    required int page,
  });
}
