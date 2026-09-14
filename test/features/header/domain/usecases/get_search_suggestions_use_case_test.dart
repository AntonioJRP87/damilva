import 'package:damilva/core/errors/app_error.dart';
import 'package:damilva/core/result/result.dart';
import 'package:damilva/features/header/domain/entities/category.dart';
import 'package:damilva/features/header/domain/entities/search_suggestion.dart';
import 'package:damilva/features/header/domain/repositories/header_repository.dart';
import 'package:damilva/features/header/domain/usecases/get_search_suggestions_use_case.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeHeaderRepository implements HeaderRepositoryContract {
  _FakeHeaderRepository(this.suggestionsResult);

  final Result<List<SearchSuggestion>, AppError> suggestionsResult;

  @override
  Future<Result<List<Category>, AppError>> getCategories() {
    throw UnimplementedError();
  }

  @override
  Future<Result<List<SearchSuggestion>, AppError>> getSearchSuggestions(
    String query,
  ) async => suggestionsResult;
}

void main() {
  test('delegates to the repository with the given query', () async {
    const suggestions = [
      SearchSuggestion(id: '1', name: 'Vestido rojo', imageUrl: 'img.jpg'),
    ];
    final useCase = GetSearchSuggestionsUseCase(
      _FakeHeaderRepository(const Result.success(suggestions)),
    );

    final result = await useCase('vestido');

    expect(result.isSuccess, isTrue);
    expect(result.data, suggestions);
  });
}
