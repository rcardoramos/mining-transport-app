import 'package:flutter/material.dart';
import '../tokens/colors/design_colors.dart';
import '../tokens/radius/design_radius.dart';
import '../tokens/spacing/design_spacing.dart';
import '../tokens/typography/design_typography.dart';
import '../animations/design_animations.dart';

/// Chip corporativo redondeado y estilizado.
class DesignChip extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback? onDelete;
  final bool selected;

  const DesignChip({
    super.key,
    required this.label,
    this.icon,
    this.onDelete,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    Color bg;
    Color fg;

    if (selected) {
      bg = isDark ? DesignColors.primaryDark : DesignColors.primaryLight;
      fg = Colors.white;
    } else {
      bg = isDark ? DesignColors.surfaceDark : Colors.grey.shade100;
      fg = isDark ? DesignColors.textSecondaryDark : DesignColors.textSecondaryLight;
    }

    return Chip(
      label: Text(
        label,
        style: DesignTypography.labelMedium.copyWith(color: fg),
      ),
      avatar: icon != null ? Icon(icon, size: 14, color: fg) : null,
      onDeleted: onDelete,
      deleteIconColor: fg.withOpacity(0.6),
      backgroundColor: bg,
      shape: RoundedRectangleBorder(
        borderRadius: DesignRadius.allCircular,
        side: BorderSide(
          color: isDark ? DesignColors.borderDark : DesignColors.borderLight,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    );
  }
}

/// Placa / Insignia (Badge) para estatus.
class DesignBadge extends StatelessWidget {
  final String label;
  final Color color;

  const DesignBadge({
    super.key,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: DesignRadius.allCircular,
        border: Border.all(color: color.withOpacity(0.3), width: 1.2),
      ),
      child: Text(
        label,
        style: DesignTypography.caption.copyWith(
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

/// Control de Notificaciones Snackbars corporativas y contextuales.
class DesignSnackbar {
  DesignSnackbar._();

  static void showSuccess(BuildContext context, String message) {
    _show(context, message, DesignColors.successLight, Icons.check_circle_rounded);
  }

  static void showError(BuildContext context, String message) {
    _show(context, message, DesignColors.dangerLight, Icons.error_rounded);
  }

  static void showInfo(BuildContext context, String message) {
    _show(context, message, DesignColors.infoLight, Icons.info_rounded);
  }

  static void showWarning(BuildContext context, String message) {
    _show(context, message, DesignColors.warningLight, Icons.warning_rounded);
  }

  static void _show(BuildContext context, String message, Color color, IconData icon) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: Colors.white, size: 20),
            DesignSpacing.spacerH12,
            Expanded(
              child: Text(
                message,
                style: DesignTypography.bodyMedium.copyWith(color: Colors.white),
              ),
            ),
          ],
        ),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: DesignRadius.allMedium,
        ),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}

/// Cuadro de Diálogo (Dialog) de confirmación/alerta corporativo.
class DesignDialog extends StatelessWidget {
  final String title;
  final String content;
  final String confirmLabel;
  final String? cancelLabel;
  final VoidCallback onConfirm;
  final VoidCallback? onCancel;

  const DesignDialog({
    super.key,
    required this.title,
    required this.content,
    required this.confirmLabel,
    required this.onConfirm,
    this.cancelLabel,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return AlertDialog(
      title: Text(
        title,
        style: DesignTypography.titleLarge.copyWith(
          color: isDark ? DesignColors.textPrimaryDark : DesignColors.textPrimaryLight,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Text(
        content,
        style: DesignTypography.bodyMedium.copyWith(
          color: isDark ? DesignColors.textSecondaryDark : DesignColors.textSecondaryLight,
        ),
      ),
      backgroundColor: isDark ? DesignColors.surfaceDark : DesignColors.surfaceLight,
      shape: RoundedRectangleBorder(borderRadius: DesignRadius.allCard),
      actionsPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      actions: [
        if (cancelLabel != null)
          TextButton(
            onPressed: () {
              Navigator.pop(context, false);
              if (onCancel != null) onCancel!();
            },
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              shape: RoundedRectangleBorder(borderRadius: DesignRadius.allButton),
            ),
            child: Text(
              cancelLabel!,
              style: DesignTypography.labelLarge.copyWith(
                color: isDark ? DesignColors.textSecondaryDark : DesignColors.textSecondaryLight,
              ),
            ),
          ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context, true);
            onConfirm();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: isDark ? DesignColors.primaryDark : DesignColors.primaryLight,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: DesignRadius.allButton),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            elevation: 0,
          ),
          child: Text(
            confirmLabel,
            style: DesignTypography.labelLarge.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}

/// Hoja Inferior (Bottom Sheet) modular.
class DesignBottomSheet extends StatelessWidget {
  final String title;
  final Widget child;

  const DesignBottomSheet({
    super.key,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? DesignColors.surfaceDark : DesignColors.surfaceLight,
        borderRadius: BorderRadius.vertical(top: DesignRadius.radiusLarge),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DesignSpacing.spacerV12,
          // Tirador de arrastre (drag handle)
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: isDark ? Colors.white24 : Colors.black12,
              borderRadius: DesignRadius.allCircular,
            ),
          ),
          DesignSpacing.spacerV16,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: DesignTypography.titleMedium.copyWith(
                      color: isDark ? DesignColors.textPrimaryDark : DesignColors.textPrimaryLight,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          Divider(
            height: 1,
            thickness: 1,
            color: isDark ? const Color(0xFF2E2E38) : const Color(0xFFE5E7EB),
          ),
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: child,
            ),
          ),
          DesignSpacing.spacerV24,
        ],
      ),
    );
  }
}

/// Capa de Carga bloqueante que inhabilita las interacciones sobre la interfaz.
class DesignLoadingOverlay extends StatelessWidget {
  final bool isLoading;
  final Widget child;

  const DesignLoadingOverlay({
    super.key,
    required this.isLoading,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading)
          Container(
            color: Theme.of(context).brightness == Brightness.dark
                ? DesignColors.overlayDark
                : DesignColors.overlayLight,
            child: const Center(
              child: DesignCircularLoader(),
            ),
          ),
      ],
    );
  }
}

/// Cargador circular estilo Apple.
class DesignCircularLoader extends StatelessWidget {
  const DesignCircularLoader({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final color = isDark ? DesignColors.primaryDark : DesignColors.primaryLight;

    return CircularProgressIndicator.adaptive(
      valueColor: AlwaysStoppedAnimation<Color>(color),
    );
  }
}

/// Bloque de Carga Esqueleto (Skeleton) personalizable.
class DesignSkeletonLoader extends StatelessWidget {
  final double width;
  final double height;
  final BorderRadiusGeometry? borderRadius;

  const DesignSkeletonLoader({
    super.key,
    this.width = double.infinity,
    required this.height,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return ShimmerAnimation(
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: borderRadius ?? DesignRadius.allMedium,
        ),
      ),
    );
  }
}

/// Componente de Estado Vacío (Empty State).
class DesignEmptyState extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final VoidCallback? onAction;
  final String? actionLabel;

  const DesignEmptyState({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    this.onAction,
    this.actionLabel,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 64,
              color: isDark ? Colors.white30 : Colors.black26,
            ),
            DesignSpacing.spacerV16,
            Text(
              title,
              style: DesignTypography.titleMedium.copyWith(
                color: isDark ? DesignColors.textPrimaryDark : DesignColors.textPrimaryLight,
              ),
              textAlign: TextAlign.center,
            ),
            DesignSpacing.spacerV8,
            Text(
              description,
              style: DesignTypography.bodyMedium.copyWith(
                color: isDark ? DesignColors.textSecondaryDark : DesignColors.textSecondaryLight,
              ),
              textAlign: TextAlign.center,
            ),
            if (onAction != null && actionLabel != null) ...[
              DesignSpacing.spacerV24,
              ElevatedButton(
                onPressed: onAction,
                style: ElevatedButton.styleFrom(
                  backgroundColor: isDark ? DesignColors.primaryDark : DesignColors.primaryLight,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: DesignRadius.allMedium),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                child: Text(actionLabel!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Componente de Estado de Error.
class DesignErrorState extends StatelessWidget {
  final String title;
  final String description;
  final VoidCallback onRetry;

  const DesignErrorState({
    super.key,
    required this.title,
    required this.description,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return DesignEmptyState(
      title: title,
      description: description,
      icon: Icons.error_outline_rounded,
      actionLabel: 'Reintentar',
      onAction: onRetry,
    );
  }
}

/// Componente de Estado Completado Exitosamente.
class DesignSuccessState extends StatelessWidget {
  final String title;
  final String description;
  final VoidCallback? onContinue;
  final String? continueLabel;

  const DesignSuccessState({
    super.key,
    required this.title,
    required this.description,
    this.onContinue,
    this.continueLabel,
  });

  @override
  Widget build(BuildContext context) {
    return DesignEmptyState(
      title: title,
      description: description,
      icon: Icons.check_circle_outline_rounded,
      actionLabel: continueLabel,
      onAction: onContinue,
    );
  }
}
