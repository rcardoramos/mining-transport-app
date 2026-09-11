import 'package:flutter/material.dart';

/// Layout helpers for Android phones (no tablet breakpoints).
class PhoneLayout {
  PhoneLayout._();

  static const double compactWidth = 360;

  static double widthOf(BuildContext context) =>
      MediaQuery.sizeOf(context).width;

  static double heightOf(BuildContext context) =>
      MediaQuery.sizeOf(context).height;

  static bool isCompact(BuildContext context) =>
      widthOf(context) < compactWidth;

  static double horizontalGutter(BuildContext context) =>
      isCompact(context) ? 12.0 : 16.0;

  static double heroHeight(BuildContext context) {
    final h = heightOf(context);
    return (h * 0.28).clamp(150.0, 260.0);
  }
}
