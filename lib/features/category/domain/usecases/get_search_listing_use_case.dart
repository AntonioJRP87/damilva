import 'package:damilva/core/errors/app_error.dart';
import 'package:damilva/core/result/result.dart';
import 'package:damilva/features/category/domain/entities/category_listing.dart';
import 'package:damilva/features/category/domain/enums/category_sort_option.dart';
import 'package:damilva/features/category/domain/repositories/category_repository.dart';

abstract class GetSearchListingUseCaseContract {
  Future<Result<CategoryListing, AppError>> call({
    required String query,
    String? size,
    String? color,
    double? maxPrice,
    required bool onlyInStock,
    required CategorySortOption sort,
    required int page,
  });
}

class GetSearchListingUseCase implements GetSearchListingUseCaseContract {
  GetSearchListingUseCase(this._categoryRepository);

  final CategoryRepositoryContract _categoryRepository;

  @override
  Future<Result<CategoryListing, AppError>> call({
    required String query,
    String? size,
    String? color,
    double? maxPrice,
    required bool onlyInStock,
    required CategorySortOption sort,
    required int page,
  }) {
    return _categoryRepository.getSearchListing(
      query: query,
      size: size,
      color: color,
      maxPrice: maxPrice,
      onlyInStock: onlyInStock,
      sort: sort,
      page: page,
    );
  }
}
