import 'package:flutter/material.dart';
import '../tokens/colors/design_colors.dart';
import '../tokens/radius/design_radius.dart';
import '../tokens/spacing/design_spacing.dart';
import '../tokens/typography/design_typography.dart';
import '../animations/design_animations.dart';

/// Barra de Navegación Superior (AppBar) corporativa con borde inferior sutil.
class DesignAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool centerTitle;

  const DesignAppBar({
    super.key,
    required this.title,
    this.actions,
    this.leading,
    this.centerTitle = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return AppBar(
      title: Text(
        title,
        style: DesignTypography.titleLarge.copyWith(
          color: isDark ? DesignColors.textPrimaryDark : DesignColors.textPrimaryLight,
          fontWeight: FontWeight.bold,
        ),
      ),
      leading: leading,
      actions: actions,
      centerTitle: centerTitle,
      backgroundColor: isDark ? DesignColors.surfaceDark : DesignColors.surfaceLight,
      elevation: 0,
      iconTheme: IconThemeData(
        color: isDark ? DesignColors.textPrimaryDark : DesignColors.textPrimaryLight,
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Divider(
          height: 1,
          thickness: 1,
          color: isDark ? DesignColors.borderDark : DesignColors.borderLight,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

/// Barra de Navegación Inferior (BottomNavigationBar) corporativa.
class DesignBottomNavigation extends StatelessWidget {
  final int currentIndex;
  final List<BottomNavigationBarItem> items;
  final void Function(int) onTap;

  const DesignBottomNavigation({
    super.key,
    required this.currentIndex,
    required this.items,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: isDark ? DesignColors.borderDark : DesignColors.borderLight,
            width: 1,
          ),
        ),
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        items: items,
        onTap: onTap,
        backgroundColor: isDark ? DesignColors.surfaceDark : DesignColors.surfaceLight,
        selectedItemColor: isDark ? DesignColors.primaryDark : DesignColors.primaryLight,
        unselectedItemColor: isDark ? DesignColors.textSecondaryDark : DesignColors.textSecondaryLight,
        selectedLabelStyle: DesignTypography.labelMedium.copyWith(fontWeight: FontWeight.bold),
        unselectedLabelStyle: DesignTypography.labelMedium,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
    );
  }
}

/// Botón de Acción Flotante (Floating Action Button) corporativo.
class DesignFAB extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final String? label;

  const DesignFAB({
    super.key,
    required this.icon,
    required this.onTap,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final bg = isDark ? DesignColors.secondaryDark : DesignColors.secondaryLight;
    const fg = Colors.white;

    final child = label != null
        ? Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: fg),
              DesignSpacing.spacerH8,
              Text(
                label!,
                style: DesignTypography.labelLarge.copyWith(color: fg),
              ),
            ],
          )
        : Icon(icon, color: fg);

    return ButtonPressAnimation(
      onTap: onTap,
      child: FloatingActionButton(
        onPressed: () {},
        backgroundColor: bg,
        foregroundColor: fg,
        shape: RoundedRectangleBorder(borderRadius: DesignRadius.allLarge),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: child,
        ),
      ),
    );
  }
}

/// Encabezado de Sección (Section Header).
class DesignSectionHeader extends StatelessWidget {
  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;

  const DesignSectionHeader({
    super.key,
    required this.title,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: DesignTypography.titleMedium.copyWith(
              color: isDark ? DesignColors.textPrimaryDark : DesignColors.textPrimaryLight,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (actionLabel != null && onAction != null)
            TextButton(
              onPressed: onAction,
              child: Text(
                actionLabel!,
                style: DesignTypography.labelMedium.copyWith(
                  color: isDark ? DesignColors.primaryDark : DesignColors.primaryLight,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Elemento de Lista (List Tile) corporativo.
class DesignListTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final VoidCallback? onTap;

  const DesignListTile({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return ListTile(
      title: Text(
        title,
        style: DesignTypography.bodyLarge.copyWith(
          color: isDark ? DesignColors.textPrimaryDark : DesignColors.textPrimaryLight,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle!,
              style: DesignTypography.bodyMedium.copyWith(
                color: isDark ? DesignColors.textSecondaryDark : DesignColors.textSecondaryLight,
              ),
            )
          : null,
      leading: leading,
      trailing: trailing,
      onTap: onTap,
      shape: RoundedRectangleBorder(borderRadius: DesignRadius.allMedium),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    );
  }
}

/// Avatar corporativo que renderiza iniciales o una imagen de red.
class DesignAvatar extends StatelessWidget {
  final String? name;
  final String? imageUrl;
  final double size;

  const DesignAvatar({
    super.key,
    this.name,
    this.imageUrl,
    this.size = 40,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? DesignColors.borderDark : DesignColors.borderLight;

    if (imageUrl != null) {
      return CircleAvatar(
        radius: size / 2,
        backgroundImage: NetworkImage(imageUrl!),
        backgroundColor: bg,
      );
    }

    final initials = name != null && name!.isNotEmpty
        ? name!.trim().split(' ').map((e) => e[0]).take(2).join().toUpperCase()
        : '?';

    return CircleAvatar(
      radius: size / 2,
      backgroundColor: isDark ? DesignColors.primaryDark.withOpacity(0.2) : DesignColors.primaryLight.withOpacity(0.1),
      child: Text(
        initials,
        style: DesignTypography.labelLarge.copyWith(
          color: isDark ? DesignColors.primaryDark : DesignColors.primaryLight,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

/// Divisor horizontal sutil alineado a las paletas de color.
class DesignDivider extends StatelessWidget {
  const DesignDivider({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Divider(
      height: 1,
      thickness: 1,
      color: isDark ? DesignColors.borderDark : DesignColors.borderLight,
    );
  }
}
