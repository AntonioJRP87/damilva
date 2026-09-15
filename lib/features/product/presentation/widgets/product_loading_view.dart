import 'package:damilva/core/extensions/context_extension.dart';
import 'package:damilva/core/extensions/sizes_extension.dart';
import 'package:damilva/core/utils/sizes.dart';
import 'package:flutter/material.dart';

class ProductLoadingView extends StatelessWidget {
  const ProductLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.damilvaColors;
    final margin = context.responsiveMargin;

    Widget line(double width) => SizedBox(
      width: width,
      height: AppSizes.productLoadingTextLineHeight,
      child: ColoredBox(color: colors.surface),
    );

    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(
        horizontal: margin,
        vertical: AppSizes.productSectionSpacing,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AspectRatio(
            aspectRatio: AppSizes.productGalleryAspectRatio,
            child: ColoredBox(color: colors.surface),
          ),
          const SizedBox(height: AppSizes.productContentSpacing),
          line(240),
          const SizedBox(height: AppSizes.productLoadingTextLineSpacing),
          line(120),
        ],
      ),
    );
  }
}
