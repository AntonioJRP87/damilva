import 'package:damilva/core/extensions/context_extension.dart';
import 'package:damilva/core/utils/sizes.dart';
import 'package:damilva/features/header/presentation/bloc/header_bloc.dart';
import 'package:damilva/features/header/presentation/bloc/header_event.dart';
import 'package:damilva/shared/widgets/icons/custom_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class HeaderAccountSection extends StatelessWidget {
  const HeaderAccountSection({
    super.key,
    required this.isLoggedIn,
    required this.firstName,
  });

  final bool isLoggedIn;
  final String? firstName;

  @override
  Widget build(BuildContext context) {
    final colors = context.damilvaColors;
    final typography = context.damilvaTypography;
    final localizations = context.localizations;

    if (!isLoggedIn) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => context.go('/acceso'),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomIcon(
                  AppIcon.user,
                  size: AppSizes.iconSizeInlineSmall,
                  color: colors.ink,
                ),
                const SizedBox(width: 4),
                Text(
                  localizations.header_login,
                  style: typography.text13w400.copyWith(color: colors.ink),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return MenuAnchor(
      menuChildren: [
        MenuItemButton(
          onPressed: () => context.go('/cuenta/pedidos'),
          child: Text(
            localizations.account_my_orders,
            style: typography.text13w400.copyWith(color: colors.ink),
          ),
        ),
        MenuItemButton(
          onPressed: () => context.go('/cuenta'),
          child: Text(
            localizations.account_my_details,
            style: typography.text13w400.copyWith(color: colors.ink),
          ),
        ),
        MenuItemButton(
          onPressed: () =>
              context.read<HeaderBloc>().add(const HeaderEvent.sessionEnded()),
          child: Text(
            localizations.account_sign_out,
            style: typography.text13w400.copyWith(color: colors.ink),
          ),
        ),
      ],
      builder: (context, controller, child) {
        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              if (controller.isOpen) {
                controller.close();
              } else {
                controller.open();
              }
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
              child: Text(
                firstName ?? '',
                style: typography.text13w400.copyWith(color: colors.ink),
              ),
            ),
          ),
        );
      },
    );
  }
}
