import 'package:damilva/presentation/themes/colors/damilva_colors.dart';
import 'package:damilva/presentation/themes/colors/damilva_colors_extension.dart';
import 'package:damilva/presentation/themes/colors/damilva_default_colors.dart';
import 'package:damilva/presentation/themes/typography/damilva_typography.dart';
import 'package:damilva/presentation/themes/typography/damilva_typography_extension.dart';
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
        contentPadding: const EdgeInsets.symmetric(vertical: 14),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colors.primaryLight),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colors.primary),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colors.primaryDark),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colors.primaryDark),
        ),
        disabledBorder: OutlineInputBorder(
          gapPadding: 20,
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        hintStyle: typography.text16w400.copyWith(color: colors.primaryLight),
      ),
    );
  }
}
