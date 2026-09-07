import 'package:flutter/cupertino.dart';

class DamilvaTypography {
  factory DamilvaTypography.create({
    required String fontFamily,
    String? package,
    double scale = 1.0,
  }) {
    TextStyle style(double size, FontWeight weight) {
      return TextStyle(
        package: package,
        fontFamily: fontFamily,
        fontSize: size * scale,
        fontWeight: weight,
        overflow: TextOverflow.ellipsis,
      );
    }

    return DamilvaTypography(
      text64w800: style(64, FontWeight.w800),
      text48w800: style(48, FontWeight.w800),
      text40w800: style(40, FontWeight.w800),
      text32w800: style(32, FontWeight.w800),
      text26w800: style(26, FontWeight.w800),
      text22w800: style(22, FontWeight.w800),
      text20w800: style(20, FontWeight.w800),
      text18w800: style(18, FontWeight.w800),
      text16w800: style(16, FontWeight.w800),
      text15w800: style(15, FontWeight.w800),
      text14w800: style(14, FontWeight.w800),
      text13w800: style(13, FontWeight.w800),
      text12w800caps: style(12, FontWeight.w800),
      text11w800caps: style(11, FontWeight.w800),
      text10w800caps: style(10, FontWeight.w800),
      text14w600: style(14, FontWeight.w600),
      text13w600: style(13, FontWeight.w600),
      text16w400: style(16, FontWeight.w400),
      text15w400: style(15, FontWeight.w400),
      text14w400: style(14, FontWeight.w400),
      text13w400: style(13, FontWeight.w400),
      text12w400: style(12, FontWeight.w400),
      text11w400: style(11, FontWeight.w400),
    );
  }

  DamilvaTypography({
    required this.text64w800,
    required this.text48w800,
    required this.text40w800,
    required this.text32w800,
    required this.text26w800,
    required this.text22w800,
    required this.text20w800,
    required this.text18w800,
    required this.text16w800,
    required this.text15w800,
    required this.text14w800,
    required this.text13w800,
    required this.text12w800caps,
    required this.text11w800caps,
    required this.text10w800caps,
    required this.text14w600,
    required this.text13w600,
    required this.text16w400,
    required this.text15w400,
    required this.text14w400,
    required this.text13w400,
    required this.text12w400,
    required this.text11w400,
  });

  // Display — headlines, tracking -0.04em
  final TextStyle text64w800; // desktop home hero
  final TextStyle text48w800; // 404 headline, "Thank you for your order"
  final TextStyle text40w800; // desktop screen title
  final TextStyle text32w800; // section title, mobile hero

  // Titles — tracking -0.02em
  final TextStyle text26w800; // mobile screen title, desktop subtitle
  final TextStyle text22w800; // mobile subtitle, cart total
  final TextStyle text20w800; // featured price on product card, panel figures

  // Strong data
  final TextStyle text18w800; // total, order number
  final TextStyle text16w800; // garment name in lists and tables
  final TextStyle text15w800; // card price, admin table name
  final TextStyle text14w800; // button text, mobile price
  final TextStyle text13w800; // mobile button, table header, nav

  // Small caps — UPPERCASE, tracking +0.10 to +0.20em
  final TextStyle text12w800caps; // nav, button, and step labels
  final TextStyle text11w800caps; // section kicker, column headers
  final TextStyle text10w800caps; // labels over photos, "New", "Offer"

  // Alerts
  final TextStyle text14w600; // credential error, last units
  final TextStyle text13w600; // same on mobile

  // Body
  final TextStyle text16w400; // highlighted paragraph (Bizum instruction)
  final TextStyle text15w400; // desktop paragraph
  final TextStyle text14w400; // base body text, form fields
  final TextStyle text13w400; // mobile body text, secondary text
  final TextStyle text12w400; // metadata, field label, footer
  final TextStyle text11w400; // mobile footer, footnote

  DamilvaTypography copyWith({
    TextStyle? text64w800,
    TextStyle? text48w800,
    TextStyle? text40w800,
    TextStyle? text32w800,
    TextStyle? text26w800,
    TextStyle? text22w800,
    TextStyle? text20w800,
    TextStyle? text18w800,
    TextStyle? text16w800,
    TextStyle? text15w800,
    TextStyle? text14w800,
    TextStyle? text13w800,
    TextStyle? text12w800caps,
    TextStyle? text11w800caps,
    TextStyle? text10w800caps,
    TextStyle? text14w600,
    TextStyle? text13w600,
    TextStyle? text16w400,
    TextStyle? text15w400,
    TextStyle? text14w400,
    TextStyle? text13w400,
    TextStyle? text12w400,
    TextStyle? text11w400,
  }) {
    return DamilvaTypography(
      text64w800: text64w800 ?? this.text64w800,
      text48w800: text48w800 ?? this.text48w800,
      text40w800: text40w800 ?? this.text40w800,
      text32w800: text32w800 ?? this.text32w800,
      text26w800: text26w800 ?? this.text26w800,
      text22w800: text22w800 ?? this.text22w800,
      text20w800: text20w800 ?? this.text20w800,
      text18w800: text18w800 ?? this.text18w800,
      text16w800: text16w800 ?? this.text16w800,
      text15w800: text15w800 ?? this.text15w800,
      text14w800: text14w800 ?? this.text14w800,
      text13w800: text13w800 ?? this.text13w800,
      text12w800caps: text12w800caps ?? this.text12w800caps,
      text11w800caps: text11w800caps ?? this.text11w800caps,
      text10w800caps: text10w800caps ?? this.text10w800caps,
      text14w600: text14w600 ?? this.text14w600,
      text13w600: text13w600 ?? this.text13w600,
      text16w400: text16w400 ?? this.text16w400,
      text15w400: text15w400 ?? this.text15w400,
      text14w400: text14w400 ?? this.text14w400,
      text13w400: text13w400 ?? this.text13w400,
      text12w400: text12w400 ?? this.text12w400,
      text11w400: text11w400 ?? this.text11w400,
    );
  }

  DamilvaTypography lerp(DamilvaTypography other, double t) {
    return DamilvaTypography(
      text64w800: TextStyle.lerp(text64w800, other.text64w800, t)!,
      text48w800: TextStyle.lerp(text48w800, other.text48w800, t)!,
      text40w800: TextStyle.lerp(text40w800, other.text40w800, t)!,
      text32w800: TextStyle.lerp(text32w800, other.text32w800, t)!,
      text26w800: TextStyle.lerp(text26w800, other.text26w800, t)!,
      text22w800: TextStyle.lerp(text22w800, other.text22w800, t)!,
      text20w800: TextStyle.lerp(text20w800, other.text20w800, t)!,
      text18w800: TextStyle.lerp(text18w800, other.text18w800, t)!,
      text16w800: TextStyle.lerp(text16w800, other.text16w800, t)!,
      text15w800: TextStyle.lerp(text15w800, other.text15w800, t)!,
      text14w800: TextStyle.lerp(text14w800, other.text14w800, t)!,
      text13w800: TextStyle.lerp(text13w800, other.text13w800, t)!,
      text12w800caps: TextStyle.lerp(text12w800caps, other.text12w800caps, t)!,
      text11w800caps: TextStyle.lerp(text11w800caps, other.text11w800caps, t)!,
      text10w800caps: TextStyle.lerp(text10w800caps, other.text10w800caps, t)!,
      text14w600: TextStyle.lerp(text14w600, other.text14w600, t)!,
      text13w600: TextStyle.lerp(text13w600, other.text13w600, t)!,
      text16w400: TextStyle.lerp(text16w400, other.text16w400, t)!,
      text15w400: TextStyle.lerp(text15w400, other.text15w400, t)!,
      text14w400: TextStyle.lerp(text14w400, other.text14w400, t)!,
      text13w400: TextStyle.lerp(text13w400, other.text13w400, t)!,
      text12w400: TextStyle.lerp(text12w400, other.text12w400, t)!,
      text11w400: TextStyle.lerp(text11w400, other.text11w400, t)!,
    );
  }
}
