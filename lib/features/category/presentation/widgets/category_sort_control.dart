import 'package:damilva/core/extensions/context_extension.dart';
import 'package:damilva/features/category/domain/enums/category_sort_option.dart';
import 'package:damilva/features/category/presentation/utils/category_sort_option_label.dart';
import 'package:damilva/shared/widgets/icons/custom_icon.dart';
import 'package:flutter/material.dart';

class CategorySortControl extends StatelessWidget {
  const CategorySortControl({
    super.key,
    required this.sort,
    required this.onChanged,
  });

  final CategorySortOption sort;
  final ValueChanged<CategorySortOption> onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.damilvaColors;
    final typography = context.damilvaTypography;

    return PopupMenuButton<CategorySortOption>(
      initialValue: sort,
      onSelected: onChanged,
      color: colors.white,
      shape: const RoundedRectangleBorder(
        side: BorderSide(),
        borderRadius: BorderRadius.zero,
      ),
      itemBuilder: (context) => CategorySortOption.values
          .map(
            (option) => PopupMenuItem(
              value: option,
              child: Text(
                categorySortOptionLabel(context, option),
                style: typography.text13w400.copyWith(color: colors.ink),
              ),
            ),
          )
          .toList(),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            categorySortOptionLabel(context, sort),
            style: typography.text13w800.copyWith(color: colors.ink),
          ),
          const SizedBox(width: 4),
          CustomIcon(AppIcon.chevronDown, size: 16, color: colors.ink),
        ],
      ),
    );
  }
}
