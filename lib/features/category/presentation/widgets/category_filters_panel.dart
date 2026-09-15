import 'package:damilva/core/extensions/context_extension.dart';
import 'package:damilva/core/utils/sizes.dart';
import 'package:damilva/features/category/presentation/widgets/category_filter_fields.dart';
import 'package:flutter/material.dart';

class CategoryFiltersPanel extends StatelessWidget {
  const CategoryFiltersPanel({
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

    return SizedBox(
      width: AppSizes.filterPanelWidth,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.localizations.category_filters_title.toUpperCase(),
            style: typography.text13w800.copyWith(
              color: colorsTheme.ink,
              letterSpacing: typography.text13w800.fontSize! * 0.10,
            ),
          ),
          const SizedBox(height: AppSizes.categoryFilterPanelSpacing),
          CategoryFilterFields(
            sizes: sizes,
            colors: colors,
            priceMin: priceMin,
            priceMax: priceMax,
            selectedSize: selectedSize,
            selectedColor: selectedColor,
            selectedMaxPrice: selectedMaxPrice,
            onlyInStock: onlyInStock,
            onSizeChanged: onSizeChanged,
            onColorChanged: onColorChanged,
            onMaxPriceChanged: onMaxPriceChanged,
            onOnlyInStockChanged: onOnlyInStockChanged,
          ),
        ],
      ),
    );
  }
}
