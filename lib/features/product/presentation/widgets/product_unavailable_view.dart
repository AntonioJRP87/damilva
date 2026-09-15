import 'package:damilva/core/extensions/context_extension.dart';
import 'package:damilva/core/utils/sizes.dart';
import 'package:damilva/shared/widgets/buttons/custom_button.dart';
import 'package:damilva/shared/widgets/icons/custom_icon.dart';
import 'package:flutter/material.dart';

class ProductUnavailableView extends StatelessWidget {
  const ProductUnavailableView({super.key, required this.onGoToCategory});

  final VoidCallback onGoToCategory;

  @override
  Widget build(BuildContext context) {
    final colors = context.damilvaColors;
    final typography = context.damilvaTypography;
    final localizations = context.localizations;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.noticeBoxPadding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomIcon(
              AppIcon.circleAlert,
              size: AppSizes.iconSizeInlineLarge * 2,
              color: colors.ink,
            ),
            const SizedBox(height: AppSizes.noticeBoxContentSpacing),
            Text(
              localizations.product_unavailable_title,
              textAlign: TextAlign.center,
              style: typography.text15w800.copyWith(color: colors.ink),
            ),
            const SizedBox(height: AppSizes.noticeBoxContentSpacing),
            CustomButton(
              label: localizations.product_back_to_category,
              onPressed: onGoToCategory,
              fullWidth: false,
            ),
          ],
        ),
      ),
    );
  }
}
