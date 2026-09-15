import 'package:damilva/core/errors/app_error.dart';
import 'package:damilva/features/category/domain/entities/category_product.dart';
import 'package:damilva/features/category/domain/enums/category_sort_option.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'category_list_state.freezed.dart';

enum CategoryListStatus { initial, loading, success, empty, error }

@freezed
abstract class CategoryListState with _$CategoryListState {
  const factory CategoryListState({
    @Default(CategoryListStatus.initial) CategoryListStatus status,
    String? categoryId,
    String? searchQuery,
    @Default([]) List<CategoryProduct> products,
    @Default(0) int total,
    @Default([]) List<String> availableSizes,
    @Default([]) List<String> availableColors,
    double? priceRangeMin,
    double? priceRangeMax,
    String? size,
    String? color,
    double? maxPrice,
    @Default(false) bool onlyInStock,
    @Default(CategorySortOption.newestFirst) CategorySortOption sort,
    @Default(1) int page,
    @Default(false) bool isLoadingMore,
    AppError? loadMoreError,
    AppError? error,
    @Default(false) bool isMobilePanelOpen,
    String? draftSize,
    String? draftColor,
    double? draftMaxPrice,
    @Default(false) bool draftOnlyInStock,
    @Default(CategorySortOption.newestFirst) CategorySortOption draftSort,
  }) = _CategoryListState;

  const CategoryListState._();

  bool get isSearch => searchQuery != null;

  bool get hasMore => products.length < total;

  bool get hasActiveFilters =>
      size != null || color != null || maxPrice != null || onlyInStock;
}
