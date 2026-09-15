import 'package:damilva/core/di/presentation_di.dart';
import 'package:damilva/core/extensions/context_extension.dart';
import 'package:damilva/core/extensions/sizes_extension.dart';
import 'package:damilva/core/utils/sizes.dart';
import 'package:damilva/features/category/presentation/bloc/category_list_bloc.dart';
import 'package:damilva/features/category/presentation/bloc/category_list_event.dart';
import 'package:damilva/features/category/presentation/bloc/category_list_state.dart';
import 'package:damilva/features/category/presentation/utils/category_filter_query.dart';
import 'package:damilva/features/category/presentation/widgets/category_active_filter_chips.dart';
import 'package:damilva/features/category/presentation/widgets/category_breadcrumbs.dart';
import 'package:damilva/features/category/presentation/widgets/category_empty_state.dart';
import 'package:damilva/features/category/presentation/widgets/category_filters_panel.dart';
import 'package:damilva/features/category/presentation/widgets/category_header_title.dart';
import 'package:damilva/features/category/presentation/widgets/category_loading_view.dart';
import 'package:damilva/features/category/presentation/widgets/category_mobile_filter_panel.dart';
import 'package:damilva/features/category/presentation/widgets/category_product_grid.dart';
import 'package:damilva/features/category/presentation/widgets/category_sort_control.dart';
import 'package:damilva/shared/widgets/buttons/custom_button.dart';
import 'package:damilva/shared/widgets/errors/custom_full_screen_error.dart';
import 'package:damilva/shared/widgets/mixins/errors_message_mixin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

String _humanizeSlug(String slug) => slug
    .split('-')
    .map(
      (word) => word.isEmpty ? word : word[0].toUpperCase() + word.substring(1),
    )
    .join(' ');

class CategoryListPage extends StatelessWidget {
  const CategoryListPage({
    super.key,
    this.categoryId,
    this.categoryName,
    this.searchQuery,
    required this.filters,
  });

  final String? categoryId;
  final String? categoryName;
  final String? searchQuery;
  final CategoryFilterQuery filters;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => presentationDi<CategoryListBloc>()
        ..add(
          CategoryListEvent.started(
            categoryId: categoryId,
            searchQuery: searchQuery,
            size: filters.size,
            color: filters.color,
            maxPrice: filters.maxPrice,
            onlyInStock: filters.onlyInStock,
            sort: filters.sort,
          ),
        ),
      child: SafeArea(
        child: _CategoryListView(
          categoryName: categoryId == null
              ? null
              : (categoryName ?? _humanizeSlug(categoryId!)),
        ),
      ),
    );
  }
}

class _CategoryListView extends StatelessWidget {
  const _CategoryListView({required this.categoryName});

  final String? categoryName;

  void _goToFilters(
    BuildContext context,
    CategoryListState state,
    CategoryFilterQuery query,
  ) {
    context.go(
      Uri(
        path: state.isSearch ? '/buscar' : '/c/${state.categoryId}',
        queryParameters: {
          if (state.isSearch) 'q': state.searchQuery!,
          ...query.toQueryParameters(),
        },
      ).toString(),
      extra: categoryName,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryListBloc, CategoryListState>(
      builder: (context, state) {
        return Stack(
          children: [
            switch (state.status) {
              CategoryListStatus.initial ||
              CategoryListStatus.loading => const CategoryLoadingView(),
              CategoryListStatus.error => CustomFullScreenError(
                error: state.error!,
                onRetry: () => context.read<CategoryListBloc>().add(
                  const CategoryListEvent.retried(),
                ),
                onGoHome: () => context.go('/'),
              ),
              CategoryListStatus.success ||
              CategoryListStatus.empty => _CategoryListContent(
                state: state,
                categoryName: categoryName,
                onFilterChanged: (query) => _goToFilters(context, state, query),
              ),
            },
            if (state.isMobilePanelOpen)
              Positioned.fill(
                child: CategoryMobileFilterPanel(
                  onApply: (draftState) => _goToFilters(
                    context,
                    draftState,
                    CategoryFilterQuery(
                      size: draftState.draftSize,
                      color: draftState.draftColor,
                      maxPrice: draftState.draftMaxPrice,
                      onlyInStock: draftState.draftOnlyInStock,
                      sort: draftState.draftSort,
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _CategoryListContent extends StatelessWidget with ErrorsMessageMixin {
  const _CategoryListContent({
    required this.state,
    required this.categoryName,
    required this.onFilterChanged,
  });

  final CategoryListState state;
  final String? categoryName;
  final ValueChanged<CategoryFilterQuery> onFilterChanged;

  CategoryFilterQuery get _currentQuery => CategoryFilterQuery(
    size: state.size,
    color: state.color,
    maxPrice: state.maxPrice,
    onlyInStock: state.onlyInStock,
    sort: state.sort,
  );

  @override
  Widget build(BuildContext context) {
    final margin = context.responsiveMargin;
    final isDesktop = context.isDesktop;
    final localizations = context.localizations;

    final title = state.isSearch
        ? localizations.category_search_results_title(state.searchQuery!)
        : categoryName!;

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: margin,
        vertical: AppSizes.categorySectionSpacing,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!state.isSearch) ...[
            CategoryBreadcrumbs(categoryName: categoryName!),
            const SizedBox(height: AppSizes.categoryBreadcrumbSpacing),
          ],
          CategoryHeaderTitle(title: title, total: state.total),
          const SizedBox(height: AppSizes.categorySectionSpacing),
          CategoryActiveFilterChips(
            size: state.size,
            color: state.color,
            maxPrice: state.maxPrice,
            onlyInStock: state.onlyInStock,
            onSizeRemoved: () =>
                onFilterChanged(_currentQuery.copyWith(size: null)),
            onColorRemoved: () =>
                onFilterChanged(_currentQuery.copyWith(color: null)),
            onMaxPriceRemoved: () =>
                onFilterChanged(_currentQuery.copyWith(maxPrice: null)),
            onOnlyInStockRemoved: () =>
                onFilterChanged(_currentQuery.copyWith(onlyInStock: false)),
            onClearAll: () =>
                onFilterChanged(CategoryFilterQuery(sort: state.sort)),
          ),
          const SizedBox(height: AppSizes.categorySectionSpacing),
          if (state.status == CategoryListStatus.empty)
            CategoryEmptyState(
              reason: state.isSearch
                  ? CategoryEmptyReason.search
                  : state.hasActiveFilters
                  ? CategoryEmptyReason.filtered
                  : CategoryEmptyReason.category,
              searchQuery: state.searchQuery,
              onClearFilters: () =>
                  onFilterChanged(CategoryFilterQuery(sort: state.sort)),
            )
          else
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isDesktop) ...[
                  CategoryFiltersPanel(
                    sizes: state.availableSizes,
                    colors: state.availableColors,
                    priceMin: state.priceRangeMin ?? 0,
                    priceMax: state.priceRangeMax ?? 0,
                    selectedSize: state.size,
                    selectedColor: state.color,
                    selectedMaxPrice: state.maxPrice,
                    onlyInStock: state.onlyInStock,
                    onSizeChanged: (value) =>
                        onFilterChanged(_currentQuery.copyWith(size: value)),
                    onColorChanged: (value) =>
                        onFilterChanged(_currentQuery.copyWith(color: value)),
                    onMaxPriceChanged: (value) => onFilterChanged(
                      _currentQuery.copyWith(maxPrice: value),
                    ),
                    onOnlyInStockChanged: (value) => onFilterChanged(
                      _currentQuery.copyWith(onlyInStock: value),
                    ),
                  ),
                  const SizedBox(width: AppSizes.categoryFilterPanelSpacing),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Align(
                        alignment: Alignment.centerRight,
                        child: isDesktop
                            ? CategorySortControl(
                                sort: state.sort,
                                onChanged: (value) => onFilterChanged(
                                  _currentQuery.copyWith(sort: value),
                                ),
                              )
                            : CustomButton(
                                label: localizations
                                    .category_mobile_filter_and_sort,
                                variant: CustomButtonVariant.secondary,
                                fullWidth: false,
                                onPressed: () =>
                                    context.read<CategoryListBloc>().add(
                                      const CategoryListEvent.mobilePanelOpened(),
                                    ),
                              ),
                      ),
                      const SizedBox(
                        height: AppSizes.categoryFilterGroupSpacing,
                      ),
                      CategoryProductGrid(
                        products: state.products,
                        hasMore: state.hasMore,
                        isLoadingMore: state.isLoadingMore,
                        loadMoreErrorText: state.loadMoreError == null
                            ? null
                            : errorText(context, state.loadMoreError!),
                        onLoadMore: () => context.read<CategoryListBloc>().add(
                          const CategoryListEvent.moreProductsRequested(),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
