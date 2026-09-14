import 'package:damilva/core/errors/app_error.dart';
import 'package:damilva/core/errors/errors_mapper.dart';
import 'package:damilva/core/errors/generic/generic_error.dart';
import 'package:damilva/core/result/result.dart';
import 'package:damilva/features/header/data/datasources/header_data_source.dart';
import 'package:damilva/features/header/domain/entities/category.dart';
import 'package:damilva/features/header/domain/entities/search_suggestion.dart';
import 'package:damilva/features/header/domain/repositories/header_repository.dart';

class HeaderRepositoryImpl implements HeaderRepositoryContract {
  HeaderRepositoryImpl(this._headerDataSource);

  final HeaderDataSourceContract _headerDataSource;

  @override
  Future<Result<List<Category>, AppError>> getCategories() {
    return _handleError(() async {
      final remote = await _headerDataSource.getCategories();
      final visible = remote.where((e) => e.visible).toList()
        ..sort((a, b) => a.order.compareTo(b.order));
      return visible.map((e) => e.toDomain()).toList();
    });
  }

  @override
  Future<Result<List<SearchSuggestion>, AppError>> getSearchSuggestions(
    String query,
  ) {
    return _handleError(() async {
      final remote = await _headerDataSource.getSearchSuggestions(query);
      return remote.map((e) => e.toDomain()).toList();
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
