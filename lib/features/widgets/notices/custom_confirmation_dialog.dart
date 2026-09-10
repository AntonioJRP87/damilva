import 'package:damilva/core/extensions/context_extension.dart';
import 'package:damilva/core/utils/sizes.dart';
import 'package:damilva/features/widgets/buttons/custom_button.dart';
import 'package:flutter/material.dart';

class CustomConfirmationDialog {
  const CustomConfirmationDialog._();

  static Future<bool> show(
    BuildContext context, {
    required String title,
    required String message,
    required String confirmLabel,
    String? cancelLabel,
  }) async {
    final colors = context.damilvaColors;
    final typography = context.damilvaTypography;
    final localizations = context.localizations;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return Dialog(
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: AppSizes.confirmationDialogMaxWidth,
            ),
            child: Padding(
              padding: const EdgeInsets.all(AppSizes.confirmationDialogPadding),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: typography.text18w800.copyWith(color: colors.ink),
                  ),
                  const SizedBox(
                    height: AppSizes.confirmationDialogContentSpacing,
                  ),
                  Text(
                    message,
                    style: typography.text14w400.copyWith(color: colors.ink),
                  ),
                  const SizedBox(height: AppSizes.confirmationDialogPadding),
                  CustomButton(
                    label: confirmLabel,
                    fullWidth: true,
                    onPressed: () => Navigator.of(dialogContext).pop(true),
                  ),
                  const SizedBox(
                    height: AppSizes.confirmationDialogActionSpacing,
                  ),
                  CustomButton(
                    label: cancelLabel ?? localizations.cancel,
                    variant: CustomButtonVariant.ghost,
                    fullWidth: true,
                    onPressed: () => Navigator.of(dialogContext).pop(false),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );

    return confirmed ?? false;
  }
}
