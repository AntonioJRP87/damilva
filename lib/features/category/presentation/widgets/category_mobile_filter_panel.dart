import 'package:damilva/core/extensions/context_extension.dart';
import 'package:damilva/core/extensions/sizes_extension.dart';
import 'package:damilva/core/utils/sizes.dart';
import 'package:damilva/features/category/domain/enums/category_sort_option.dart';
import 'package:damilva/features/category/presentation/bloc/category_list_bloc.dart';
import 'package:damilva/features/category/presentation/bloc/category_list_event.dart';
import 'package:damilva/features/category/presentation/bloc/category_list_state.dart';
import 'package:damilva/features/category/presentation/utils/category_sort_option_label.dart';
import 'package:damilva/features/category/presentation/widgets/category_filter_fields.dart';
import 'package:damilva/shared/widgets/buttons/custom_button.dart';
import 'package:damilva/shared/widgets/icons/custom_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoryMobileFilterPanel extends StatelessWidget {
  const CategoryMobileFilterPanel({super.key, required this.onApply});

  final ValueChanged<CategoryListState> onApply;

  @override
  Widget build(BuildContext context) {
    final colors = context.damilvaColors;
    final typography = context.damilvaTypography;
    final localizations = context.localizations;

    return ColoredBox(
      color: colors.white,
      child: SafeArea(
        child: BlocBuilder<CategoryListBloc, CategoryListState>(
          builder: (context, state) {
            final bloc = context.read<CategoryListBloc>();

            return Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: context.responsiveMargin,
                    vertical: AppSizes.categoryMobilePanelPadding,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        localizations.category_mobile_filter_and_sort,
                        style: typography.text16w800.copyWith(
                          color: colors.ink,
                        ),
                      ),
                      InkWell(
                        onTap: () => bloc.add(
                          const CategoryListEvent.mobilePanelClosed(),
                        ),
                        child: CustomIcon(
                          AppIcon.x,
                          size: AppSizes.iconSizeInlineLarge,
                          color: colors.ink,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: context.responsiveMargin,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ...CategorySortOption.values.map(
                          (option) => _SortOptionRow(
                            label: categorySortOptionLabel(context, option),
                            selected: option == state.draftSort,
                            onTap: () => bloc.add(
                              CategoryListEvent.draftSortChanged(option),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: AppSizes.categoryFilterPanelSpacing,
                        ),
                        CategoryFilterFields(
                          sizes: state.availableSizes,
                          colors: state.availableColors,
                          priceMin: state.priceRangeMin ?? 0,
                          priceMax: state.priceRangeMax ?? 0,
                          selectedSize: state.draftSize,
                          selectedColor: state.draftColor,
                          selectedMaxPrice: state.draftMaxPrice,
                          onlyInStock: state.draftOnlyInStock,
                          onSizeChanged: (value) => bloc.add(
                            CategoryListEvent.draftSizeChanged(value),
                          ),
                          onColorChanged: (value) => bloc.add(
                            CategoryListEvent.draftColorChanged(value),
                          ),
                          onMaxPriceChanged: (value) => bloc.add(
                            CategoryListEvent.draftMaxPriceChanged(value),
                          ),
                          onOnlyInStockChanged: (value) => bloc.add(
                            CategoryListEvent.draftOnlyInStockChanged(value),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(context.responsiveMargin),
                  child: CustomButton(
                    label: localizations.apply,
                    onPressed: () => onApply(state),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _SortOptionRow extends StatelessWidget {
  const _SortOptionRow({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.damilvaColors;
    final typography = context.damilvaTypography;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: AppSizes.categoryFilterOptionSpacing,
        ),
        child: Row(
          children: [
            Icon(
              selected
                  ? Icons.radio_button_checked
                  : Icons.radio_button_unchecked,
              size: AppSizes.iconSizeInlineSmall,
              color: selected ? colors.primary : colors.ink,
            ),
            const SizedBox(width: AppSizes.categoryFilterOptionSpacing),
            Text(
              label,
              style: typography.text13w400.copyWith(color: colors.ink),
            ),
          ],
        ),
      ),
    );
  }
}
