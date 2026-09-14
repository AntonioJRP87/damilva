import 'package:damilva/core/extensions/context_extension.dart';
import 'package:damilva/core/extensions/sizes_extension.dart';
import 'package:damilva/features/header/presentation/bloc/header_bloc.dart';
import 'package:damilva/features/header/presentation/bloc/header_state.dart';
import 'package:damilva/features/header/presentation/widgets/header_account_section.dart';
import 'package:damilva/features/header/presentation/widgets/header_cart_button.dart';
import 'package:damilva/features/header/presentation/widgets/header_category_menu.dart';
import 'package:damilva/features/header/presentation/widgets/header_logo.dart';
import 'package:damilva/features/header/presentation/widgets/header_mobile_bar.dart';
import 'package:damilva/features/header/presentation/widgets/header_search_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppHeader extends StatelessWidget {
  const AppHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.damilvaColors;

    return BlocBuilder<HeaderBloc, HeaderState>(
      builder: (context, state) {
        return DecoratedBox(
          decoration: BoxDecoration(
            color: colors.white,
            border: Border(bottom: BorderSide(color: colors.ink, width: 2)),
          ),
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: context.responsiveMargin,
                vertical: context.isDesktop ? 12 : 4,
              ),
              child: context.isDesktop
                  ? _DesktopHeader(state: state)
                  : HeaderMobileBar(cartItemsCount: state.cartItemsCount),
            ),
          ),
        );
      },
    );
  }
}

class _DesktopHeader extends StatelessWidget {
  const _DesktopHeader({required this.state});

  final HeaderState state;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const HeaderLogo(),
        const SizedBox(width: 32),
        SizedBox(
          width: 320,
          child: HeaderSearchField(key: const ValueKey('desktop-search')),
        ),
        const SizedBox(width: 16),
        HeaderCategoryMenu(categories: state.categories),
        const Spacer(),
        HeaderAccountSection(
          isLoggedIn: state.isLoggedIn,
          firstName: state.firstName,
        ),
        const SizedBox(width: 8),
        HeaderCartButton(itemsCount: state.cartItemsCount),
      ],
    );
  }
}
