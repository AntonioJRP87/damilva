import 'package:damilva/core/themes/colors/damilva_colors.dart';
import 'package:damilva/core/themes/colors/damilva_colors_extension.dart';
import 'package:damilva/core/themes/colors/damilva_default_colors.dart';
import 'package:damilva/core/themes/typography/damilva_typography.dart';
import 'package:damilva/core/themes/typography/damilva_typography_extension.dart';
import 'package:damilva/core/utils/sizes.dart';
import 'package:flutter/material.dart';

class DamilvaTheme {
  static ThemeData buildTheme({
    required String fontFamily,
    DamilvaColors? damilvaColors,
    String? package,
    Brightness brightness = Brightness.light,
    double scale = 1.0,
  }) {
    final colors = damilvaColors ?? DamilvaDefaultColors.colors;
    final typography = DamilvaTypography.create(
      fontFamily: fontFamily,
      package: package,
      scale: scale,
    );
    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      extensions: [
        DamilvaTypographyExtension.from(typography),
        DamilvaColorsExtension.from(colors),
      ],
      textSelectionTheme: TextSelectionThemeData(
        selectionColor: colors.primary,
        selectionHandleColor: colors.primary,
        cursorColor: colors.primary,
      ),
      inputDecorationTheme: InputDecorationTheme(
        isDense: true,
        filled: false,
        contentPadding: const EdgeInsets.symmetric(
          vertical: AppSizes.textFieldPaddingVertical,
          horizontal: AppSizes.textFieldPaddingHorizontal,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(
            width: AppSizes.textFieldBorderWidth,
            color: colors.ink.withValues(alpha: AppSizes.textFieldBorderAlpha),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(
            width: AppSizes.textFieldBorderWidth,
            color: colors.ink.withValues(alpha: AppSizes.textFieldBorderAlpha),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(
            width: AppSizes.textFieldBorderWidthEmphasis,
            color: colors.primary,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(
            width: AppSizes.textFieldBorderWidthEmphasis,
            color: colors.primary,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(
            width: AppSizes.textFieldBorderWidthEmphasis,
            color: colors.primary,
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(
            width: AppSizes.textFieldBorderWidth,
            color: colors.ink.withValues(alpha: AppSizes.textFieldBorderAlpha),
          ),
        ),
        hintStyle: typography.text14w400.copyWith(
          color: colors.ink.withValues(alpha: AppSizes.textFieldHintAlpha),
        ),
        labelStyle: typography.text12w400.copyWith(color: colors.ink),
        errorStyle: typography.text12w600.copyWith(color: colors.primaryDark),
        errorMaxLines: 2,
      ),
    );
  }
}
