import 'dart:ui';

import 'package:damilva/presentation/themes/colors/damilva_colors.dart';

class DamilvaDefaultColors {
  static DamilvaColors get colors {
    return DamilvaColors(
      primary: const Color(0xFFEC3013),
      primaryDark: const Color(0xFFAE1800),
      primaryLight: const Color(0xFFFFF2EF),
      ink: const Color(0xFF201E1D),
      surface: const Color(0xFFEAE9E9),
      neutral100: Color(0xFFF8F4F4),
      white: const Color(0xFFFFFFFF),
    );
  }
}
