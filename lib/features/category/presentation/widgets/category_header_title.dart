import 'package:damilva/core/extensions/context_extension.dart';
import 'package:damilva/core/extensions/sizes_extension.dart';
import 'package:damilva/core/utils/sizes.dart';
import 'package:flutter/material.dart';

class CategoryHeaderTitle extends StatelessWidget {
  const CategoryHeaderTitle({super.key, required this.title, this.total});

  final String title;
  final int? total;

  @override
  Widget build(BuildContext context) {
    final colors = context.damilvaColors;
    final typography = context.damilvaTypography;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: context.isDesktop
              ? typography.text40w800.copyWith(color: colors.ink)
              : typography.text26w800.copyWith(color: colors.ink),
        ),
        if (total != null) ...[
          const SizedBox(height: AppSizes.categoryHeaderSpacing),
          Text(
            context.localizations.category_product_count(total!),
            style: typography.text13w400.copyWith(
              color: colors.ink.withValues(alpha: 0.55),
            ),
          ),
        ],
      ],
    );
  }
}
