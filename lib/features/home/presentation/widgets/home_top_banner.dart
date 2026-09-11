import 'package:damilva/core/extensions/context_extension.dart';
import 'package:damilva/core/extensions/sizes_extension.dart';
import 'package:damilva/core/utils/currency_formatter.dart';
import 'package:flutter/material.dart';

class HomeTopBanner extends StatelessWidget {
  const HomeTopBanner({super.key, required this.freeShippingThreshold});

  final double freeShippingThreshold;

  @override
  Widget build(BuildContext context) {
    final colors = context.damilvaColors;
    final typography = context.damilvaTypography;
    final localizations = context.localizations;

    return ColoredBox(
      color: colors.ink,
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: 10,
          horizontal: context.responsiveMargin,
        ),
        child: Center(
          child: Text(
            localizations.home_free_shipping_banner(
              CurrencyFormatter.format(freeShippingThreshold),
            ),
            textAlign: TextAlign.center,
            style: typography.text12w800caps.copyWith(
              color: colors.white,
              letterSpacing: typography.text12w800caps.fontSize! * 0.1,
            ),
          ),
        ),
      ),
    );
  }
}
