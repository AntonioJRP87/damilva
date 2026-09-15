import 'package:damilva/core/extensions/context_extension.dart';
import 'package:damilva/core/extensions/sizes_extension.dart';
import 'package:damilva/core/utils/sizes.dart';
import 'package:flutter/material.dart';

class CategoryLoadingView extends StatelessWidget {
  const CategoryLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.damilvaColors;
    final margin = context.responsiveMargin;
    final columns = context.productGridColumns;

    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(
        horizontal: margin,
        vertical: AppSizes.categorySectionSpacing,
      ),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: columns * 3,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: columns,
          mainAxisSpacing: AppSizes.categoryGridSpacing,
          crossAxisSpacing: AppSizes.categoryGridSpacing,
          childAspectRatio: AppSizes.productCardImageAspectRatio,
        ),
        itemBuilder: (context, index) => ColoredBox(color: colors.surface),
      ),
    );
  }
}
