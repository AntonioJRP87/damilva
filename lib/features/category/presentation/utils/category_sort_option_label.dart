import 'package:damilva/core/extensions/context_extension.dart';
import 'package:damilva/features/category/domain/enums/category_sort_option.dart';
import 'package:flutter/widgets.dart';

String categorySortOptionLabel(BuildContext context, CategorySortOption sort) {
  final localizations = context.localizations;
  return switch (sort) {
    CategorySortOption.newestFirst => localizations.category_sort_newest_first,
    CategorySortOption.priceAsc => localizations.category_sort_price_asc,
    CategorySortOption.priceDesc => localizations.category_sort_price_desc,
  };
}
