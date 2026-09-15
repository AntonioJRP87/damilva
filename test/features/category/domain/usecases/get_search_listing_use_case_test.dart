import 'package:damilva/core/errors/app_error.dart';
import 'package:damilva/core/result/result.dart';
import 'package:damilva/features/category/domain/entities/category_filters.dart';
import 'package:damilva/features/category/domain/entities/category_listing.dart';
import 'package:damilva/features/category/domain/enums/category_sort_option.dart';
import 'package:damilva/features/category/domain/repositories/category_repository.dart';
import 'package:damilva/features/category/domain/usecases/get_search_listing_use_case.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeCategoryRepository implements CategoryRepositoryContract {
  _FakeCategoryRepository(this.result);

  final Result<CategoryListing, AppError> result;
  String? lastQuery;

  @override
  Future<Result<CategoryListing, AppError>> getCategoryListing({
    required String categoryId,
    String? size,
    String? color,
    double? maxPrice,
    required bool onlyInStock,
    required CategorySortOption sort,
    required int page,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<Result<CategoryListing, AppError>> getSearchListing({
    required String query,
    String? size,
    String? color,
    double? maxPrice,
    required bool onlyInStock,
    required CategorySortOption sort,
    required int page,
  }) async {
    lastQuery = query;
    return result;
  }
}

const _listing = CategoryListing(
  total: 0,
  products: [],
  filters: CategoryFilters(sizes: [], colors: [], priceMin: 0, priceMax: 0),
);

void main() {
  test('delegates to the repository with the given query', () async {
    final repository = _FakeCategoryRepository(const Result.success(_listing));
    final useCase = GetSearchListingUseCase(repository);

    final result = await useCase(
      query: 'vestido rojo',
      onlyInStock: false,
      sort: CategorySortOption.newestFirst,
      page: 1,
    );

    expect(result.isSuccess, isTrue);
    expect(repository.lastQuery, 'vestido rojo');
  });
}
