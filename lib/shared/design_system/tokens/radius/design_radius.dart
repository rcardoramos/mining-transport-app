import 'package:flutter/material.dart';

/// Design Tokens de Radios de Borde (Border Radius).
class DesignRadius {
  DesignRadius._();

  static const double small = 4.0;
  static const double medium = 8.0;
  static const double input = 18.0;
  static const double image = 20.0;
  static const double card = 24.0;
  static const double button = 24.0;
  static const double bottomNav = 30.0;
  static const double large = 24.0; // Cards y Botones
  static const double extraLarge = 32.0;
  static const double circular = 999.0;

  static final BorderRadius allSmall = BorderRadius.circular(small);
  static final BorderRadius allMedium = BorderRadius.circular(medium);
  static final BorderRadius allInput = BorderRadius.circular(input);
  static final BorderRadius allImage = BorderRadius.circular(image);
  static final BorderRadius allCard = BorderRadius.circular(card);
  static final BorderRadius allButton = BorderRadius.circular(button);
  static final BorderRadius allBottomNav = BorderRadius.circular(bottomNav);
  static final BorderRadius allLarge = BorderRadius.circular(large);
  static final BorderRadius allExtraLarge = BorderRadius.circular(extraLarge);
  static final BorderRadius allCircular = BorderRadius.circular(circular);

  static final Radius radiusSmall = Radius.circular(small);
  static final Radius radiusMedium = Radius.circular(medium);
  static final Radius radiusInput = Radius.circular(input);
  static final Radius radiusImage = Radius.circular(image);
  static final Radius radiusCard = Radius.circular(card);
  static final Radius radiusButton = Radius.circular(button);
  static final Radius radiusBottomNav = Radius.circular(bottomNav);
  static final Radius radiusLarge = Radius.circular(large);
  static final Radius radiusExtraLarge = Radius.circular(extraLarge);
  static final Radius radiusCircular = Radius.circular(circular);
}
