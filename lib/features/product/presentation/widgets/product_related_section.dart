import 'package:damilva/core/extensions/context_extension.dart';
import 'package:damilva/core/extensions/sizes_extension.dart';
import 'package:damilva/core/utils/currency_formatter.dart';
import 'package:damilva/core/utils/sizes.dart';
import 'package:damilva/features/product/domain/entities/related_product.dart';
import 'package:damilva/shared/widgets/product_cards/custom_product_card.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProductRelatedSection extends StatelessWidget {
  const ProductRelatedSection({super.key, required this.related});

  final List<RelatedProduct> related;

  @override
  Widget build(BuildContext context) {
    if (related.isEmpty) return const SizedBox.shrink();

    final colors = context.damilvaColors;
    final typography = context.damilvaTypography;
    final columns = context.productGridColumns;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.localizations.product_related_title,
          style: typography.text32w800.copyWith(color: colors.ink),
        ),
        const SizedBox(height: AppSizes.homeSectionTitleSpacing),
        LayoutBuilder(
          builder: (context, constraints) {
            final cellWidth =
                (constraints.maxWidth -
                    (columns - 1) * AppSizes.homeGridSpacing) /
                columns;
            final cellHeight =
                cellWidth / AppSizes.productCardImageAspectRatio +
                AppSizes.productRelatedCardTextBlockHeight;

            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: related.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: columns,
                mainAxisSpacing: AppSizes.homeGridSpacing,
                crossAxisSpacing: AppSizes.homeGridSpacing,
                childAspectRatio: cellWidth / cellHeight,
              ),
              itemBuilder: (context, index) {
                final product = related[index];
                return CustomProductCard(
                  imageUrl: product.imageUrl,
                  name: product.name,
                  price: CurrencyFormatter.format(product.price),
                  onTap: () => context.go('/p/${product.id}'),
                );
              },
            );
          },
        ),
      ],
    );
  }
}
