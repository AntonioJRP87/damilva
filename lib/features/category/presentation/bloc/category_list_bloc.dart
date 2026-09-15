import 'package:damilva/features/category/domain/usecases/get_category_listing_use_case.dart';
import 'package:damilva/features/category/domain/usecases/get_search_listing_use_case.dart';
import 'package:damilva/features/category/presentation/bloc/category_list_event.dart';
import 'package:damilva/features/category/presentation/bloc/category_list_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoryListBloc extends Bloc<CategoryListEvent, CategoryListState> {
  CategoryListBloc(
    this._getCategoryListingUseCase,
    this._getSearchListingUseCase,
  ) : super(const CategoryListState()) {
    on<CategoryListEvent>((event, emit) {
      return switch (event) {
        CategoryListStarted() => _onStarted(event, emit),
        CategoryMoreProductsRequested() => _onMoreProductsRequested(emit),
        CategoryListRetried() => _onRetried(emit),
        CategoryMobilePanelOpened() => _onMobilePanelOpened(emit),
        CategoryMobilePanelClosed() => _onMobilePanelClosed(emit),
        CategoryDraftSizeChanged() => _onDraftSizeChanged(event, emit),
        CategoryDraftColorChanged() => _onDraftColorChanged(event, emit),
        CategoryDraftMaxPriceChanged() => _onDraftMaxPriceChanged(event, emit),
        CategoryDraftOnlyInStockChanged() => _onDraftOnlyInStockChanged(
          event,
          emit,
        ),
        CategoryDraftSortChanged() => _onDraftSortChanged(event, emit),
      };
    });
  }

  final GetCategoryListingUseCaseContract _getCategoryListingUseCase;
  final GetSearchListingUseCaseContract _getSearchListingUseCase;

  Future<void> _onStarted(
    CategoryListStarted event,
    Emitter<CategoryListState> emit,
  ) async {
    emit(
      state.copyWith(
        status: CategoryListStatus.loading,
        categoryId: event.categoryId,
        searchQuery: event.searchQuery,
        products: const [],
        total: 0,
        size: event.size,
        color: event.color,
        maxPrice: event.maxPrice,
        onlyInStock: event.onlyInStock,
        sort: event.sort,
        page: 1,
        error: null,
      ),
    );
    await _fetch(emit, page: 1, replace: true);
  }

  Future<void> _onMoreProductsRequested(Emitter<CategoryListState> emit) async {
    if (state.isLoadingMore || !state.hasMore) return;
    emit(state.copyWith(isLoadingMore: true, loadMoreError: null));
    await _fetch(emit, page: state.page + 1, replace: false);
  }

  Future<void> _onRetried(Emitter<CategoryListState> emit) async {
    emit(state.copyWith(status: CategoryListStatus.loading, error: null));
    await _fetch(emit, page: 1, replace: true);
  }

  Future<void> _fetch(
    Emitter<CategoryListState> emit, {
    required int page,
    required bool replace,
  }) async {
    final result = state.isSearch
        ? await _getSearchListingUseCase(
            query: state.searchQuery!,
            size: state.size,
            color: state.color,
            maxPrice: state.maxPrice,
            onlyInStock: state.onlyInStock,
            sort: state.sort,
            page: page,
          )
        : await _getCategoryListingUseCase(
            categoryId: state.categoryId!,
            size: state.size,
            color: state.color,
            maxPrice: state.maxPrice,
            onlyInStock: state.onlyInStock,
            sort: state.sort,
            page: page,
          );

    if (result.isFailure) {
      if (replace) {
        emit(
          state.copyWith(status: CategoryListStatus.error, error: result.error),
        );
      } else {
        emit(state.copyWith(isLoadingMore: false, loadMoreError: result.error));
      }
      return;
    }

    final listing = result.data!;
    final products = replace
        ? listing.products
        : [...state.products, ...listing.products];

    emit(
      state.copyWith(
        status: products.isEmpty
            ? CategoryListStatus.empty
            : CategoryListStatus.success,
        products: products,
        total: listing.total,
        availableSizes: listing.filters.sizes,
        availableColors: listing.filters.colors,
        priceRangeMin: listing.filters.priceMin,
        priceRangeMax: listing.filters.priceMax,
        page: page,
        isLoadingMore: false,
        loadMoreError: null,
      ),
    );
  }

  void _onMobilePanelOpened(Emitter<CategoryListState> emit) {
    emit(
      state.copyWith(
        isMobilePanelOpen: true,
        draftSize: state.size,
        draftColor: state.color,
        draftMaxPrice: state.maxPrice,
        draftOnlyInStock: state.onlyInStock,
        draftSort: state.sort,
      ),
    );
  }

  void _onMobilePanelClosed(Emitter<CategoryListState> emit) {
    emit(state.copyWith(isMobilePanelOpen: false));
  }

  void _onDraftSizeChanged(
    CategoryDraftSizeChanged event,
    Emitter<CategoryListState> emit,
  ) {
    emit(state.copyWith(draftSize: event.size));
  }

  void _onDraftColorChanged(
    CategoryDraftColorChanged event,
    Emitter<CategoryListState> emit,
  ) {
    emit(state.copyWith(draftColor: event.color));
  }

  void _onDraftMaxPriceChanged(
    CategoryDraftMaxPriceChanged event,
    Emitter<CategoryListState> emit,
  ) {
    emit(state.copyWith(draftMaxPrice: event.maxPrice));
  }

  void _onDraftOnlyInStockChanged(
    CategoryDraftOnlyInStockChanged event,
    Emitter<CategoryListState> emit,
  ) {
    emit(state.copyWith(draftOnlyInStock: event.onlyInStock));
  }

  void _onDraftSortChanged(
    CategoryDraftSortChanged event,
    Emitter<CategoryListState> emit,
  ) {
    emit(state.copyWith(draftSort: event.sort));
  }
}
