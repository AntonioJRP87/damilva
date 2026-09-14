import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

enum AppIcon {
  search,
  chevronLeft,
  chevronRight,
  chevronDown,
  shoppingBag,
  user,
  x,
  menu,
  wifiOff,
  circleAlert,
  heart,
}

extension on AppIcon {
  String get _assetName => switch (this) {
    AppIcon.search => 'search',
    AppIcon.chevronLeft => 'chevron-left',
    AppIcon.chevronRight => 'chevron-right',
    AppIcon.chevronDown => 'chevron-down',
    AppIcon.shoppingBag => 'shopping-bag',
    AppIcon.user => 'user',
    AppIcon.x => 'x',
    AppIcon.menu => 'menu',
    AppIcon.wifiOff => 'wifi-off',
    AppIcon.circleAlert => 'circle-alert',
    AppIcon.heart => 'heart',
  };
}

class CustomIcon extends StatelessWidget {
  const CustomIcon(this.icon, {super.key, this.size = 24, required this.color});

  final AppIcon icon;
  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/icons/lucide/${icon._assetName}.svg',
      width: size,
      height: size,
      colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
    );
  }
}
