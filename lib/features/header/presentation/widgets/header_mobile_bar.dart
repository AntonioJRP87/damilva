import 'package:damilva/core/extensions/context_extension.dart';
import 'package:damilva/core/extensions/sizes_extension.dart';
import 'package:damilva/features/header/presentation/bloc/header_bloc.dart';
import 'package:damilva/features/header/presentation/bloc/header_event.dart';
import 'package:damilva/features/header/presentation/widgets/header_cart_button.dart';
import 'package:damilva/features/header/presentation/widgets/header_logo.dart';
import 'package:damilva/shared/widgets/icons/custom_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HeaderMobileBar extends StatelessWidget {
  const HeaderMobileBar({super.key, required this.cartItemsCount});

  final int cartItemsCount;

  @override
  Widget build(BuildContext context) {
    final localizations = context.localizations;

    return Row(
      children: [
        _IconButton(
          icon: AppIcon.menu,
          label: localizations.header_menu_button,
          onTap: () => context.read<HeaderBloc>().add(
            const HeaderEvent.mobileMenuOpened(),
          ),
        ),
        const Expanded(child: Center(child: HeaderLogo())),
        _IconButton(
          icon: AppIcon.search,
          label: localizations.header_search_button,
          onTap: () => context.read<HeaderBloc>().add(
            const HeaderEvent.mobileSearchOpened(),
          ),
        ),
        HeaderCartButton(itemsCount: cartItemsCount),
      ],
    );
  }
}

class _IconButton extends StatelessWidget {
  const _IconButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final AppIcon icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.damilvaColors;

    return Semantics(
      button: true,
      label: label,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: SizedBox(
            width: 44,
            height: 44,
            child: CustomIcon(
              icon,
              size: context.headerIconSize,
              color: colors.ink,
            ),
          ),
        ),
      ),
    );
  }
}
