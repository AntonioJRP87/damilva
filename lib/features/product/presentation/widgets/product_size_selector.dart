import 'package:damilva/core/extensions/context_extension.dart';
import 'package:damilva/core/utils/sizes.dart';
import 'package:damilva/features/product/domain/entities/product_detail.dart';
import 'package:damilva/shared/widgets/buttons/custom_button.dart';
import 'package:flutter/material.dart';

class ProductSizeSelector extends StatelessWidget {
  const ProductSizeSelector({
    super.key,
    required this.product,
    required this.selectedColor,
    required this.selectedSize,
    required this.onSizeSelected,
  });

  final ProductDetail product;
  final String? selectedColor;
  final String? selectedSize;
  final ValueChanged<String> onSizeSelected;

  @override
  Widget build(BuildContext context) {
    final color = selectedColor;
    if (color == null) return const SizedBox.shrink();

    final colorsTheme = context.damilvaColors;
    final typography = context.damilvaTypography;
    final localizations = context.localizations;

    final variantsForColor = product.variantsForColor(color);
    final allSoldOut = variantsForColor.every((variant) => variant.soldOut);
    final anyUnavailable = variantsForColor.any((variant) => variant.soldOut);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          localizations.category_filter_size,
          style: typography.text14w800.copyWith(color: colorsTheme.ink),
        ),
        const SizedBox(height: AppSizes.productSelectorSpacing),
        Wrap(
          spacing: AppSizes.categoryChipSpacing,
          runSpacing: AppSizes.categoryChipSpacing,
          children: [
            for (final size in product.allSizes)
              _SizeChip(
                label: size,
                selected: size == selectedSize,
                available:
                    product.variantFor(color: color, size: size)?.soldOut ==
                    false,
                onTap: () => onSizeSelected(size),
              ),
          ],
        ),
        const SizedBox(height: AppSizes.productSelectorSpacing),
        if (allSoldOut)
          CustomButton(
            label: localizations.product_notify_when_back,
            variant: CustomButtonVariant.ghost,
            fullWidth: false,
            onPressed: null,
          )
        else if (anyUnavailable)
          Text(
            localizations.product_size_note,
            style: typography.text12w400.copyWith(
              color: colorsTheme.ink.withValues(alpha: 0.55),
            ),
          ),
      ],
    );
  }
}

class _SizeChip extends StatelessWidget {
  const _SizeChip({
    required this.label,
    required this.selected,
    required this.available,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final bool available;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.damilvaColors;
    final typography = context.damilvaTypography;

    return Opacity(
      opacity: available ? 1 : 0.45,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: available ? onTap : null,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.productChipPaddingHorizontal,
              vertical: AppSizes.productChipPaddingVertical,
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
              style: typography.text14w800.copyWith(
                color: colors.ink,
                decoration: available ? null : TextDecoration.lineThrough,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
