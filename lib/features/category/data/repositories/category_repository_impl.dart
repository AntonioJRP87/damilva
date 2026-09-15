import 'package:damilva/core/errors/app_error.dart';
import 'package:damilva/core/errors/errors_mapper.dart';
import 'package:damilva/core/errors/generic/generic_error.dart';
import 'package:damilva/core/result/result.dart';
import 'package:damilva/features/category/data/datasources/category_data_source.dart';
import 'package:damilva/features/category/domain/entities/category_listing.dart';
import 'package:damilva/features/category/domain/enums/category_sort_option.dart';
import 'package:damilva/features/category/domain/repositories/category_repository.dart';

class CategoryRepositoryImpl implements CategoryRepositoryContract {
  CategoryRepositoryImpl(this._categoryDataSource);

  final CategoryDataSourceContract _categoryDataSource;

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
    return _handleError(() async {
      final remote = await _categoryDataSource.getCategoryListing(
        categoryId: categoryId,
        size: size,
        color: color,
        maxPrice: maxPrice,
        onlyInStock: onlyInStock,
        sort: sort,
        page: page,
      );
      return remote.toDomain();
    });
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
  }) {
    return _handleError(() async {
      final remote = await _categoryDataSource.getSearchListing(
        query: query,
        size: size,
        color: color,
        maxPrice: maxPrice,
        onlyInStock: onlyInStock,
        sort: sort,
        page: page,
      );
      return remote.toDomain();
    });
  }

  Future<Result<T, AppError>> _handleError<T>(
    Future<T> Function() action,
  ) async {
    try {
      final data = await action();
      return Result.success(data);
    } on GenericError catch (e) {
      return Result.failure(ErrorsMapper.mapToError(e));
    }
  }
}
