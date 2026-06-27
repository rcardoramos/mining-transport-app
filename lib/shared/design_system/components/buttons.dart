import 'package:flutter/material.dart';
import '../tokens/colors/design_colors.dart';
import '../tokens/typography/design_typography.dart';
import '../tokens/radius/design_radius.dart';
import '../tokens/spacing/design_spacing.dart';
import '../animations/design_animations.dart';

enum DesignButtonType { primary, secondary, outlined, text }

/// Botones corporativos altamente reutilizables con soporte de estados e interacciones.
class DesignButton extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;
  final DesignButtonType type;
  final bool isLoading;
  final IconData? icon;
  final bool fullWidth;

  const DesignButton.primary({
    super.key,
    required this.text,
    this.onTap,
    this.isLoading = false,
    this.icon,
    this.fullWidth = true,
  }) : type = DesignButtonType.primary;

  const DesignButton.secondary({
    super.key,
    required this.text,
    this.onTap,
    this.isLoading = false,
    this.icon,
    this.fullWidth = true,
  }) : type = DesignButtonType.secondary;

  const DesignButton.outlined({
    super.key,
    required this.text,
    this.onTap,
    this.isLoading = false,
    this.icon,
    this.fullWidth = true,
  }) : type = DesignButtonType.outlined;

  const DesignButton.text({
    super.key,
    required this.text,
    this.onTap,
    this.isLoading = false,
    this.icon,
    this.fullWidth = true,
  }) : type = DesignButtonType.text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    Color bg;
    Color fg;
    BorderSide borderSide = BorderSide.none;

    switch (type) {
      case DesignButtonType.primary:
        bg = isDark ? DesignColors.primaryDark : DesignColors.primaryLight;
        fg = Colors.white;
        break;
      case DesignButtonType.secondary:
        bg = isDark ? DesignColors.secondaryDark : DesignColors.secondaryLight;
        fg = Colors.white;
        break;
      case DesignButtonType.outlined:
        bg = Colors.transparent;
        fg = isDark ? DesignColors.primaryDark : DesignColors.primaryLight;
        borderSide = BorderSide(color: fg, width: 1.5);
        break;
      case DesignButtonType.text:
        bg = Colors.transparent;
        fg = isDark ? DesignColors.primaryDark : DesignColors.primaryLight;
        break;
    }

    if (onTap == null) {
      bg = isDark ? DesignColors.disabledDark : DesignColors.disabledLight;
      fg = isDark ? Colors.white30 : Colors.black26;
      borderSide = BorderSide.none;
    }

    Widget content = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (isLoading) ...[
          SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              valueColor: AlwaysStoppedAnimation<Color>(fg),
            ),
          ),
          DesignSpacing.spacerH12,
        ] else if (icon != null) ...[
          Icon(icon, size: 18, color: fg),
          DesignSpacing.spacerH8,
        ],
        Text(
          text,
          style: DesignTypography.labelLarge.copyWith(
            color: fg,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );

    Widget button = OutlinedButton(
      onPressed: (isLoading || onTap == null) ? null : () {},
      style: OutlinedButton.styleFrom(
        backgroundColor: bg,
        foregroundColor: fg,
        side: borderSide,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: DesignRadius.allMedium,
        ),
        elevation: 0,
      ),
      child: content,
    );

    if (fullWidth) {
      button = SizedBox(width: double.infinity, child: button);
    }

    return ButtonPressAnimation(
      onTap: (onTap == null || isLoading) ? null : onTap,
      child: button,
    );
  }
}

/// Botón con Icono personalizado y microinteracción de escala.
class DesignIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final Color? color;
  final double size;
  final String? tooltip;

  const DesignIconButton({
    super.key,
    required this.icon,
    this.onTap,
    this.color,
    this.size = 24,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final defaultColor = isDark ? DesignColors.textPrimaryDark : DesignColors.textPrimaryLight;

    return ButtonPressAnimation(
      onTap: onTap,
      child: IconButton(
        tooltip: tooltip,
        icon: Icon(icon, size: size),
        color: color ?? defaultColor,
        onPressed: onTap != null ? () {} : null,
      ),
    );
  }
}
