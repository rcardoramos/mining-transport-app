import 'package:flutter/material.dart';

/// Design Tokens de Sombras y Elevación muy sutiles estilo Apple / Uber.
class DesignElevation {
  DesignElevation._();

  static const List<BoxShadow> none = [];

  static const List<BoxShadow> level1 = [
    BoxShadow(
      color: Color(0x08000000),
      offset: Offset(0, 2),
      blurRadius: 4,
      spreadRadius: 0,
    ),
  ];

  static const List<BoxShadow> level2 = [
    BoxShadow(
      color: Color(0x0A000000),
      offset: Offset(0, 4),
      blurRadius: 12,
      spreadRadius: 0,
    ),
    BoxShadow(
      color: Color(0x05000000),
      offset: Offset(0, 2),
      blurRadius: 4,
      spreadRadius: -1,
    ),
  ];

  static const List<BoxShadow> level3 = [
    BoxShadow(
      color: Color(0x0D000000),
      offset: Offset(0, 8),
      blurRadius: 24,
      spreadRadius: -4,
    ),
    BoxShadow(
      color: Color(0x08000000),
      offset: Offset(0, 4),
      blurRadius: 8,
      spreadRadius: -2,
    ),
  ];

  static const List<BoxShadow> level4 = [
    BoxShadow(
      color: Color(0x14000000),
      offset: Offset(0, 16),
      blurRadius: 32,
      spreadRadius: -8,
    ),
    BoxShadow(
      color: Color(0x0D000000),
      offset: Offset(0, 8),
      blurRadius: 16,
      spreadRadius: -4,
    ),
  ];
}
