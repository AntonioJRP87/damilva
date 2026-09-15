import 'package:damilva/core/extensions/context_extension.dart';
import 'package:damilva/core/utils/currency_formatter.dart';
import 'package:damilva/core/utils/sizes.dart';
import 'package:damilva/shared/widgets/icons/custom_icon.dart';
import 'package:flutter/material.dart';

class CategoryActiveFilterChips extends StatelessWidget {
  const CategoryActiveFilterChips({
    super.key,
    required this.size,
    required this.color,
    required this.maxPrice,
    required this.onlyInStock,
    required this.onSizeRemoved,
    required this.onColorRemoved,
    required this.onMaxPriceRemoved,
    required this.onOnlyInStockRemoved,
    required this.onClearAll,
  });

  final String? size;
  final String? color;
  final double? maxPrice;
  final bool onlyInStock;
  final VoidCallback onSizeRemoved;
  final VoidCallback onColorRemoved;
  final VoidCallback onMaxPriceRemoved;
  final VoidCallback onOnlyInStockRemoved;
  final VoidCallback onClearAll;

  bool get _hasAny =>
      size != null || color != null || maxPrice != null || onlyInStock;

  @override
  Widget build(BuildContext context) {
    if (!_hasAny) return const SizedBox.shrink();

    final localizations = context.localizations;
    final colors = context.damilvaColors;
    final typography = context.damilvaTypography;

    return Wrap(
      spacing: AppSizes.categoryChipSpacing,
      runSpacing: AppSizes.categoryChipSpacing,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        if (size != null)
          _RemovableChip(label: size!, onRemoved: onSizeRemoved),
        if (color != null)
          _RemovableChip(label: color!, onRemoved: onColorRemoved),
        if (maxPrice != null)
          _RemovableChip(
            label: CurrencyFormatter.format(maxPrice!),
            onRemoved: onMaxPriceRemoved,
          ),
        if (onlyInStock)
          _RemovableChip(
            label: localizations.category_filter_only_in_stock,
            onRemoved: onOnlyInStockRemoved,
          ),
        InkWell(
          onTap: onClearAll,
          child: Text(
            localizations.category_clear_all_filters,
            style: typography.text13w400.copyWith(color: colors.primary),
          ),
        ),
      ],
    );
  }
}

class _RemovableChip extends StatelessWidget {
  const _RemovableChip({required this.label, required this.onRemoved});

  final String label;
  final VoidCallback onRemoved;

  @override
  Widget build(BuildContext context) {
    final colors = context.damilvaColors;
    final typography = context.damilvaTypography;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onRemoved,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.categoryChipPaddingHorizontal,
            vertical: AppSizes.categoryChipPaddingVertical,
          ),
          decoration: BoxDecoration(
            border: Border.all(
              color: colors.ink.withValues(
                alpha: AppSizes.categoryChipBorderAlpha,
              ),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: typography.text13w400.copyWith(color: colors.ink),
              ),
              const SizedBox(width: AppSizes.categoryChipSpacing / 2),
              CustomIcon(AppIcon.x, size: 14, color: colors.ink),
            ],
          ),
        ),
      ),
    );
  }
}
