import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:ui';

bool useLargeLayout() {
  return kIsWeb || window.physicalSize.width > 1000;
}
