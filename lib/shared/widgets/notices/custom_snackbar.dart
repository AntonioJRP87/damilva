import 'package:damilva/core/extensions/context_extension.dart';
import 'package:flutter/material.dart';

class CustomSnackbar {
  const CustomSnackbar._();

  static const Duration duration = Duration(seconds: 4);

  static void show(
    BuildContext context, {
    required String message,
    VoidCallback? onUndo,
  }) {
    final colors = context.damilvaColors;
    final typography = context.damilvaTypography;
    final localizations = context.localizations;

    context.showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.fixed,
        duration: duration,
        backgroundColor: colors.ink,
        content: Text(
          message,
          style: typography.text14w400.copyWith(color: colors.white),
        ),
        action: onUndo == null
            ? null
            : SnackBarAction(
                label: localizations.snackbar_undo,
                textColor: colors.primary,
                onPressed: onUndo,
              ),
      ),
    );
  }
}
