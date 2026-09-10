import 'package:damilva/core/extensions/context_extension.dart';
import 'package:damilva/core/utils/sizes.dart';
import 'package:flutter/material.dart';

enum StatusBadgeStyle { accent, outline, neutral }

class CustomStatusBadge extends StatelessWidget {
  const CustomStatusBadge({
    super.key,
    required this.label,
    required this.style,
    this.muted = false,
  });

  final String label;
  final StatusBadgeStyle style;
  final bool muted;

  @override
  Widget build(BuildContext context) {
    final colors = context.damilvaColors;
    final typography = context.damilvaTypography;

    final backgroundColor = switch (style) {
      StatusBadgeStyle.accent => colors.primary,
      StatusBadgeStyle.outline => colors.white,
      StatusBadgeStyle.neutral => colors.neutral100,
    };
    final textColor = switch (style) {
      StatusBadgeStyle.accent => colors.white,
      StatusBadgeStyle.outline => colors.ink,
      StatusBadgeStyle.neutral => colors.ink,
    };
    final borderSide = switch (style) {
      StatusBadgeStyle.outline => BorderSide(
        color: colors.ink,
        width: AppSizes.statusBadgeBorderWidth,
      ),
      StatusBadgeStyle.accent || StatusBadgeStyle.neutral => BorderSide.none,
    };

    final chip = DecoratedBox(
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border.fromBorderSide(borderSide),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.statusBadgePaddingHorizontal,
          vertical: AppSizes.statusBadgePaddingVertical,
        ),
        child: Text(
          label.toUpperCase(),
          style: typography.text11w800caps.copyWith(color: textColor),
        ),
      ),
    );

    return muted
        ? Opacity(opacity: AppSizes.statusBadgeMutedAlpha, child: chip)
        : chip;
  }
}
