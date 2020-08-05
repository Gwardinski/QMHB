class AppSize {
  double spacingSm = 8.0;
  double spacingMd = 16.0;
  double spacingLg = 32.0;
  double rSpacingSm = 8.0;
  double rSpacingMd = 16.0;
  double rSpacingLg = 32.0;

  // for large layouts only
  double rSpacingXs = 0.0;
  // does not change
  double spacingXl = 64.0;

  updateSize(useLargeLayout) {
    if (useLargeLayout) {
      rSpacingXs = 8.0;
      rSpacingSm = 16.0;
      rSpacingMd = 32.0;
      rSpacingLg = 64.0;
    } else {
      rSpacingXs = 0;
      rSpacingSm = spacingSm;
      rSpacingMd = spacingMd;
      rSpacingLg = spacingLg;
    }
  }
}
