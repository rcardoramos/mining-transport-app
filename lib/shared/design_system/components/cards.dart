import 'package:flutter/material.dart';
import '../tokens/colors/design_colors.dart';
import '../tokens/radius/design_radius.dart';
import '../tokens/elevation/design_elevation.dart';

enum DesignCardType { basic, elevated, info, status }

/// Tarjetas corporativas con soporte para bordes, sombras, estatus e información.
class DesignCard extends StatelessWidget {
  final Widget child;
  final DesignCardType type;
  final VoidCallback? onTap;
  final Color? statusColor;
  final EdgeInsetsGeometry? padding;

  const DesignCard.basic({
    super.key,
    required this.child,
    this.onTap,
    this.padding,
  })  : type = DesignCardType.basic,
        statusColor = null;

  const DesignCard.elevated({
    super.key,
    required this.child,
    this.onTap,
    this.padding,
  })  : type = DesignCardType.elevated,
        statusColor = null;

  const DesignCard.info({
    super.key,
    required this.child,
    this.onTap,
    this.padding,
  })  : type = DesignCardType.info,
        statusColor = null;

  const DesignCard.status({
    super.key,
    required this.child,
    required this.statusColor,
    this.onTap,
    this.padding,
  }) : type = DesignCardType.status;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    Color bg = isDark ? DesignColors.surfaceDark : DesignColors.surfaceLight;
    List<BoxShadow> shadow = DesignElevation.level2; // Hacemos que floten por defecto
    BoxBorder? border;

    switch (type) {
      case DesignCardType.basic:
        break;
      case DesignCardType.elevated:
        shadow = DesignElevation.level3; // Más flotante aún
        break;
      case DesignCardType.info:
        bg = isDark
            ? DesignColors.primaryDark.withOpacity(0.06)
            : DesignColors.primaryLight.withOpacity(0.04);
        break;
      case DesignCardType.status:
        if (statusColor != null) {
          bg = isDark
              ? statusColor!.withOpacity(0.05)
              : statusColor!.withOpacity(0.03);
        }
        break;
    }

    Widget cardBody = Container(
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: BoxDecoration(
        color: bg,
        border: border,
        borderRadius: DesignRadius.allCard,
        boxShadow: shadow,
      ),
      child: child,
    );

    if (onTap != null) {
      return Card(
        margin: EdgeInsets.zero,
        elevation: 0,
        color: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: DesignRadius.allCard,
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: DesignRadius.allCard,
          child: cardBody,
        ),
      );
    }

    return cardBody;
  }
}
