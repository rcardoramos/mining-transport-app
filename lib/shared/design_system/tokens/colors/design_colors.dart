import 'package:flutter/material.dart';

/// Design Tokens de Colores para temas Light y Dark corporativos.
class DesignColors {
  DesignColors._();

  // Paleta Light Mode
  static const Color primaryLight = Color(0xFF0F4C5C); // Teal Oscuro
  static const Color secondaryLight = Color(0xFFE36414); // Naranja de Seguridad Industrial
  static const Color successLight = Color(0xFF2D6A4F); // Verde Aprobado
  static const Color warningLight = Color(0xFFF5B041); // Amarillo Advertencia
  static const Color dangerLight = Color(0xFFC32F27); // Rojo Error
  static const Color infoLight = Color(0xFF2471A3); // Azul Informativo
  static const Color backgroundLight = Color(0xFFF8F9FA); // Fondo gris muy claro
  static const Color surfaceLight = Colors.white;
  static const Color borderLight = Color(0xFFE5E8E8); // Borde sutil
  static const Color disabledLight = Color(0xFFBDC3C7);
  static const Color textPrimaryLight = Color(0xFF2C3E50); // Texto principal oscuro
  static const Color textSecondaryLight = Color(0xFF7F8C8D); // Texto secundario gris
  static const Color dividerLight = Color(0xFFEBEDEF);
  static const Color overlayLight = Color(0x55000000);

  // Paleta Dark Mode
  static const Color primaryDark = Color(0xFF1A6B7E); // Teal más claro para contraste en negro
  static const Color secondaryDark = Color(0xFFF07B3F);
  static const Color successDark = Color(0xFF27AE60);
  static const Color warningDark = Color(0xFFF39C12);
  static const Color dangerDark = Color(0xFFE74C3C);
  static const Color infoDark = Color(0xFF2980B9);
  static const Color backgroundDark = Color(0xFF121212); // Fondo negro de sistema
  static const Color surfaceDark = Color(0xFF1E1E1E); // Superficie gris oscura
  static const Color borderDark = Color(0xFF2C3E50);
  static const Color disabledDark = Color(0xFF566573);
  static const Color textPrimaryDark = Color(0xFFF2F4F4); // Texto principal claro
  static const Color textSecondaryDark = Color(0xFF95A5A6); // Texto secundario gris claro
  static const Color dividerDark = Color(0xFF2A363B);
  static const Color overlayDark = Color(0x99000000);
}
