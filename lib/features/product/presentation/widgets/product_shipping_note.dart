import 'package:damilva/core/extensions/context_extension.dart';
import 'package:damilva/core/utils/sizes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProductShippingNote extends StatelessWidget {
  const ProductShippingNote({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.damilvaColors;
    final typography = context.damilvaTypography;
    final localizations = context.localizations;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          localizations.product_shipping_estimate,
          style: typography.text14w400.copyWith(color: colors.ink),
        ),
        const SizedBox(height: AppSizes.categoryFilterOptionSpacing),
        TextButton(
          onPressed: () => context.go('/envios'),
          style: TextButton.styleFrom(
            foregroundColor: colors.primary,
            padding: EdgeInsets.zero,
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            alignment: Alignment.centerLeft,
          ),
          child: Text(
            localizations.product_shipping_info_link,
            style: typography.text13w400.copyWith(color: colors.primary),
          ),
        ),
      ],
    );
  }
}
