import 'package:damilva/core/extensions/context_extension.dart';
import 'package:damilva/core/extensions/sizes_extension.dart';
import 'package:damilva/core/utils/sizes.dart';
import 'package:flutter/material.dart';

class HomeTrustBar extends StatelessWidget {
  const HomeTrustBar({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.damilvaColors;
    final typography = context.damilvaTypography;
    final localizations = context.localizations;

    final items = [
      localizations.home_trust_secure_payment,
      localizations.home_trust_personal_service,
      localizations.home_trust_nationwide_shipping,
    ];

    return DecoratedBox(
      decoration: BoxDecoration(color: colors.neutral100),
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: AppSizes.homeTrustBarPaddingVertical,
          horizontal: context.responsiveMargin,
        ),
        child: Wrap(
          alignment: WrapAlignment.start,
          spacing: AppSizes.homeSectionSpacing,
          runSpacing: AppSizes.homeSectionTitleSpacing,
          children: items
              .map(
                (text) => Text(
                  text,
                  style: typography.text15w800.copyWith(color: colors.ink),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
