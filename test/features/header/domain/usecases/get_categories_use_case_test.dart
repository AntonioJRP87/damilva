import 'package:damilva/core/errors/app_error.dart';
import 'package:damilva/core/result/result.dart';
import 'package:damilva/features/header/domain/entities/category.dart';
import 'package:damilva/features/header/domain/entities/search_suggestion.dart';
import 'package:damilva/features/header/domain/repositories/header_repository.dart';
import 'package:damilva/features/header/domain/usecases/get_categories_use_case.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeHeaderRepository implements HeaderRepositoryContract {
  _FakeHeaderRepository(this.categoriesResult);

  final Result<List<Category>, AppError> categoriesResult;

  @override
  Future<Result<List<Category>, AppError>> getCategories() async =>
      categoriesResult;

  @override
  Future<Result<List<SearchSuggestion>, AppError>> getSearchSuggestions(
    String query,
  ) {
    throw UnimplementedError();
  }
}

void main() {
  test('delegates to the repository', () async {
    const categories = [Category(id: '1', name: 'Novedades')];
    final useCase = GetCategoriesUseCase(
      _FakeHeaderRepository(const Result.success(categories)),
    );

    final result = await useCase();

    expect(result.isSuccess, isTrue);
    expect(result.data, categories);
  });
}
