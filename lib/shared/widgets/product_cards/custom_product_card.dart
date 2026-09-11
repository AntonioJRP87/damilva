import 'package:damilva/core/extensions/context_extension.dart';
import 'package:damilva/core/utils/sizes.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

enum ProductCardBadge { newIn, offer, soldOut }

class CustomProductCard extends StatelessWidget {
  const CustomProductCard({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.price,
    this.previousPrice,
    this.badge,
    this.isWishlisted = false,
    this.onTap,
    this.onWishlistToggle,
  });

  final String imageUrl;
  final String name;
  final String price;
  final String? previousPrice;
  final ProductCardBadge? badge;
  final bool isWishlisted;
  final VoidCallback? onTap;
  final VoidCallback? onWishlistToggle;

  @override
  Widget build(BuildContext context) {
    final colors = context.damilvaColors;
    final typography = context.damilvaTypography;
    final localizations = context.localizations;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              children: [
                AspectRatio(
                  aspectRatio: AppSizes.productCardImageAspectRatio,
                  child: ColoredBox(
                    color: colors.surface,
                    child: Image.network(
                      imageUrl,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) =>
                          const SizedBox.shrink(),
                    ),
                  ),
                ),
                if (badge == ProductCardBadge.soldOut)
                  Positioned.fill(
                    child: ColoredBox(
                      color: colors.white.withValues(
                        alpha: AppSizes.productCardSoldOutVeilAlpha,
                      ),
                      child: Center(
                        child: _ProductCardChip(
                          label: localizations.product_badge_sold_out,
                          textColor: colors.ink,
                          backgroundColor: colors.white,
                        ),
                      ),
                    ),
                  )
                else if (badge != null)
                  Positioned(
                    top: 0,
                    left: 0,
                    child: _ProductCardChip(
                      label: switch (badge!) {
                        ProductCardBadge.newIn =>
                          localizations.product_badge_new,
                        ProductCardBadge.offer =>
                          localizations.product_badge_offer,
                        ProductCardBadge.soldOut =>
                          localizations.product_badge_sold_out,
                      },
                      textColor: colors.ink,
                      backgroundColor: colors.white,
                    ),
                  ),
                Positioned(
                  top: AppSizes.wishlistButtonMargin,
                  right: AppSizes.wishlistButtonMargin,
                  child: _WishlistButton(
                    isWishlisted: isWishlisted,
                    onPressed: onWishlistToggle,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSizes.productCardContentSpacing),
            Text(
              name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: typography.text14w400.copyWith(color: colors.ink),
            ),
            const SizedBox(height: AppSizes.productCardContentSpacing / 2),
            Row(
              children: [
                Text(
                  price,
                  style: typography.text15w800.copyWith(color: colors.ink),
                ),
                if (previousPrice != null) ...[
                  const SizedBox(width: AppSizes.productCardContentSpacing),
                  Flexible(
                    child: Text(
                      previousPrice!,
                      overflow: TextOverflow.ellipsis,
                      style: typography.text14w400.copyWith(
                        color: colors.ink.withValues(
                          alpha: AppSizes.productCardPreviousPriceAlpha,
                        ),
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ProductCardChip extends StatelessWidget {
  const _ProductCardChip({
    required this.label,
    required this.textColor,
    required this.backgroundColor,
  });

  final String label;
  final Color textColor;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    final typography = context.damilvaTypography;

    return ColoredBox(
      color: backgroundColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.productCardBadgePaddingHorizontal,
          vertical: AppSizes.productCardBadgePaddingVertical,
        ),
        child: Text(
          label.toUpperCase(),
          style: typography.text10w800caps.copyWith(color: textColor),
        ),
      ),
    );
  }
}

class _WishlistButton extends StatelessWidget {
  const _WishlistButton({required this.isWishlisted, required this.onPressed});

  final bool isWishlisted;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = context.damilvaColors;
    final localizations = context.localizations;

    return Semantics(
      button: true,
      label: isWishlisted
          ? localizations.wishlist_remove
          : localizations.wishlist_add,
      child: Material(
        color: colors.white.withValues(
          alpha: AppSizes.wishlistButtonBackgroundAlpha,
        ),
        child: InkWell(
          onTap: onPressed,
          child: SizedBox(
            width: AppSizes.wishlistButtonSize,
            height: AppSizes.wishlistButtonSize,
            child: Icon(
              LucideIcons.heart,
              size: AppSizes.wishlistIconSize,
              color: isWishlisted ? colors.primary : colors.ink,
            ),
          ),
        ),
      ),
    );
  }
}
