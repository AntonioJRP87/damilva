import 'package:damilva/core/extensions/context_extension.dart';
import 'package:damilva/core/extensions/sizes_extension.dart';
import 'package:damilva/core/utils/sizes.dart';
import 'package:damilva/features/home/domain/entities/featured_category.dart';
import 'package:flutter/material.dart';

class HomeFeaturedCategoriesSection extends StatelessWidget {
  const HomeFeaturedCategoriesSection({super.key, required this.categories});

  final List<FeaturedCategory> categories;

  @override
  Widget build(BuildContext context) {
    if (categories.isEmpty) return const SizedBox.shrink();

    final typography = context.damilvaTypography;
    final colors = context.damilvaColors;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.responsiveMargin),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.localizations.home_featured_categories_title,
            style: typography.text32w800.copyWith(color: colors.ink),
          ),
          const SizedBox(height: AppSizes.homeSectionTitleSpacing),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: categories.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: context.productGridColumns,
              mainAxisSpacing: AppSizes.homeGridSpacing,
              crossAxisSpacing: AppSizes.homeGridSpacing,
              childAspectRatio: AppSizes.homeFeaturedCategoryAspectRatio,
            ),
            itemBuilder: (context, index) {
              final category = categories[index];
              return _FeaturedCategoryTile(category: category);
            },
          ),
        ],
      ),
    );
  }
}

class _FeaturedCategoryTile extends StatelessWidget {
  const _FeaturedCategoryTile({required this.category});

  final FeaturedCategory category;

  @override
  Widget build(BuildContext context) {
    final colors = context.damilvaColors;
    final typography = context.damilvaTypography;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {},
        child: Stack(
          fit: StackFit.expand,
          children: [
            ColoredBox(
              color: colors.surface,
              child: Image.network(
                category.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    const SizedBox.shrink(),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: ColoredBox(
                color: colors.white.withValues(alpha: 0.92),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 12,
                  ),
                  child: Text(
                    category.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: typography.text14w800.copyWith(color: colors.ink),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
