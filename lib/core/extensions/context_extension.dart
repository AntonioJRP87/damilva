import 'package:damilva/core/l10n/app_localizations.dart';
import 'package:damilva/core/themes/colors/damilva_colors_extension.dart';
import 'package:damilva/core/themes/typography/damilva_typography_extension.dart';
import 'package:flutter/material.dart';

extension BuildContextExtension on BuildContext {
  DamilvaColorsExtension get damilvaColors =>
      Theme.of(this).extension<DamilvaColorsExtension>()!;

  DamilvaTypographyExtension get damilvaTypography =>
      Theme.of(this).extension<DamilvaTypographyExtension>()!;

  AppLocalizations get localizations => AppLocalizations.of(this)!;

  void showSnackBar(SnackBar snackBar) =>
      ScaffoldMessenger.of(this).showSnackBar(snackBar);
}
