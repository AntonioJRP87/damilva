import 'package:damilva/core/extensions/context_extension.dart';
import 'package:damilva/core/utils/currency_formatter.dart';
import 'package:damilva/core/utils/sizes.dart';
import 'package:flutter/material.dart';

class CategoryFilterFields extends StatelessWidget {
  const CategoryFilterFields({
    super.key,
    required this.sizes,
    required this.colors,
    required this.priceMin,
    required this.priceMax,
    required this.selectedSize,
    required this.selectedColor,
    required this.selectedMaxPrice,
    required this.onlyInStock,
    required this.onSizeChanged,
    required this.onColorChanged,
    required this.onMaxPriceChanged,
    required this.onOnlyInStockChanged,
  });

  final List<String> sizes;
  final List<String> colors;
  final double priceMin;
  final double priceMax;
  final String? selectedSize;
  final String? selectedColor;
  final double? selectedMaxPrice;
  final bool onlyInStock;
  final ValueChanged<String?> onSizeChanged;
  final ValueChanged<String?> onColorChanged;
  final ValueChanged<double?> onMaxPriceChanged;
  final ValueChanged<bool> onOnlyInStockChanged;

  @override
  Widget build(BuildContext context) {
    final colorsTheme = context.damilvaColors;
    final typography = context.damilvaTypography;
    final localizations = context.localizations;
    final hasPriceRange = priceMax > priceMin;
    final currentMaxPrice = selectedMaxPrice ?? priceMax;

    Widget sectionTitle(String text) => Text(
      text.toUpperCase(),
      style: typography.text13w800.copyWith(
        color: colorsTheme.ink,
        letterSpacing: typography.text13w800.fontSize! * 0.10,
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (sizes.isNotEmpty) ...[
          sectionTitle(localizations.category_filter_size),
          const SizedBox(height: AppSizes.categoryFilterGroupSpacing),
          Wrap(
            spacing: AppSizes.categoryChipSpacing,
            runSpacing: AppSizes.categoryChipSpacing,
            children: sizes
                .map(
                  (value) => _FilterOptionChip(
                    label: value,
                    selected: value == selectedSize,
                    onTap: () =>
                        onSizeChanged(value == selectedSize ? null : value),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: AppSizes.categoryFilterPanelSpacing),
        ],
        if (colors.isNotEmpty) ...[
          sectionTitle(localizations.category_filter_color),
          const SizedBox(height: AppSizes.categoryFilterGroupSpacing),
          Wrap(
            spacing: AppSizes.categoryChipSpacing,
            runSpacing: AppSizes.categoryChipSpacing,
            children: colors
                .map(
                  (value) => _FilterOptionChip(
                    label: value,
                    selected: value == selectedColor,
                    onTap: () =>
                        onColorChanged(value == selectedColor ? null : value),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: AppSizes.categoryFilterPanelSpacing),
        ],
        if (hasPriceRange) ...[
          sectionTitle(localizations.category_filter_price),
          const SizedBox(height: AppSizes.categoryFilterGroupSpacing),
          Text(
            CurrencyFormatter.format(currentMaxPrice),
            style: typography.text14w400.copyWith(color: colorsTheme.ink),
          ),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: colorsTheme.primary,
              thumbColor: colorsTheme.primary,
              overlayColor: colorsTheme.primary.withValues(alpha: 0.12),
              inactiveTrackColor: colorsTheme.ink.withValues(alpha: 0.2),
            ),
            child: Slider(
              min: priceMin,
              max: priceMax,
              value: currentMaxPrice.clamp(priceMin, priceMax),
              onChanged: (_) {},
              onChangeEnd: (value) =>
                  onMaxPriceChanged(value >= priceMax ? null : value),
            ),
          ),
          const SizedBox(height: AppSizes.categoryFilterPanelSpacing),
        ],
        InkWell(
          onTap: () => onOnlyInStockChanged(!onlyInStock),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Checkbox(
                value: onlyInStock,
                activeColor: colorsTheme.primary,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                ),
                onChanged: (value) => onOnlyInStockChanged(value ?? false),
              ),
              Text(
                localizations.category_filter_only_in_stock,
                style: typography.text13w400.copyWith(color: colorsTheme.ink),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _FilterOptionChip extends StatelessWidget {
  const _FilterOptionChip({
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

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.categoryChipPaddingHorizontal,
            vertical: AppSizes.categoryChipPaddingVertical,
          ),
          decoration: BoxDecoration(
            border: Border.all(
              color: selected
                  ? colors.primary
                  : colors.ink.withValues(
                      alpha: AppSizes.categoryChipBorderAlpha,
                    ),
              width: selected
                  ? AppSizes.categoryChipBorderWidthSelected
                  : AppSizes.categoryChipBorderWidth,
            ),
          ),
          child: Text(
            label,
            style: typography.text13w400.copyWith(color: colors.ink),
          ),
        ),
      ),
    );
  }
}
