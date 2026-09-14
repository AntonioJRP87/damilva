import 'package:damilva/core/extensions/context_extension.dart';
import 'package:damilva/core/extensions/sizes_extension.dart';
import 'package:damilva/features/header/domain/entities/category.dart';
import 'package:damilva/features/header/presentation/bloc/header_bloc.dart';
import 'package:damilva/features/header/presentation/bloc/header_event.dart';
import 'package:damilva/shared/widgets/icons/custom_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class HeaderMobileMenuPanel extends StatelessWidget {
  const HeaderMobileMenuPanel({
    super.key,
    required this.categories,
    required this.isLoggedIn,
    required this.firstName,
  });

  final List<Category> categories;
  final bool isLoggedIn;
  final String? firstName;

  void _navigate(BuildContext context, String path) {
    context.read<HeaderBloc>().add(const HeaderEvent.mobileMenuClosed());
    context.go(path);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.damilvaColors;
    final typography = context.damilvaTypography;
    final localizations = context.localizations;

    return ColoredBox(
      color: colors.white,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: context.responsiveMargin,
                vertical: 12,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Semantics(
                    button: true,
                    label: localizations.close,
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () => context.read<HeaderBloc>().add(
                          const HeaderEvent.mobileMenuClosed(),
                        ),
                        child: SizedBox(
                          width: 44,
                          height: 44,
                          child: CustomIcon(AppIcon.x, color: colors.ink),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(
                  horizontal: context.responsiveMargin,
                ),
                children: [
                  Text(
                    localizations.header_categories.toUpperCase(),
                    style: typography.text11w800caps.copyWith(
                      color: colors.ink,
                      letterSpacing: typography.text11w800caps.fontSize! * 0.2,
                    ),
                  ),
                  const SizedBox(height: 12),
                  for (final category in categories)
                    _MobileMenuLink(
                      label: category.name,
                      onTap: () => _navigate(context, '/c/${category.id}'),
                    ),
                  const SizedBox(height: 24),
                  Text(
                    localizations.account_title.toUpperCase(),
                    style: typography.text11w800caps.copyWith(
                      color: colors.ink,
                      letterSpacing: typography.text11w800caps.fontSize! * 0.2,
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (!isLoggedIn)
                    _MobileMenuLink(
                      label: localizations.header_login,
                      onTap: () => _navigate(context, '/acceso'),
                    )
                  else ...[
                    if (firstName != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Text(
                          firstName!,
                          style: typography.text16w800.copyWith(
                            color: colors.ink,
                          ),
                        ),
                      ),
                    _MobileMenuLink(
                      label: localizations.account_my_orders,
                      onTap: () => _navigate(context, '/cuenta/pedidos'),
                    ),
                    _MobileMenuLink(
                      label: localizations.account_my_details,
                      onTap: () => _navigate(context, '/cuenta'),
                    ),
                    _MobileMenuLink(
                      label: localizations.account_sign_out,
                      onTap: () {
                        context.read<HeaderBloc>().add(
                          const HeaderEvent.sessionEnded(),
                        );
                      },
                    ),
                  ],
                  const SizedBox(height: 24),
                  Wrap(
                    spacing: 16,
                    runSpacing: 8,
                    children: [
                      _LegalLink(
                        label: localizations.legal_notice_title,
                        onTap: () => _navigate(context, '/aviso-legal'),
                      ),
                      _LegalLink(
                        label: localizations.privacy_policy_title,
                        onTap: () => _navigate(context, '/privacidad'),
                      ),
                      _LegalLink(
                        label: localizations.cookies_policy_title,
                        onTap: () => _navigate(context, '/cookies'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MobileMenuLink extends StatelessWidget {
  const _MobileMenuLink({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.damilvaColors;
    final typography = context.damilvaTypography;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: SizedBox(
            width: double.infinity,
            child: Text(
              label,
              style: typography.text14w800.copyWith(color: colors.ink),
            ),
          ),
        ),
      ),
    );
  }
}

class _LegalLink extends StatelessWidget {
  const _LegalLink({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.damilvaColors;
    final typography = context.damilvaTypography;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Text(
          label,
          style: typography.text12w400.copyWith(
            color: colors.ink.withValues(alpha: 0.55),
          ),
        ),
      ),
    );
  }
}
