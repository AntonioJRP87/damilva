import 'package:damilva/core/extensions/context_extension.dart';
import 'package:damilva/shared/widgets/icons/custom_icon.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CategoryBreadcrumbs extends StatelessWidget {
  const CategoryBreadcrumbs({super.key, required this.categoryName});

  final String categoryName;

  @override
  Widget build(BuildContext context) {
    final colors = context.damilvaColors;
    final typography = context.damilvaTypography;
    final linkStyle = typography.text12w400.copyWith(
      color: colors.ink.withValues(alpha: 0.55),
    );

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: () => context.go('/'),
          child: Text(context.localizations.breadcrumb_home, style: linkStyle),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: CustomIcon(
            AppIcon.chevronRight,
            size: 12,
            color: colors.ink.withValues(alpha: 0.55),
          ),
        ),
        Text(
          categoryName,
          style: typography.text12w400.copyWith(color: colors.ink),
        ),
      ],
    );
  }
}
