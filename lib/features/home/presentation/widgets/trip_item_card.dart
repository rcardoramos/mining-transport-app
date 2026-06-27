import 'package:flutter/material.dart';
import 'package:mining_transport_app/shared/design_system/design_system.dart';
import '../../domain/entities/trip_entity.dart';

/// Tarjeta de viaje detallada que muestra rutas, horas, turnos, buses y ocupación
/// con botones de acción contextuales y visualizaciones animadas según el estado.
class TripItemCard extends StatelessWidget {
  final TripEntity trip;
  final bool isAperturarDisabled;
  final Function(TripStatus) onStatusChanged;
  final VoidCallback? onContinuarEmbarque;
  final VoidCallback? onVerResumen;

  const TripItemCard({
    super.key,
    required this.trip,
    required this.isAperturarDisabled,
    required this.onStatusChanged,
    this.onContinuarEmbarque,
    this.onVerResumen,
  });

  String _formatTime(DateTime? dateTime) {
    if (dateTime == null) return '--:--';
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  Color _getStatusColor(TripStatus status, DesignThemeExtension colors) {
    switch (status) {
      case TripStatus.scheduled:
      case TripStatus.readyToStart:
        return colors.warning;
      case TripStatus.inProgress:
        return colors.info;
      case TripStatus.travelling:
        return colors.success;
      case TripStatus.completed:
        return colors.success;
      case TripStatus.cancelled:
        return colors.danger;
    }
  }

  String _getStatusText(TripStatus status) {
    switch (status) {
      case TripStatus.scheduled:
      case TripStatus.readyToStart:
        return 'Por iniciar';
      case TripStatus.inProgress:
        return 'Embarque en curso';
      case TripStatus.travelling:
        return 'En tránsito';
      case TripStatus.completed:
        return 'Finalizado';
      case TripStatus.cancelled:
        return 'Cancelado';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = Theme.of(context).extension<DesignThemeExtension>()!;
    final statusColor = _getStatusColor(trip.status, colors);
    final isTripActive = trip.status == TripStatus.inProgress;

    Widget cardBody = DesignCard.status(
      statusColor: isTripActive ? (isDark ? DesignColors.primaryDark : DesignColors.primaryLight) : statusColor,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 350),
        transitionBuilder: (child, animation) => FadeTransition(opacity: animation, child: child),
        child: Column(
          key: ValueKey('${trip.id}_${trip.status}'),
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
                _buildDetailColumn(Icons.access_time_rounded, 'Hora Prog.', _formatTime(trip.scheduledTime), isDark),
                _buildDetailColumn(Icons.wb_sunny_rounded, 'Turno', trip.shift, isDark),
                _buildDetailColumn(Icons.directions_bus_rounded, 'Bus', trip.unitCode, isDark),
                _buildDetailColumn(Icons.people_alt_rounded, 'Capacidad', '${trip.capacity}', isDark),
              ],
            ),
            
            if (isTripActive) ...[
              DesignSpacing.spacerV16,
              const DesignDivider(),
              DesignSpacing.spacerV16,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildDetailColumn(Icons.play_circle_fill_rounded, 'Hora Inicio', _formatTime(trip.startedAt), isDark),
                  _buildDetailColumn(Icons.people_rounded, 'Pasajeros', '${trip.passengerCount} / ${trip.capacity}', isDark),
                ],
              ),
              DesignSpacing.spacerV16,
              _buildProgressBar(trip.passengerCount / trip.capacity, isDark ? DesignColors.primaryDark : DesignColors.primaryLight, isDark),
            ],

            if (trip.status != TripStatus.cancelled) ...[
              DesignSpacing.spacerV16,
              Row(
                children: [
                  if (trip.status == TripStatus.scheduled || trip.status == TripStatus.readyToStart)
                    Expanded(
                      child: DesignButton.primary(
                        text: 'Aperturar Viaje',
                        onTap: isAperturarDisabled ? null : () => onStatusChanged(TripStatus.inProgress),
                        icon: Icons.play_arrow_rounded,
                        fullWidth: true,
                      ),
                    ),
                  if (trip.status == TripStatus.inProgress) ...[
                    Expanded(
                      child: DesignButton.primary(
                        text: 'Continuar Embarque',
                        onTap: onContinuarEmbarque,
                        icon: Icons.qr_code_scanner_rounded,
                        fullWidth: true,
                      ),
                    ),
                  ],
                  if (trip.status == TripStatus.travelling) ...[
                    Expanded(
                      child: DesignButton.outlined(
                        text: 'Ver Resumen',
                        onTap: onVerResumen,
                        icon: Icons.directions_bus_filled_rounded,
                        fullWidth: true,
                      ),
                    ),
                  ],
                  if (trip.status == TripStatus.completed)
                    Expanded(
                      child: DesignButton.outlined(
                        text: 'Ver Resumen',
                        onTap: onVerResumen,
                        icon: Icons.assignment_turned_in_rounded,
                        fullWidth: true,
                      ),
                    ),
                ],
              ),
            ],
          ],
        ),
      ),
    );

    if (isTripActive) {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: (isDark ? DesignColors.primaryDark : DesignColors.primaryLight).withOpacity(0.08),
              blurRadius: 16,
              spreadRadius: 2,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: cardBody,
      );
    }

    return cardBody;
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

  Widget _buildProgressBar(double percentage, Color color, bool isDark) {
    final double safePercentage = percentage.clamp(0.0, 1.0);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Progreso de Ocupación',
              style: DesignTypography.caption.copyWith(
                color: isDark ? DesignColors.textSecondaryDark : DesignColors.textSecondaryLight,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '${(safePercentage * 100).toInt()}%',
              style: DesignTypography.caption.copyWith(
                color: isDark ? DesignColors.textPrimaryDark : DesignColors.textPrimaryLight,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        DesignSpacing.spacerV8,
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: safePercentage,
            backgroundColor: isDark ? const Color(0xFF2C2C2C) : const Color(0xFFE5E7EB),
            color: color,
            minHeight: 8,
          ),
        ),
      ],
    );
  }
}
