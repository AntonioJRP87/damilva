import 'package:damilva/core/utils/sizes.dart';
import 'package:flutter/widgets.dart';

extension SizesExtension on BuildContext {
  double get screenWidth => MediaQuery.sizeOf(this).width;

  DeviceType get deviceType => AppSizes.deviceTypeOf(screenWidth);
  double get responsiveMargin => AppSizes.marginOf(screenWidth);
  int get productGridColumns => AppSizes.productGridColumnsOf(screenWidth);
  bool get isFilterPanelFixed => AppSizes.isFilterPanelFixed(screenWidth);
  double get headerIconSize => AppSizes.headerIconSizeOf(screenWidth);
  double get buttonHeight => AppSizes.buttonHeightOf(screenWidth);
  double get buttonPaddingHorizontal =>
      AppSizes.buttonPaddingHorizontalOf(screenWidth);
  double get noticeBoxIconSize => AppSizes.noticeBoxIconSizeOf(screenWidth);

  bool get isMobile => deviceType == DeviceType.mobile;
  bool get isTablet => deviceType == DeviceType.tablet;
  bool get isDesktop => deviceType == DeviceType.desktop;
}
