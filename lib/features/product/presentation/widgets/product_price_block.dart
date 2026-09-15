import 'package:damilva/core/extensions/context_extension.dart';
import 'package:damilva/core/extensions/sizes_extension.dart';
import 'package:damilva/core/utils/currency_formatter.dart';
import 'package:damilva/core/utils/sizes.dart';
import 'package:flutter/material.dart';

class ProductPriceBlock extends StatelessWidget {
  const ProductPriceBlock({super.key, required this.price, this.previousPrice});

  final double price;
  final double? previousPrice;

  @override
  Widget build(BuildContext context) {
    final colors = context.damilvaColors;
    final typography = context.damilvaTypography;
    final localizations = context.localizations;

    final discountPercent = previousPrice == null || previousPrice == 0
        ? null
        : (((previousPrice! - price) / previousPrice!) * 100).round();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              CurrencyFormatter.format(price),
              style:
                  (context.isMobile
                          ? typography.text20w800
                          : typography.text32w800)
                      .copyWith(color: colors.ink),
            ),
            if (previousPrice != null) ...[
              const SizedBox(width: AppSizes.productSelectorSpacing),
              Text(
                CurrencyFormatter.format(previousPrice!),
                style: typography.text16w400.copyWith(
                  color: colors.ink.withValues(alpha: 0.5),
                  decoration: TextDecoration.lineThrough,
                ),
              ),
            ],
            if (discountPercent != null && discountPercent > 0) ...[
              const SizedBox(width: AppSizes.productSelectorSpacing),
              DecoratedBox(
                decoration: BoxDecoration(color: colors.primary),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.productDiscountBadgePaddingHorizontal,
                    vertical: AppSizes.productDiscountBadgePaddingVertical,
                  ),
                  child: Text(
                    '−$discountPercent%',
                    style: typography.text11w800caps.copyWith(
                      color: colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: AppSizes.productLoadingTextLineSpacing),
        Text(
          localizations.product_vat_included,
          style: typography.text12w400.copyWith(
            color: colors.ink.withValues(alpha: 0.55),
          ),
        ),
      ],
    );
  }
}
