class AppSize {
  bool isLarge = false;
  double spacingSm = 8.0;
  double spacingMd = 16.0;
  double spacingLg = 32.0;
  double rSpacingSm = 8.0;
  double rSpacingMd = 16.0;
  double rSpacingLg = 32.0;

  // for large layouts only
  double lOnly8 = 0.0;
  double lOnly16 = 0.0;
  double rSpacingPageTop = 16;
  // does not change
  double spacingXl = 64.0;

  double borderRadius = 16.0;

  updateSize(useLargeLayout) {
    if (useLargeLayout) {
      isLarge = true;
      lOnly8 = 8.0;
      lOnly16 = 16.0;
      rSpacingSm = 16.0;
      rSpacingMd = 32.0;
      rSpacingLg = 64.0;
      rSpacingPageTop = 128.0;
    } else {
      isLarge = false;
      lOnly8 = 0;
      lOnly16 = 0;
      rSpacingSm = spacingSm;
      rSpacingMd = spacingMd;
      rSpacingLg = spacingLg;
      rSpacingPageTop = 16;
    }
  }
}
