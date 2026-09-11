import 'package:damilva/core/extensions/context_extension.dart';
import 'package:damilva/core/extensions/sizes_extension.dart';
import 'package:damilva/core/utils/currency_formatter.dart';
import 'package:damilva/core/utils/sizes.dart';
import 'package:damilva/features/home/domain/entities/home_product.dart';
import 'package:damilva/features/home/domain/enums/product_badge.dart';
import 'package:damilva/shared/widgets/product_cards/custom_product_card.dart';
import 'package:flutter/material.dart';

class HomeNewArrivalsSection extends StatelessWidget {
  const HomeNewArrivalsSection({super.key, required this.products});

  final List<HomeProduct> products;

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) return const SizedBox.shrink();

    final typography = context.damilvaTypography;
    final colors = context.damilvaColors;
    final columns = context.productGridColumns;
    final visibleProducts = products.take(columns * 2).toList();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.responsiveMargin),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                context.localizations.home_new_arrivals_title,
                style: typography.text32w800.copyWith(color: colors.ink),
              ),
              TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  foregroundColor: colors.primary,
                  padding: EdgeInsets.zero,
                ),
                child: Text(
                  context.localizations.home_new_arrivals_cta,
                  style: typography.text13w400.copyWith(color: colors.primary),
                ),
              ),
            ],
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
                  AppSizes.homeProductCardTextBlockHeight;

              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: visibleProducts.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: columns,
                  mainAxisSpacing: AppSizes.homeGridSpacing,
                  crossAxisSpacing: AppSizes.homeGridSpacing,
                  childAspectRatio: cellWidth / cellHeight,
                ),
                itemBuilder: (context, index) {
                  final product = visibleProducts[index];
                  return CustomProductCard(
                    imageUrl: product.imageUrl,
                    name: product.name,
                    price: CurrencyFormatter.format(product.price),
                    previousPrice: product.previousPrice != null
                        ? CurrencyFormatter.format(product.previousPrice!)
                        : null,
                    badge: switch (product.badge) {
                      ProductBadge.newIn => ProductCardBadge.newIn,
                      ProductBadge.offer => ProductCardBadge.offer,
                      null => null,
                    },
                    onWishlistToggle: null,
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
