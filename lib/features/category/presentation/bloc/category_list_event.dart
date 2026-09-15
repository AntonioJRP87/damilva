import 'package:damilva/features/category/domain/enums/category_sort_option.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'category_list_event.freezed.dart';

@freezed
sealed class CategoryListEvent with _$CategoryListEvent {
  const factory CategoryListEvent.started({
    String? categoryId,
    String? searchQuery,
    String? size,
    String? color,
    double? maxPrice,
    @Default(false) bool onlyInStock,
    @Default(CategorySortOption.newestFirst) CategorySortOption sort,
  }) = CategoryListStarted;

  const factory CategoryListEvent.moreProductsRequested() =
      CategoryMoreProductsRequested;

  const factory CategoryListEvent.retried() = CategoryListRetried;

  const factory CategoryListEvent.mobilePanelOpened() =
      CategoryMobilePanelOpened;

  const factory CategoryListEvent.mobilePanelClosed() =
      CategoryMobilePanelClosed;

  const factory CategoryListEvent.draftSizeChanged(String? size) =
      CategoryDraftSizeChanged;

  const factory CategoryListEvent.draftColorChanged(String? color) =
      CategoryDraftColorChanged;

  const factory CategoryListEvent.draftMaxPriceChanged(double? maxPrice) =
      CategoryDraftMaxPriceChanged;

  const factory CategoryListEvent.draftOnlyInStockChanged(bool onlyInStock) =
      CategoryDraftOnlyInStockChanged;

  const factory CategoryListEvent.draftSortChanged(CategorySortOption sort) =
      CategoryDraftSortChanged;
}
