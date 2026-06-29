import 'package:flutter/material.dart';

/// Design Tokens de Sombras y Elevación muy sutiles estilo Apple / Uber.
class DesignElevation {
  DesignElevation._();

  static const List<BoxShadow> none = [];

  static const List<BoxShadow> level1 = [
    BoxShadow(
      color: Color(0x04000000), // 2.5% opacity
      offset: Offset(0, 2),
      blurRadius: 6,
      spreadRadius: 0,
    ),
  ];

  static const List<BoxShadow> level2 = [
    BoxShadow(
      color: Color(0x05000000), // 3.1% opacity
      offset: Offset(0, 6),
      blurRadius: 16,
      spreadRadius: 0,
    ),
    BoxShadow(
      color: Color(0x03000000), // 1.8% opacity
      offset: Offset(0, 2),
      blurRadius: 6,
      spreadRadius: -1,
    ),
  ];

  static const List<BoxShadow> level3 = [
    BoxShadow(
      color: Color(0x08000000), // 5% opacity
      offset: Offset(0, 12),
      blurRadius: 28,
      spreadRadius: -4,
    ),
    BoxShadow(
      color: Color(0x04000000), // 2.5% opacity
      offset: Offset(0, 6),
      blurRadius: 10,
      spreadRadius: -2,
    ),
  ];

  static const List<BoxShadow> level4 = [
    BoxShadow(
      color: Color(0x0C000000), // 7.5% opacity
      offset: Offset(0, 20),
      blurRadius: 40,
      spreadRadius: -8,
    ),
    BoxShadow(
      color: Color(0x06000000), // 3.75% opacity
      offset: Offset(0, 10),
      blurRadius: 20,
      spreadRadius: -4,
    ),
  ];
}
