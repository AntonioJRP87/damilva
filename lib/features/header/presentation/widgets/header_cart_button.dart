import 'package:damilva/core/extensions/context_extension.dart';
import 'package:damilva/core/extensions/sizes_extension.dart';
import 'package:damilva/shared/widgets/icons/custom_icon.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HeaderCartButton extends StatelessWidget {
  const HeaderCartButton({super.key, required this.itemsCount});

  final int itemsCount;

  @override
  Widget build(BuildContext context) {
    final colors = context.damilvaColors;
    final typography = context.damilvaTypography;
    final localizations = context.localizations;

    return Semantics(
      button: true,
      label: localizations.header_cart_button,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => context.go('/carrito'),
          child: SizedBox(
            width: 44,
            height: 44,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CustomIcon(
                  AppIcon.shoppingBag,
                  size: context.headerIconSize,
                  color: colors.ink,
                ),
                if (itemsCount > 0)
                  Positioned(
                    top: 4,
                    right: 4,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: 1,
                      ),
                      constraints: const BoxConstraints(minWidth: 16),
                      decoration: BoxDecoration(color: colors.primary),
                      child: Text(
                        '$itemsCount',
                        textAlign: TextAlign.center,
                        style: typography.text10w800caps.copyWith(
                          color: colors.white,
                          letterSpacing: 0,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
