import 'package:damilva/core/cart/cart_badge_controller.dart';
import 'package:damilva/core/errors/app_error.dart';
import 'package:damilva/core/result/result.dart';
import 'package:damilva/features/header/domain/entities/category.dart';
import 'package:damilva/features/header/domain/entities/search_suggestion.dart';
import 'package:damilva/features/header/domain/usecases/get_categories_use_case.dart';
import 'package:damilva/features/header/domain/usecases/get_search_suggestions_use_case.dart';
import 'package:damilva/features/header/presentation/bloc/header_bloc.dart';
import 'package:damilva/features/header/presentation/bloc/header_event.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeGetCategoriesUseCase implements GetCategoriesUseCaseContract {
  _FakeGetCategoriesUseCase(this.result);

  final Result<List<Category>, AppError> result;

  @override
  Future<Result<List<Category>, AppError>> call() async => result;
}

class _FakeGetSearchSuggestionsUseCase
    implements GetSearchSuggestionsUseCaseContract {
  _FakeGetSearchSuggestionsUseCase(this.result);

  final Result<List<SearchSuggestion>, AppError> result;
  String? lastQuery;

  @override
  Future<Result<List<SearchSuggestion>, AppError>> call(String query) async {
    lastQuery = query;
    return result;
  }
}

const _categories = [Category(id: '1', name: 'Novedades')];
const _suggestions = [
  SearchSuggestion(id: '1', name: 'Vestido rojo', imageUrl: 'img.jpg'),
];

HeaderBloc _buildBloc({
  Result<List<Category>, AppError>? categoriesResult,
  Result<List<SearchSuggestion>, AppError>? suggestionsResult,
}) {
  return HeaderBloc(
    _FakeGetCategoriesUseCase(
      categoriesResult ?? const Result.success(_categories),
    ),
    _FakeGetSearchSuggestionsUseCase(
      suggestionsResult ?? const Result.success(_suggestions),
    ),
    CartBadgeController(),
  );
}

void main() {
  test('started loads categories on success', () async {
    final bloc = _buildBloc();
    addTearDown(bloc.close);

    bloc.add(const HeaderEvent.started());
    await Future<void>.delayed(Duration.zero);

    expect(bloc.state.categories, _categories);
  });

  test('started keeps categories empty when the use case fails', () async {
    final bloc = _buildBloc(
      categoriesResult: const Result.failure(AppError.errorServer()),
    );
    addTearDown(bloc.close);

    bloc.add(const HeaderEvent.started());
    await Future<void>.delayed(Duration.zero);

    expect(bloc.state.categories, isEmpty);
  });

  test('searchQueryChanged below the minimum length clears suggestions '
      'without calling the use case', () async {
    final bloc = _buildBloc();
    addTearDown(bloc.close);

    bloc.add(const HeaderEvent.searchQueryChanged('ve'));
    await Future<void>.delayed(Duration.zero);

    expect(bloc.state.searchQuery, 've');
    expect(bloc.state.suggestions, isEmpty);
  });

  test('searchQueryChanged at 3+ chars fetches suggestions', () async {
    final bloc = _buildBloc();
    addTearDown(bloc.close);

    bloc.add(const HeaderEvent.searchQueryChanged('vestido'));
    await Future<void>.delayed(Duration.zero);

    expect(bloc.state.suggestions, _suggestions);
  });

  test(
    'searchQueryChanged clears suggestions when the use case fails',
    () async {
      final bloc = _buildBloc(
        suggestionsResult: const Result.failure(AppError.errorServer()),
      );
      addTearDown(bloc.close);

      bloc.add(const HeaderEvent.searchQueryChanged('vestido'));
      await Future<void>.delayed(Duration.zero);

      expect(bloc.state.suggestions, isEmpty);
    },
  );

  test('searchCleared resets query and suggestions', () async {
    final bloc = _buildBloc();
    addTearDown(bloc.close);

    bloc.add(const HeaderEvent.searchQueryChanged('vestido'));
    await Future<void>.delayed(Duration.zero);
    bloc.add(const HeaderEvent.searchCleared());
    await Future<void>.delayed(Duration.zero);

    expect(bloc.state.searchQuery, isEmpty);
    expect(bloc.state.suggestions, isEmpty);
  });

  test('mobileMenuOpened and mobileMenuClosed toggle the flag', () async {
    final bloc = _buildBloc();
    addTearDown(bloc.close);

    bloc.add(const HeaderEvent.mobileMenuOpened());
    await Future<void>.delayed(Duration.zero);
    expect(bloc.state.isMobileMenuOpen, isTrue);

    bloc.add(const HeaderEvent.mobileMenuClosed());
    await Future<void>.delayed(Duration.zero);
    expect(bloc.state.isMobileMenuOpen, isFalse);
  });

  test('mobileSearchOpened closes the mobile menu', () async {
    final bloc = _buildBloc();
    addTearDown(bloc.close);

    bloc.add(const HeaderEvent.mobileMenuOpened());
    await Future<void>.delayed(Duration.zero);
    bloc.add(const HeaderEvent.mobileSearchOpened());
    await Future<void>.delayed(Duration.zero);

    expect(bloc.state.isMobileSearchOpen, isTrue);
    expect(bloc.state.isMobileMenuOpen, isFalse);
  });

  test('sessionEnded resets the session', () async {
    final bloc = _buildBloc();
    addTearDown(bloc.close);

    bloc.add(const HeaderEvent.sessionEnded());
    await Future<void>.delayed(Duration.zero);

    expect(bloc.state.isLoggedIn, isFalse);
    expect(bloc.state.firstName, isNull);
  });
}
