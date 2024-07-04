import 'package:flutter/material.dart';

class Responsive {
  final BuildContext context;

  Responsive(this.context);

  double get width => MediaQuery.of(context).size.width;
  double get height => MediaQuery.of(context).size.height;
  bool get isTablet => width > 600;

  double dynamicWidth(double value) => width * value;
  double dynamicHeight(double value) => height * value;

  double get smallPadding => isTablet ? 16.0 : 8.0;
  double get largePadding => isTablet ? 32.0 : 16.0;
  double get smallFontSize => isTablet ? 18.0 : 14.0;
  double get largeFontSize => isTablet ? 24.0 : 18.0;
  double get largestFontSize => isTablet ? 34.0 : 28.0;
}
