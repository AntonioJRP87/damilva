import 'package:damilva/core/errors/app_error.dart';
import 'package:damilva/core/errors/custom/custom_errors.dart';
import 'package:damilva/features/header/data/datasources/header_data_source.dart';
import 'package:damilva/features/header/data/models/category_remote_entity.dart';
import 'package:damilva/features/header/data/models/search_suggestion_remote_entity.dart';
import 'package:damilva/features/header/data/repositories/header_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeHeaderDataSource implements HeaderDataSourceContract {
  _FakeHeaderDataSource({
    this.categories,
    this.suggestions,
    this.categoriesError,
    this.suggestionsError,
  });

  final List<CategoryRemoteEntity>? categories;
  final List<SearchSuggestionRemoteEntity>? suggestions;
  final CustomErrors? categoriesError;
  final CustomErrors? suggestionsError;

  @override
  Future<List<CategoryRemoteEntity>> getCategories() async {
    if (categoriesError != null) throw categoriesError!;
    return categories!;
  }

  @override
  Future<List<SearchSuggestionRemoteEntity>> getSearchSuggestions(
    String query,
  ) async {
    if (suggestionsError != null) throw suggestionsError!;
    return suggestions!;
  }
}

void main() {
  group('getCategories', () {
    test('filters out non-visible categories and sorts by order', () async {
      final repository = HeaderRepositoryImpl(
        _FakeHeaderDataSource(
          categories: const [
            CategoryRemoteEntity(
              id: '2',
              name: 'Ofertas',
              order: 2,
              visible: true,
            ),
            CategoryRemoteEntity(
              id: '3',
              name: 'Oculta',
              order: 0,
              visible: false,
            ),
            CategoryRemoteEntity(
              id: '1',
              name: 'Novedades',
              order: 1,
              visible: true,
            ),
          ],
        ),
      );

      final result = await repository.getCategories();

      expect(result.isSuccess, isTrue);
      expect(result.data!.map((e) => e.id).toList(), ['1', '2']);
    });

    test('maps a thrown CustomErrors to the matching AppError', () async {
      final repository = HeaderRepositoryImpl(
        _FakeHeaderDataSource(
          categoriesError: const CustomErrors.errorServer(),
        ),
      );

      final result = await repository.getCategories();

      expect(result.isFailure, isTrue);
      expect(result.error, const AppError.errorServer());
    });
  });

  group('getSearchSuggestions', () {
    test('maps a successful response to domain suggestions', () async {
      final repository = HeaderRepositoryImpl(
        _FakeHeaderDataSource(
          suggestions: const [
            SearchSuggestionRemoteEntity(
              id: '1',
              name: 'Vestido rojo',
              imageUrl: 'img.jpg',
            ),
          ],
        ),
      );

      final result = await repository.getSearchSuggestions('vestido');

      expect(result.isSuccess, isTrue);
      expect(result.data!.single.name, 'Vestido rojo');
    });

    test('maps a thrown CustomErrors to the matching AppError', () async {
      final repository = HeaderRepositoryImpl(
        _FakeHeaderDataSource(
          suggestionsError: const CustomErrors.noInternetConnection(),
        ),
      );

      final result = await repository.getSearchSuggestions('vestido');

      expect(result.isFailure, isTrue);
      expect(result.error, const AppError.noInternetConnection());
    });
  });
}
