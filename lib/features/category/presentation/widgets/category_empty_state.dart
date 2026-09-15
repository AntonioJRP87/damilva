import 'package:damilva/core/extensions/context_extension.dart';
import 'package:damilva/core/utils/sizes.dart';
import 'package:damilva/shared/widgets/buttons/custom_button.dart';
import 'package:damilva/shared/widgets/icons/custom_icon.dart';
import 'package:damilva/shared/widgets/notices/custom_notice_box.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

enum CategoryEmptyReason { search, filtered, category }

class CategoryEmptyState extends StatelessWidget {
  const CategoryEmptyState({
    super.key,
    required this.reason,
    this.searchQuery,
    required this.onClearFilters,
  });

  final CategoryEmptyReason reason;
  final String? searchQuery;
  final VoidCallback onClearFilters;

  @override
  Widget build(BuildContext context) {
    final localizations = context.localizations;
    final colors = context.damilvaColors;

    final (title, detail) = switch (reason) {
      CategoryEmptyReason.search => (
        localizations.category_empty_search_title(searchQuery ?? ''),
        localizations.category_empty_search_detail,
      ),
      CategoryEmptyReason.filtered => (
        localizations.category_empty_filtered_title,
        localizations.category_empty_filtered_detail,
      ),
      CategoryEmptyReason.category => (
        localizations.category_empty_category_title,
        localizations.category_empty_category_detail,
      ),
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomNoticeBox(
          icon: CustomIcon(AppIcon.circleAlert, color: colors.primary),
          title: title,
          detail: detail,
        ),
        const SizedBox(height: AppSizes.categoryEmptyStateSpacing),
        if (reason == CategoryEmptyReason.filtered)
          CustomButton(
            label: localizations.category_clear_all_filters,
            variant: CustomButtonVariant.secondary,
            fullWidth: false,
            onPressed: onClearFilters,
          )
        else
          CustomButton(
            label: localizations.see_new_arrivals,
            variant: CustomButtonVariant.secondary,
            fullWidth: false,
            onPressed: () => context.go('/c/novedades'),
          ),
      ],
    );
  }
}
