import 'package:damilva/core/extensions/context_extension.dart';
import 'package:damilva/core/utils/sizes.dart';
import 'package:damilva/features/header/domain/entities/category.dart';
import 'package:damilva/shared/widgets/icons/custom_icon.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HeaderCategoryMenu extends StatelessWidget {
  const HeaderCategoryMenu({super.key, required this.categories});

  final List<Category> categories;

  @override
  Widget build(BuildContext context) {
    final colors = context.damilvaColors;
    final typography = context.damilvaTypography;
    final localizations = context.localizations;

    return MenuAnchor(
      menuChildren: categories
          .map(
            (category) => MenuItemButton(
              onPressed: () =>
                  context.go('/c/${category.id}', extra: category.name),
              child: Text(
                category.name,
                style: typography.text13w400.copyWith(color: colors.ink),
              ),
            ),
          )
          .toList(),
      builder: (context, controller, child) {
        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              if (controller.isOpen) {
                controller.close();
              } else {
                controller.open();
              }
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    localizations.header_categories.toUpperCase(),
                    style: typography.text14w800.copyWith(
                      color: colors.ink,
                      letterSpacing: typography.text14w800.fontSize! * 0.06,
                    ),
                  ),
                  const SizedBox(width: 4),
                  CustomIcon(
                    AppIcon.chevronDown,
                    size: AppSizes.iconSizeInlineSmall,
                    color: colors.ink,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
