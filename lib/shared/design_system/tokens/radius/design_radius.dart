import 'package:flutter/material.dart';

/// Design Tokens de Radios de Borde (Border Radius).
class DesignRadius {
  DesignRadius._();

  static const double small = 4.0;
  static const double medium = 8.0;
  static const double large = 12.0;
  static const double extraLarge = 16.0;
  static const double circular = 999.0;

  static final BorderRadius allSmall = BorderRadius.circular(small);
  static final BorderRadius allMedium = BorderRadius.circular(medium);
  static final BorderRadius allLarge = BorderRadius.circular(large);
  static final BorderRadius allExtraLarge = BorderRadius.circular(extraLarge);
  static final BorderRadius allCircular = BorderRadius.circular(circular);

  static final Radius radiusSmall = Radius.circular(small);
  static final Radius radiusMedium = Radius.circular(medium);
  static final Radius radiusLarge = Radius.circular(large);
  static final Radius radiusExtraLarge = Radius.circular(extraLarge);
  static final Radius radiusCircular = Radius.circular(circular);
}
