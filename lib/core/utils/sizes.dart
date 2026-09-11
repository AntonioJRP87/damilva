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

  static const double buttonHeightMobile = 44;
  static const double buttonHeightDesktop = 48;
  static const double buttonPaddingHorizontalMobile = 15;
  static const double buttonPaddingHorizontalDesktop = 26;
  static const double buttonLabelLetterSpacing = 14 * 0.06;

  static const double textFieldHeight = 46;
  static const double textFieldPaddingVertical = 12;
  static const double textFieldPaddingHorizontal = 14;
  static const double textFieldBorderWidth = 1;
  static const double textFieldBorderWidthEmphasis = 2;
  static const double textFieldBorderAlpha = 0.4;
  static const double textFieldHintAlpha = 0.45;
  static const double textFieldLabelSpacing = 8;

  static const double productCardImageAspectRatio = 3 / 4;
  static const double productCardBadgePaddingHorizontal = 8;
  static const double productCardBadgePaddingVertical = 4;
  static const double productCardSoldOutVeilAlpha = 0.62;
  static const double productCardContentSpacing = 8;
  static const double productCardPreviousPriceAlpha = 0.5;

  static const double wishlistButtonSize = 32;
  static const double wishlistButtonMargin = 8;
  static const double wishlistButtonBackgroundAlpha = 0.92;
  static const double wishlistIconSize = 18;

  static const double statusBadgePaddingHorizontal = 8;
  static const double statusBadgePaddingVertical = 4;
  static const double statusBadgeBorderWidth = 2;
  static const double statusBadgeMutedAlpha = 0.55;

  static const double dataTableRowHeight = 44;
  static const double dataTableHeaderRuleWidth = 2;
  static const double dataTableRowDividerWidth = 1;
  static const double dataTableRowDividerAlpha = 0.22;
  static const double dataTableCellSpacing = 16;
  static const double dataTableActionColumnWidth = 96;
  static const double dataTableCardPadding = 16;
  static const double dataTableCardSpacing = 12;
  static const double dataTableCardRowSpacing = 8;

  static const double noticeBoxBorderWidth = 2;
  static const double noticeBoxIconSizeMobile = 18;
  static const double noticeBoxIconSizeDesktop = 20;
  static const double noticeBoxPadding = 16;
  static const double noticeBoxContentSpacing = 12;
  static const double noticeBoxTextSpacing = 4;

  static const double confirmationDialogPadding = 24;
  static const double confirmationDialogContentSpacing = 12;
  static const double confirmationDialogActionSpacing = 8;
  static const double confirmationDialogMaxWidth = 400;

  static const double homeHeroAspectRatioMobile = 16 / 10;
  static const double homeHeroAspectRatioTablet = 16 / 9;
  static const double homeHeroAspectRatioDesktop = 21 / 9;
  static const double homeHeroAutoplaySeconds = 6;
  static const double homeFeaturedCategoryAspectRatio = 4 / 5;
  static const double homeSectionSpacing = 32;
  static const double homeSectionTitleSpacing = 16;
  static const double homeGridSpacing = 16;
  static const double homeCarouselDotSize = 8;
  static const double homeCarouselDotSpacing = 6;
  static const double homeTrustBarPaddingVertical = 16;
  static const double homeProductCardTextBlockHeight = 84;

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

  static double homeHeroAspectRatioOf(double width) =>
      switch (deviceTypeOf(width)) {
        DeviceType.mobile => homeHeroAspectRatioMobile,
        DeviceType.tablet => homeHeroAspectRatioTablet,
        DeviceType.desktop => homeHeroAspectRatioDesktop,
      };

  static bool isFilterPanelFixed(double width) =>
      deviceTypeOf(width) == DeviceType.desktop;

  static double headerIconSizeOf(double width) =>
      deviceTypeOf(width) == DeviceType.desktop ? 20 : 24;

  static double buttonHeightOf(double width) =>
      deviceTypeOf(width) == DeviceType.desktop
      ? buttonHeightDesktop
      : buttonHeightMobile;

  static double buttonPaddingHorizontalOf(double width) =>
      deviceTypeOf(width) == DeviceType.desktop
      ? buttonPaddingHorizontalDesktop
      : buttonPaddingHorizontalMobile;

  static double noticeBoxIconSizeOf(double width) =>
      deviceTypeOf(width) == DeviceType.desktop
      ? noticeBoxIconSizeDesktop
      : noticeBoxIconSizeMobile;
}
