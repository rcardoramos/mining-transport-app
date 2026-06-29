import 'package:flutter/material.dart';
import '../tokens/colors/design_colors.dart';
import '../tokens/typography/design_typography.dart';
import '../tokens/radius/design_radius.dart';

/// Extensiones de Tema personalizadas para inyectar propiedades visuales
/// propias del corporativo que Material Design no expone nativamente.
class DesignThemeExtension extends ThemeExtension<DesignThemeExtension> {
  final Color textPrimary;
  final Color textSecondary;
  final Color border;
  final Color divider;
  final Color success;
  final Color warning;
  final Color danger;
  final Color info;

  const DesignThemeExtension({
    required this.textPrimary,
    required this.textSecondary,
    required this.border,
    required this.divider,
    required this.success,
    required this.warning,
    required this.danger,
    required this.info,
  });

  @override
  ThemeExtension<DesignThemeExtension> copyWith({
    Color? textPrimary,
    Color? textSecondary,
    Color? border,
    Color? divider,
    Color? success,
    Color? warning,
    Color? danger,
    Color? info,
  }) {
    return DesignThemeExtension(
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      border: border ?? this.border,
      divider: divider ?? this.divider,
      success: success ?? this.success,
      warning: warning ?? this.warning,
      danger: danger ?? this.danger,
      info: info ?? this.info,
    );
  }

  @override
  ThemeExtension<DesignThemeExtension> lerp(
    covariant ThemeExtension<DesignThemeExtension>? other,
    double t,
  ) {
    if (other is! DesignThemeExtension) {
      return this;
    }
    return DesignThemeExtension(
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      border: Color.lerp(border, other.border, t)!,
      divider: Color.lerp(divider, other.divider, t)!,
      success: Color.lerp(success, other.success, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      danger: Color.lerp(danger, other.danger, t)!,
      info: Color.lerp(info, other.info, t)!,
    );
  }
}

/// Configurador central de Temas Corporativos para APP Buses (Light y Dark).
class AppDesignTheme {
  AppDesignTheme._();

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: DesignColors.primaryLight,
      scaffoldBackgroundColor: DesignColors.backgroundLight,
      colorScheme: const ColorScheme.light(
        primary: DesignColors.primaryLight,
        secondary: DesignColors.secondaryLight,
        error: DesignColors.dangerLight,
        surface: DesignColors.surfaceLight,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onError: Colors.white,
        onSurface: DesignColors.textPrimaryLight,
      ),
      dividerColor: DesignColors.dividerLight,
      textTheme: TextTheme(
        displayLarge: DesignTypography.display,
        headlineLarge: DesignTypography.headline,
        titleLarge: DesignTypography.titleLarge,
        titleMedium: DesignTypography.titleMedium,
        bodyLarge: DesignTypography.bodyLarge,
        bodyMedium: DesignTypography.bodyMedium,
        labelLarge: DesignTypography.labelLarge,
        labelMedium: DesignTypography.labelMedium,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: DesignColors.surfaceLight,
        elevation: 0,
        centerTitle: false,
      ),
      cardTheme: CardThemeData(
        color: DesignColors.surfaceLight,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: DesignRadius.allCard,
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: DesignColors.surfaceLight,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: DesignRadius.allCard,
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      extensions: const [
        DesignThemeExtension(
          textPrimary: DesignColors.textPrimaryLight,
          textSecondary: DesignColors.textSecondaryLight,
          border: DesignColors.borderLight,
          divider: DesignColors.dividerLight,
          success: DesignColors.successLight,
          warning: DesignColors.warningLight,
          danger: DesignColors.dangerLight,
          info: DesignColors.infoLight,
        ),
      ],
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: DesignColors.primaryDark,
      scaffoldBackgroundColor: DesignColors.backgroundDark,
      colorScheme: const ColorScheme.dark(
        primary: DesignColors.primaryDark,
        secondary: DesignColors.secondaryDark,
        error: DesignColors.dangerDark,
        surface: DesignColors.surfaceDark,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onError: Colors.white,
        onSurface: DesignColors.textPrimaryDark,
      ),
      dividerColor: DesignColors.dividerDark,
      textTheme: TextTheme(
        displayLarge: DesignTypography.display,
        headlineLarge: DesignTypography.headline,
        titleLarge: DesignTypography.titleLarge,
        titleMedium: DesignTypography.titleMedium,
        bodyLarge: DesignTypography.bodyLarge,
        bodyMedium: DesignTypography.bodyMedium,
        labelLarge: DesignTypography.labelLarge,
        labelMedium: DesignTypography.labelMedium,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: DesignColors.surfaceDark,
        elevation: 0,
        centerTitle: false,
      ),
      cardTheme: CardThemeData(
        color: DesignColors.surfaceDark,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: DesignRadius.allCard,
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: DesignColors.surfaceDark,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: DesignRadius.allCard,
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      extensions: const [
        DesignThemeExtension(
          textPrimary: DesignColors.textPrimaryDark,
          textSecondary: DesignColors.textSecondaryDark,
          border: DesignColors.borderDark,
          divider: DesignColors.dividerDark,
          success: DesignColors.successDark,
          warning: DesignColors.warningDark,
          danger: DesignColors.dangerDark,
          info: DesignColors.infoDark,
        ),
      ],
    );
  }
}
