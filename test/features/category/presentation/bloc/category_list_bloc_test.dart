import 'package:damilva/core/errors/app_error.dart';
import 'package:damilva/core/result/result.dart';
import 'package:damilva/features/category/domain/entities/category_filters.dart';
import 'package:damilva/features/category/domain/entities/category_listing.dart';
import 'package:damilva/features/category/domain/entities/category_product.dart';
import 'package:damilva/features/category/domain/enums/category_sort_option.dart';
import 'package:damilva/features/category/domain/usecases/get_category_listing_use_case.dart';
import 'package:damilva/features/category/domain/usecases/get_search_listing_use_case.dart';
import 'package:damilva/features/category/presentation/bloc/category_list_bloc.dart';
import 'package:damilva/features/category/presentation/bloc/category_list_event.dart';
import 'package:damilva/features/category/presentation/bloc/category_list_state.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeGetCategoryListingUseCase
    implements GetCategoryListingUseCaseContract {
  _FakeGetCategoryListingUseCase(this.results);

  final List<Result<CategoryListing, AppError>> results;
  int calls = 0;

  @override
  Future<Result<CategoryListing, AppError>> call({
    required String categoryId,
    String? size,
    String? color,
    double? maxPrice,
    required bool onlyInStock,
    required CategorySortOption sort,
    required int page,
  }) async {
    final result = results[calls];
    calls++;
    return result;
  }
}

class _FakeGetSearchListingUseCase implements GetSearchListingUseCaseContract {
  _FakeGetSearchListingUseCase(this.result);

  final Result<CategoryListing, AppError> result;

  @override
  Future<Result<CategoryListing, AppError>> call({
    required String query,
    String? size,
    String? color,
    double? maxPrice,
    required bool onlyInStock,
    required CategorySortOption sort,
    required int page,
  }) async => result;
}

const _product = CategoryProduct(
  id: '1',
  name: 'Vestido midi de lunares',
  price: 39.9,
  soldOut: false,
  imageUrl: 'img.jpg',
);

const _filters = CategoryFilters(
  sizes: ['S', 'M'],
  colors: ['Rojo'],
  priceMin: 10,
  priceMax: 100,
);

CategoryListBloc _buildBloc(
  List<Result<CategoryListing, AppError>> categoryResults, {
  Result<CategoryListing, AppError>? searchResult,
}) {
  return CategoryListBloc(
    _FakeGetCategoryListingUseCase(categoryResults),
    _FakeGetSearchListingUseCase(
      searchResult ??
          const Result.success(
            CategoryListing(total: 0, products: [], filters: _filters),
          ),
    ),
  );
}

void main() {
  test('emits loading then success when there are products', () async {
    final bloc = _buildBloc([
      const Result.success(
        CategoryListing(total: 1, products: [_product], filters: _filters),
      ),
    ]);
    addTearDown(bloc.close);

    final states = <CategoryListState>[];
    final subscription = bloc.stream.listen(states.add);

    bloc.add(
      const CategoryListEvent.started(
        categoryId: 'vestidos-y-monos',
        onlyInStock: false,
      ),
    );
    await Future<void>.delayed(Duration.zero);
    await subscription.cancel();

    expect(states[0].status, CategoryListStatus.loading);
    expect(states[1].status, CategoryListStatus.success);
    expect(states[1].products, [_product]);
    expect(states[1].total, 1);
    expect(states[1].availableSizes, ['S', 'M']);
  });

  test('emits empty status when there are no products', () async {
    final bloc = _buildBloc([
      const Result.success(
        CategoryListing(total: 0, products: [], filters: _filters),
      ),
    ]);
    addTearDown(bloc.close);

    bloc.add(
      const CategoryListEvent.started(
        categoryId: 'novedades',
        onlyInStock: false,
      ),
    );
    await Future<void>.delayed(Duration.zero);

    expect(bloc.state.status, CategoryListStatus.empty);
  });

  test('emits error status when the use case fails', () async {
    final bloc = _buildBloc([const Result.failure(AppError.errorServer())]);
    addTearDown(bloc.close);

    bloc.add(
      const CategoryListEvent.started(
        categoryId: 'novedades',
        onlyInStock: false,
      ),
    );
    await Future<void>.delayed(Duration.zero);

    expect(bloc.state.status, CategoryListStatus.error);
    expect(bloc.state.error, const AppError.errorServer());
  });

  test(
    'moreProductsRequested appends products and advances the page',
    () async {
      final bloc = _buildBloc([
        const Result.success(
          CategoryListing(total: 2, products: [_product], filters: _filters),
        ),
        const Result.success(
          CategoryListing(total: 2, products: [_product], filters: _filters),
        ),
      ]);
      addTearDown(bloc.close);

      bloc.add(
        const CategoryListEvent.started(
          categoryId: 'novedades',
          onlyInStock: false,
        ),
      );
      await Future<void>.delayed(Duration.zero);
      expect(bloc.state.hasMore, isTrue);

      bloc.add(const CategoryListEvent.moreProductsRequested());
      await Future<void>.delayed(Duration.zero);

      expect(bloc.state.products.length, 2);
      expect(bloc.state.page, 2);
      expect(bloc.state.hasMore, isFalse);
    },
  );

  test(
    'moreProductsRequested failure keeps existing products and sets loadMoreError',
    () async {
      final bloc = _buildBloc([
        const Result.success(
          CategoryListing(total: 2, products: [_product], filters: _filters),
        ),
        const Result.failure(AppError.errorServer()),
      ]);
      addTearDown(bloc.close);

      bloc.add(
        const CategoryListEvent.started(
          categoryId: 'novedades',
          onlyInStock: false,
        ),
      );
      await Future<void>.delayed(Duration.zero);

      bloc.add(const CategoryListEvent.moreProductsRequested());
      await Future<void>.delayed(Duration.zero);

      expect(bloc.state.products, [_product]);
      expect(bloc.state.loadMoreError, const AppError.errorServer());
      expect(bloc.state.isLoadingMore, isFalse);
    },
  );

  test('mobilePanelOpened copies the applied filters into the draft', () async {
    final bloc = _buildBloc([
      const Result.success(
        CategoryListing(total: 1, products: [_product], filters: _filters),
      ),
    ]);
    addTearDown(bloc.close);

    bloc.add(
      const CategoryListEvent.started(
        categoryId: 'novedades',
        size: 'M',
        onlyInStock: true,
      ),
    );
    await Future<void>.delayed(Duration.zero);

    bloc.add(const CategoryListEvent.mobilePanelOpened());
    await Future<void>.delayed(Duration.zero);

    expect(bloc.state.isMobilePanelOpen, isTrue);
    expect(bloc.state.draftSize, 'M');
    expect(bloc.state.draftOnlyInStock, isTrue);
  });

  test('mobilePanelClosed closes the panel', () async {
    final bloc = _buildBloc([
      const Result.success(
        CategoryListing(total: 1, products: [_product], filters: _filters),
      ),
    ]);
    addTearDown(bloc.close);

    bloc.add(
      const CategoryListEvent.started(
        categoryId: 'novedades',
        onlyInStock: false,
      ),
    );
    await Future<void>.delayed(Duration.zero);
    bloc.add(const CategoryListEvent.mobilePanelOpened());
    await Future<void>.delayed(Duration.zero);
    bloc.add(const CategoryListEvent.mobilePanelClosed());
    await Future<void>.delayed(Duration.zero);

    expect(bloc.state.isMobilePanelOpen, isFalse);
  });

  test('started with a search query uses the search use case', () async {
    final bloc = _buildBloc(
      const [],
      searchResult: const Result.success(
        CategoryListing(total: 1, products: [_product], filters: _filters),
      ),
    );
    addTearDown(bloc.close);

    bloc.add(
      const CategoryListEvent.started(
        searchQuery: 'vestido rojo',
        onlyInStock: false,
      ),
    );
    await Future<void>.delayed(Duration.zero);

    expect(bloc.state.status, CategoryListStatus.success);
    expect(bloc.state.isSearch, isTrue);
  });
}
