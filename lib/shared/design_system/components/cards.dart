import 'package:flutter/material.dart';
import '../tokens/colors/design_colors.dart';
import '../tokens/radius/design_radius.dart';
import '../tokens/spacing/design_spacing.dart';
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
    List<BoxShadow> shadow = DesignElevation.none;
    Border border = Border.all(
      color: isDark ? DesignColors.borderDark : DesignColors.borderLight,
      width: 1.2,
    );

    switch (type) {
      case DesignCardType.basic:
        break;
      case DesignCardType.elevated:
        shadow = DesignElevation.level2;
        border = Border.all(
          color: isDark ? Colors.white.withOpacity(0.03) : Colors.black.withOpacity(0.02),
          width: 1,
        );
        break;
      case DesignCardType.info:
        bg = isDark
            ? DesignColors.primaryDark.withOpacity(0.08)
            : DesignColors.primaryLight.withOpacity(0.05);
        border = Border.all(
          color: isDark
              ? DesignColors.primaryDark.withOpacity(0.25)
              : DesignColors.primaryLight.withOpacity(0.2),
          width: 1.2,
        );
        break;
      case DesignCardType.status:
        if (statusColor != null) {
          border = Border.all(
            color: statusColor!.withOpacity(0.45),
            width: 1.5,
          );
          bg = isDark
              ? statusColor!.withOpacity(0.07)
              : statusColor!.withOpacity(0.03);
        }
        break;
    }

    Widget cardBody = Container(
      padding: padding ?? DesignSpacing.allM,
      decoration: BoxDecoration(
        color: bg,
        border: border,
        borderRadius: DesignRadius.allLarge,
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
          borderRadius: DesignRadius.allLarge,
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: DesignRadius.allLarge,
          child: cardBody,
        ),
      );
    }

    return cardBody;
  }
}
