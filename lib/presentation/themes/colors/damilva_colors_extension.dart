import 'package:damilva/presentation/themes/colors/damilva_colors.dart';
import 'package:flutter/material.dart';

class DamilvaColorsExtension extends ThemeExtension<DamilvaColorsExtension> {
  DamilvaColorsExtension({
    required this.primary,
    required this.primaryDark,
    required this.primaryLight,
    required this.ink,
    required this.surface,
    required this.neutral100,
    required this.white,
  });

  final Color primary;
  final Color primaryDark;
  final Color primaryLight;
  final Color ink;
  final Color surface;
  final Color neutral100;
  final Color white;

  factory DamilvaColorsExtension.from(DamilvaColors colors) {
    return DamilvaColorsExtension(
      primary: colors.primary,
      primaryDark: colors.primaryDark,
      primaryLight: colors.primaryLight,
      ink: colors.ink,
      surface: colors.surface,
      neutral100: colors.neutral100,
      white: colors.white,
    );
  }

  @override
  DamilvaColorsExtension copyWith({
    Color? primary,
    Color? primaryDark,
    Color? primaryLight,
    Color? ink,
    Color? surface,
    Color? neutral100,
    Color? white,
  }) {
    return DamilvaColorsExtension(
      primary: primary ?? this.primary,
      primaryDark: primaryDark ?? this.primaryDark,
      primaryLight: primaryLight ?? this.primaryLight,
      ink: ink ?? this.ink,
      surface: surface ?? this.surface,
      neutral100: neutral100 ?? this.neutral100,
      white: white ?? this.white,
    );
  }

  @override
  DamilvaColorsExtension lerp(
    ThemeExtension<DamilvaColorsExtension>? other,
    double t,
  ) {
    if (other is! DamilvaColorsExtension) return this;
    return DamilvaColorsExtension(
      primary: Color.lerp(primary, other.primary, t) ?? primary,
      primaryDark: Color.lerp(primaryDark, other.primaryDark, t) ?? primaryDark,
      primaryLight:
          Color.lerp(primaryLight, other.primaryLight, t) ?? primaryLight,
      ink: Color.lerp(ink, other.ink, t) ?? ink,
      surface: Color.lerp(surface, other.surface, t) ?? surface,
      neutral100: Color.lerp(neutral100, other.neutral100, t) ?? neutral100,
      white: Color.lerp(white, other.white, t) ?? white,
    );
  }
}
