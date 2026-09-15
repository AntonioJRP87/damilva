import 'package:damilva/core/enums/product_badge.dart';
import 'package:damilva/core/extensions/context_extension.dart';
import 'package:damilva/core/extensions/sizes_extension.dart';
import 'package:damilva/core/utils/currency_formatter.dart';
import 'package:damilva/core/utils/sizes.dart';
import 'package:damilva/features/category/domain/entities/category_product.dart';
import 'package:damilva/shared/widgets/product_cards/custom_product_card.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CategoryProductGrid extends StatelessWidget {
  const CategoryProductGrid({
    super.key,
    required this.products,
    required this.hasMore,
    required this.isLoadingMore,
    required this.loadMoreErrorText,
    required this.onLoadMore,
  });

  final List<CategoryProduct> products;
  final bool hasMore;
  final bool isLoadingMore;
  final String? loadMoreErrorText;
  final VoidCallback onLoadMore;

  @override
  Widget build(BuildContext context) {
    final columns = context.productGridColumns;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            final cellWidth =
                (constraints.maxWidth -
                    (columns - 1) * AppSizes.categoryGridSpacing) /
                columns;
            final cellHeight =
                cellWidth / AppSizes.productCardImageAspectRatio +
                AppSizes.categoryProductCardTextBlockHeight;

            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: products.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: columns,
                mainAxisSpacing: AppSizes.categoryGridSpacing,
                crossAxisSpacing: AppSizes.categoryGridSpacing,
                childAspectRatio: cellWidth / cellHeight,
              ),
              itemBuilder: (context, index) {
                final product = products[index];
                return CustomProductCard(
                  imageUrl: product.imageUrl,
                  name: product.name,
                  price: CurrencyFormatter.format(product.price),
                  previousPrice: product.previousPrice != null
                      ? CurrencyFormatter.format(product.previousPrice!)
                      : null,
                  badge: product.soldOut
                      ? ProductCardBadge.soldOut
                      : switch (product.badge) {
                          ProductBadge.newIn => ProductCardBadge.newIn,
                          ProductBadge.offer => ProductCardBadge.offer,
                          null => null,
                        },
                  onTap: () => context.go('/p/${product.id}'),
                );
              },
            );
          },
        ),
        if (hasMore || loadMoreErrorText != null) ...[
          const SizedBox(height: AppSizes.categoryLoadMoreSpacing),
          Center(
            child: _LoadMoreControl(
              isLoading: isLoadingMore,
              errorText: loadMoreErrorText,
              onPressed: onLoadMore,
            ),
          ),
        ],
      ],
    );
  }
}

class _LoadMoreControl extends StatelessWidget {
  const _LoadMoreControl({
    required this.isLoading,
    required this.errorText,
    required this.onPressed,
  });

  final bool isLoading;
  final String? errorText;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = context.damilvaColors;
    final typography = context.damilvaTypography;

    if (errorText != null) {
      return Column(
        children: [
          Text(
            errorText!,
            style: typography.text13w600.copyWith(color: colors.primary),
          ),
          const SizedBox(height: AppSizes.categoryFilterOptionSpacing),
          TextButton(
            onPressed: onPressed,
            style: TextButton.styleFrom(foregroundColor: colors.primary),
            child: Text(context.localizations.retry.toUpperCase()),
          ),
        ],
      );
    }

    return OutlinedButton(
      onPressed: isLoading ? null : onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: colors.ink,
        side: BorderSide(color: colors.ink, width: 2),
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      ),
      child: Text(
        context.localizations.category_load_more.toUpperCase(),
        style: typography.text14w800,
      ),
    );
  }
}
