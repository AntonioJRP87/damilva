enum DeviceType { mobile, tablet, desktop }

abstract class AppBreakpoints {
  static const double tablet = 600;
  static const double desktop = 1024;
}

abstract class AppSizes {
  static const double maxContentWidth = 1280;
  static const double filterPanelWidth = 260;

  static const double iconSizeInButton = 14;
  static const double iconSizeInlineSmall = 16;
  static const double iconSizeInlineLarge = 18;

  static DeviceType deviceTypeOf(double width) => switch (width) {
    >= AppBreakpoints.desktop => DeviceType.desktop,
    >= AppBreakpoints.tablet => DeviceType.tablet,
    _ => DeviceType.mobile,
  };

  static double marginOf(double width) => switch (deviceTypeOf(width)) {
    DeviceType.mobile => 16,
    DeviceType.tablet => 24,
    DeviceType.desktop => 40,
  };

  static int productGridColumnsOf(double width) =>
      switch (deviceTypeOf(width)) {
        DeviceType.mobile => 2,
        DeviceType.tablet => 3,
        DeviceType.desktop => 4,
      };

  static bool isFilterPanelFixed(double width) =>
      deviceTypeOf(width) == DeviceType.desktop;

  static double headerIconSizeOf(double width) =>
      deviceTypeOf(width) == DeviceType.desktop ? 20 : 24;
}
