import 'package:flutter/material.dart';
import 'package:mining_transport_app/shared/design_system/design_system.dart';
import '../../domain/entities/trip_entity.dart';

/// Tarjeta de viaje detallada que muestra rutas, horas, turnos, buses y ocupación
/// con botones de acción contextuales según el estado actual del viaje.
class TripItemCard extends StatelessWidget {
  final TripEntity trip;
  final Function(TripStatus) onStatusChanged;

  const TripItemCard({
    super.key,
    required this.trip,
    required this.onStatusChanged,
  });

  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  Color _getStatusColor(TripStatus status, DesignThemeExtension colors) {
    switch (status) {
      case TripStatus.pending:
        return colors.warning;
      case TripStatus.active:
        return colors.info;
      case TripStatus.paused:
        return colors.danger;
      case TripStatus.completed:
        return colors.success;
    }
  }

  String _getStatusText(TripStatus status) {
    switch (status) {
      case TripStatus.pending:
        return 'Pendiente';
      case TripStatus.active:
        return 'En Curso';
      case TripStatus.paused:
        return 'Pausado';
      case TripStatus.completed:
        return 'Completado';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = Theme.of(context).extension<DesignThemeExtension>()!;
    final statusColor = _getStatusColor(trip.status, colors);

    return DesignCard.status(
      statusColor: statusColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  trip.route,
                  style: DesignTypography.titleMedium.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isDark ? DesignColors.textPrimaryDark : DesignColors.textPrimaryLight,
                  ),
                ),
              ),
              DesignBadge(
                label: _getStatusText(trip.status),
                color: statusColor,
              ),
            ],
          ),
          DesignSpacing.spacerV12,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildDetailColumn(Icons.access_time_rounded, 'Hora', _formatTime(trip.scheduledTime), isDark),
              _buildDetailColumn(Icons.wb_sunny_rounded, 'Turno', trip.shift, isDark),
              _buildDetailColumn(Icons.directions_bus_rounded, 'Bus', trip.unitCode, isDark),
              _buildDetailColumn(Icons.people_alt_rounded, 'Pasajeros', '${trip.passengerCount}/${trip.capacity}', isDark),
            ],
          ),
          if (trip.status != TripStatus.completed) ...[
            DesignSpacing.spacerV16,
            Row(
              children: [
                if (trip.status == TripStatus.pending)
                  Expanded(
                    child: DesignButton.primary(
                      text: 'Aperturar Viaje',
                      onTap: () => onStatusChanged(TripStatus.active),
                      icon: Icons.play_arrow_rounded,
                      fullWidth: true,
                    ),
                  ),
                if (trip.status == TripStatus.active) ...[
                  Expanded(
                    child: DesignButton.secondary(
                      text: 'Pausar',
                      onTap: () => onStatusChanged(TripStatus.paused),
                      icon: Icons.pause_rounded,
                      fullWidth: true,
                    ),
                  ),
                  DesignSpacing.spacerH12,
                  Expanded(
                    child: DesignButton.primary(
                      text: 'Finalizar',
                      onTap: () => onStatusChanged(TripStatus.completed),
                      icon: Icons.check_rounded,
                      fullWidth: true,
                    ),
                  ),
                ],
                if (trip.status == TripStatus.paused) ...[
                  Expanded(
                    child: DesignButton.primary(
                      text: 'Continuar Viaje',
                      onTap: () => onStatusChanged(TripStatus.active),
                      icon: Icons.play_arrow_rounded,
                      fullWidth: true,
                    ),
                  ),
                  DesignSpacing.spacerH12,
                  Expanded(
                    child: DesignButton.outlined(
                      text: 'Finalizar',
                      onTap: () => onStatusChanged(TripStatus.completed),
                      icon: Icons.check_rounded,
                      fullWidth: true,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDetailColumn(IconData icon, String label, String value, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              size: 14,
              color: isDark ? DesignColors.textSecondaryDark : DesignColors.textSecondaryLight,
            ),
            DesignSpacing.spacerH4,
            Text(
              label,
              style: DesignTypography.caption.copyWith(
                color: isDark ? DesignColors.textSecondaryDark : DesignColors.textSecondaryLight,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        DesignSpacing.spacerV4,
        Text(
          value,
          style: DesignTypography.bodyMedium.copyWith(
            fontWeight: FontWeight.bold,
            color: isDark ? DesignColors.textPrimaryDark : DesignColors.textPrimaryLight,
          ),
        ),
      ],
    );
  }
}
