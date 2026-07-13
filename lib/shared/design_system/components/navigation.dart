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

    final activeColor = isDark ? DesignColors.primaryDark : DesignColors.primaryLight;
    final inactiveColor = isDark ? DesignColors.textSecondaryDark : DesignColors.textSecondaryLight;
    final bgColor = isDark ? const Color(0xFF1E1E24) : Colors.white;

    return Container(
      margin: const EdgeInsets.fromLTRB(24, 0, 24, 20),
      height: 72,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: DesignRadius.allBottomNav,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.35 : 0.06),
            blurRadius: 20,
            spreadRadius: 0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: DesignRadius.allBottomNav,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(items.length, (index) {
              final item = items[index];
              final isSelected = index == currentIndex;

              return Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => onTap(index),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.easeOut,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                        decoration: BoxDecoration(
                          color: isSelected 
                              ? activeColor.withOpacity(0.1) 
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Icon(
                          (item.icon as Icon).icon,
                          color: isSelected ? activeColor : inactiveColor,
                          size: 22,
                        ),
                      ),
                      DesignSpacing.spacerV4,
                      Text(
                        item.label ?? '',
                        style: DesignTypography.caption.copyWith(
                          color: isSelected ? activeColor : inactiveColor,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
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
  final Widget? subtitleWidget;
  final Widget? leading;
  final Widget? trailing;
  final VoidCallback? onTap;

  const DesignListTile({
    super.key,
    required this.title,
    this.subtitle,
    this.subtitleWidget,
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
      subtitle: subtitleWidget ?? (subtitle != null
          ? Text(
              subtitle!,
              style: DesignTypography.bodyMedium.copyWith(
                color: isDark ? DesignColors.textSecondaryDark : DesignColors.textSecondaryLight,
              ),
            )
          : null),
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
