import 'package:damilva/core/errors/app_error.dart';
import 'package:damilva/core/result/result.dart';
import 'package:damilva/features/category/domain/entities/category_listing.dart';
import 'package:damilva/features/category/domain/enums/category_sort_option.dart';

abstract class CategoryRepositoryContract {
  Future<Result<CategoryListing, AppError>> getCategoryListing({
    required String categoryId,
    String? size,
    String? color,
    double? maxPrice,
    required bool onlyInStock,
    required CategorySortOption sort,
    required int page,
  });

  Future<Result<CategoryListing, AppError>> getSearchListing({
    required String query,
    String? size,
    String? color,
    double? maxPrice,
    required bool onlyInStock,
    required CategorySortOption sort,
    required int page,
  });
}
