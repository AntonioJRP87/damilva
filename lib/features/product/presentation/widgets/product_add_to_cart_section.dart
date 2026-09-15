import 'package:damilva/core/extensions/context_extension.dart';
import 'package:damilva/core/utils/sizes.dart';
import 'package:damilva/features/product/domain/entities/product_detail.dart';
import 'package:damilva/features/product/domain/entities/product_variant.dart';
import 'package:damilva/features/product/presentation/widgets/product_quantity_stepper.dart';
import 'package:damilva/shared/widgets/buttons/custom_button.dart';
import 'package:flutter/material.dart';

const _lowStockThreshold = 3;

class ProductAddToCartSection extends StatelessWidget {
  const ProductAddToCartSection({
    super.key,
    required this.product,
    required this.selectedSize,
    required this.selectedVariant,
    required this.quantity,
    required this.isSubmitting,
    required this.onIncrement,
    required this.onDecrement,
    required this.onAddToCart,
  });

  final ProductDetail product;
  final String? selectedSize;
  final ProductVariant? selectedVariant;
  final int quantity;
  final bool isSubmitting;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onAddToCart;

  @override
  Widget build(BuildContext context) {
    final colors = context.damilvaColors;
    final typography = context.damilvaTypography;
    final localizations = context.localizations;

    if (product.soldOut) {
      return CustomButton(
        label: localizations.product_badge_sold_out,
        onPressed: null,
      );
    }

    final variant = selectedVariant;
    if (variant == null) {
      return CustomButton(
        label: localizations.product_choose_size_to_continue,
        onPressed: null,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ProductQuantityStepper(
          quantity: quantity,
          maxQuantity: variant.stock,
          onIncrement: onIncrement,
          onDecrement: onDecrement,
        ),
        if (variant.stock <= _lowStockThreshold) ...[
          const SizedBox(height: AppSizes.productSelectorSpacing),
          Text(
            localizations.product_low_stock_warning(
              variant.stock,
              selectedSize!,
            ),
            style: typography.text13w600.copyWith(color: colors.primary),
          ),
        ],
        const SizedBox(height: AppSizes.productContentSpacing),
        CustomButton(
          label: localizations.product_add_to_cart,
          isLoading: isSubmitting,
          loadingLabel: localizations.product_add_to_cart,
          onPressed: onAddToCart,
        ),
      ],
    );
  }
}
