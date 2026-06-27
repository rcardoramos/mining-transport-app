import 'package:flutter/material.dart';
import 'package:mining_transport_app/shared/design_system/design_system.dart';
import '../../domain/entities/driver_entity.dart';

/// Tarjeta del conductor que muestra su foto, código de red, estatus de turno y contador de viajes.
class DriverProfileCard extends StatelessWidget {
  final DriverEntity driver;

  const DriverProfileCard({
    super.key,
    required this.driver,
  });

  String _getStatusLabel(DriverStatus status) {
    switch (status) {
      case DriverStatus.active:
        return 'En Turno';
      case DriverStatus.onBreak:
        return 'En Descanso';
      case DriverStatus.inactive:
        return 'Fuera de Turno';
    }
  }

  Color _getStatusColor(DriverStatus status, DesignThemeExtension customColors) {
    switch (status) {
      case DriverStatus.active:
        return customColors.success;
      case DriverStatus.onBreak:
        return customColors.warning;
      case DriverStatus.inactive:
        return customColors.danger;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final customColors = Theme.of(context).extension<DesignThemeExtension>()!;

    return DesignCard.basic(
      child: Row(
        children: [
          DesignAvatar(
            name: driver.name,
            imageUrl: driver.avatarUrl,
            size: 52,
          ),
          DesignSpacing.spacerH16,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  driver.name,
                  style: DesignTypography.titleMedium.copyWith(
                    color: isDark ? DesignColors.textPrimaryDark : DesignColors.textPrimaryLight,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                DesignSpacing.spacerV4,
                Row(
                  children: [
                    Text(
                      driver.code,
                      style: DesignTypography.bodyMedium.copyWith(
                        color: isDark ? DesignColors.textSecondaryDark : DesignColors.textSecondaryLight,
                      ),
                    ),
                    DesignSpacing.spacerH8,
                    Container(
                      width: 4,
                      height: 4,
                      decoration: BoxDecoration(
                        color: isDark ? DesignColors.textSecondaryDark : DesignColors.textSecondaryLight,
                        shape: BoxShape.circle,
                      ),
                    ),
                    DesignSpacing.spacerH8,
                    DesignBadge(
                      label: _getStatusLabel(driver.status),
                      color: _getStatusColor(driver.status, customColors),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${driver.todayTripsCount}',
                style: DesignTypography.titleLarge.copyWith(
                  color: isDark ? DesignColors.primaryDark : DesignColors.primaryLight,
                  fontWeight: FontWeight.w900,
                ),
              ),
              Text(
                'Viajes Hoy',
                style: DesignTypography.caption.copyWith(
                  color: isDark ? DesignColors.textSecondaryDark : DesignColors.textSecondaryLight,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
