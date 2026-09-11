import 'package:damilva/core/extensions/context_extension.dart';
import 'package:damilva/core/extensions/sizes_extension.dart';
import 'package:damilva/core/utils/sizes.dart';
import 'package:flutter/material.dart';

class HomeLoadingView extends StatelessWidget {
  const HomeLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.damilvaColors;
    final margin = context.responsiveMargin;
    final columns = context.productGridColumns;

    Widget block({required double aspectRatio}) {
      return AspectRatio(
        aspectRatio: aspectRatio,
        child: ColoredBox(color: colors.surface),
      );
    }

    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          block(aspectRatio: context.homeHeroAspectRatio),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: margin,
              vertical: AppSizes.homeSectionSpacing,
            ),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: columns * 2,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: columns,
                mainAxisSpacing: AppSizes.homeGridSpacing,
                crossAxisSpacing: AppSizes.homeGridSpacing,
                childAspectRatio: AppSizes.productCardImageAspectRatio,
              ),
              itemBuilder: (context, index) =>
                  ColoredBox(color: colors.surface),
            ),
          ),
        ],
      ),
    );
  }
}
