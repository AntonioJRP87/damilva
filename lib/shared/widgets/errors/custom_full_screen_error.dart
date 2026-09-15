import 'package:damilva/core/errors/app_error.dart';
import 'package:damilva/core/extensions/context_extension.dart';
import 'package:damilva/core/utils/sizes.dart';
import 'package:damilva/shared/widgets/buttons/custom_button.dart';
import 'package:damilva/shared/widgets/icons/custom_icon.dart';
import 'package:damilva/shared/widgets/mixins/errors_message_mixin.dart';
import 'package:flutter/material.dart';

/// Renders whichever [error] it receives with its own title and detail from
/// the message catalog, instead of collapsing every non-connection failure
/// into the same generic server-error text.
class CustomFullScreenError extends StatelessWidget with ErrorsMessageMixin {
  const CustomFullScreenError({
    super.key,
    required this.error,
    required this.onRetry,
    this.onGoHome,
  });

  final AppError error;
  final VoidCallback onRetry;

  /// Shown instead of "Reintentar" for errors where retrying can't help
  /// (e.g. a page that no longer exists). Falls back to onRetry when null.
  final VoidCallback? onGoHome;

  bool get _offersGoHomeInstead => error is PageNotFound && onGoHome != null;

  @override
  Widget build(BuildContext context) {
    final colors = context.damilvaColors;
    final typography = context.damilvaTypography;
    final localizations = context.localizations;

    final isNoConnection = error is NoInternetConnection;
    final title = errorText(context, error);
    final detail = errorDetail(context, error);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.noticeBoxPadding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomIcon(
              isNoConnection ? AppIcon.wifiOff : AppIcon.circleAlert,
              size: AppSizes.iconSizeInlineLarge * 2,
              color: colors.ink,
            ),
            const SizedBox(height: AppSizes.noticeBoxContentSpacing),
            Text(
              title,
              textAlign: TextAlign.center,
              style: typography.text15w800.copyWith(color: colors.ink),
            ),
            if (detail != null) ...[
              const SizedBox(height: AppSizes.noticeBoxTextSpacing),
              Text(
                detail,
                textAlign: TextAlign.center,
                style: typography.text13w400.copyWith(color: colors.ink),
              ),
            ],
            const SizedBox(height: AppSizes.noticeBoxContentSpacing),
            CustomButton(
              label: _offersGoHomeInstead
                  ? localizations.go_home
                  : localizations.retry,
              onPressed: _offersGoHomeInstead ? onGoHome! : onRetry,
              fullWidth: false,
            ),
          ],
        ),
      ),
    );
  }
}
