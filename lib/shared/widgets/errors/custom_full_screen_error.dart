import 'package:damilva/core/errors/app_error.dart';
import 'package:damilva/core/extensions/context_extension.dart';
import 'package:damilva/core/utils/sizes.dart';
import 'package:damilva/shared/widgets/buttons/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class CustomFullScreenError extends StatelessWidget {
  const CustomFullScreenError({
    super.key,
    required this.error,
    required this.onRetry,
  });

  final AppError error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final colors = context.damilvaColors;
    final typography = context.damilvaTypography;
    final localizations = context.localizations;

    final isNoConnection = error is NoInternetConnection;
    final title = isNoConnection
        ? localizations.no_internet_connection
        : localizations.error_server;
    final detail = isNoConnection
        ? localizations.info_no_internet_connection
        : localizations.info_error_server;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.noticeBoxPadding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isNoConnection ? LucideIcons.wifiOff : LucideIcons.circleAlert,
              size: AppSizes.iconSizeInlineLarge * 2,
              color: colors.ink,
            ),
            const SizedBox(height: AppSizes.noticeBoxContentSpacing),
            Text(
              title,
              textAlign: TextAlign.center,
              style: typography.text15w800.copyWith(color: colors.ink),
            ),
            const SizedBox(height: AppSizes.noticeBoxTextSpacing),
            Text(
              detail,
              textAlign: TextAlign.center,
              style: typography.text13w400.copyWith(color: colors.ink),
            ),
            const SizedBox(height: AppSizes.noticeBoxContentSpacing),
            CustomButton(
              label: localizations.retry,
              onPressed: onRetry,
              fullWidth: false,
            ),
          ],
        ),
      ),
    );
  }
}
