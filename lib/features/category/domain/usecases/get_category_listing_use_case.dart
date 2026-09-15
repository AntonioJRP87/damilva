import 'package:damilva/core/errors/app_error.dart';
import 'package:damilva/core/result/result.dart';
import 'package:damilva/features/category/domain/entities/category_listing.dart';
import 'package:damilva/features/category/domain/enums/category_sort_option.dart';
import 'package:damilva/features/category/domain/repositories/category_repository.dart';

abstract class GetCategoryListingUseCaseContract {
  Future<Result<CategoryListing, AppError>> call({
    required String categoryId,
    String? size,
    String? color,
    double? maxPrice,
    required bool onlyInStock,
    required CategorySortOption sort,
    required int page,
  });
}

class GetCategoryListingUseCase implements GetCategoryListingUseCaseContract {
  GetCategoryListingUseCase(this._categoryRepository);

  final CategoryRepositoryContract _categoryRepository;

  @override
  Future<Result<CategoryListing, AppError>> call({
    required String categoryId,
    String? size,
    String? color,
    double? maxPrice,
    required bool onlyInStock,
    required CategorySortOption sort,
    required int page,
  }) {
    return _categoryRepository.getCategoryListing(
      categoryId: categoryId,
      size: size,
      color: color,
      maxPrice: maxPrice,
      onlyInStock: onlyInStock,
      sort: sort,
      page: page,
    );
  }
}
