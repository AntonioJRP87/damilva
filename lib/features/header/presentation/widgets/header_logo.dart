import 'package:damilva/core/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HeaderLogo extends StatelessWidget {
  const HeaderLogo({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = context.localizations;
    final isHome = GoRouterState.of(context).uri.path == '/';

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isHome ? null : () => context.go('/'),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Semantics(
            label: localizations.name_app,
            image: true,
            child: Image.asset(
              'assets/logo/logo.jpeg',
              height: 44,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}
