import 'package:flutter/material.dart';

/// Design Tokens de Espaciado basados en múltiplos de 4.
class DesignSpacing {
  DesignSpacing._();

  static const double xs = 4.0;
  static const double s = 8.0;
  static const double sm = 12.0;
  static const double m = 16.0;
  static const double ml = 20.0;
  static const double l = 24.0;
  static const double xl = 32.0;
  static const double xxl = 40.0;
  static const double xxxl = 48.0;
  static const double huge = 64.0;

  // EdgeInsets listos para usar
  static const EdgeInsets allXs = EdgeInsets.all(xs);
  static const EdgeInsets allS = EdgeInsets.all(s);
  static const EdgeInsets allSm = EdgeInsets.all(sm);
  static const EdgeInsets allM = EdgeInsets.all(m);
  static const EdgeInsets allL = EdgeInsets.all(l);
  static const EdgeInsets allXl = EdgeInsets.all(xl);

  static const EdgeInsets symmetricHXs = EdgeInsets.symmetric(horizontal: xs);
  static const EdgeInsets symmetricHS = EdgeInsets.symmetric(horizontal: s);
  static const EdgeInsets symmetricHSm = EdgeInsets.symmetric(horizontal: sm);
  static const EdgeInsets symmetricHM = EdgeInsets.symmetric(horizontal: m);
  static const EdgeInsets symmetricHL = EdgeInsets.symmetric(horizontal: l);
  static const EdgeInsets symmetricHXl = EdgeInsets.symmetric(horizontal: xl);

  static const EdgeInsets symmetricVXs = EdgeInsets.symmetric(vertical: xs);
  static const EdgeInsets symmetricVS = EdgeInsets.symmetric(vertical: s);
  static const EdgeInsets symmetricVSm = EdgeInsets.symmetric(vertical: sm);
  static const EdgeInsets symmetricVM = EdgeInsets.symmetric(vertical: m);
  static const EdgeInsets symmetricVL = EdgeInsets.symmetric(vertical: l);
  static const EdgeInsets symmetricVXl = EdgeInsets.symmetric(vertical: xl);

  // Espaciadores horizontales (SizedBox)
  static const SizedBox spacerH4 = SizedBox(width: xs);
  static const SizedBox spacerH8 = SizedBox(width: s);
  static const SizedBox spacerH12 = SizedBox(width: sm);
  static const SizedBox spacerH16 = SizedBox(width: m);
  static const SizedBox spacerH20 = SizedBox(width: ml);
  static const SizedBox spacerH24 = SizedBox(width: l);
  static const SizedBox spacerH32 = SizedBox(width: xl);

  // Espaciadores verticales (SizedBox)
  static const SizedBox spacerV4 = SizedBox(height: xs);
  static const SizedBox spacerV8 = SizedBox(height: s);
  static const SizedBox spacerV12 = SizedBox(height: sm);
  static const SizedBox spacerV16 = SizedBox(height: m);
  static const SizedBox spacerV20 = SizedBox(height: ml);
  static const SizedBox spacerV24 = SizedBox(height: l);
  static const SizedBox spacerV32 = SizedBox(height: xl);
  static const SizedBox spacerV40 = SizedBox(height: xxl);
  static const SizedBox spacerV48 = SizedBox(height: xxxl);
  static const SizedBox spacerV64 = SizedBox(height: huge);
}
