import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mining_transport_app/features/home/domain/entities/trip_entity.dart';
import 'package:mining_transport_app/shared/design_system/design_system.dart';

/// Diálogo modal de confirmación para cerrar un viaje activo.
/// Solicita el kilometraje final y valida que sea mayor al inicial.
class TripCloseDialog extends StatefulWidget {
  final TripEntity trip;
  final int? startKm;

  const TripCloseDialog({
    super.key,
    required this.trip,
    this.startKm,
  });

  @override
  State<TripCloseDialog> createState() => _TripCloseDialogState();
}

class _TripCloseDialogState extends State<TripCloseDialog> {
  final _formKey = GlobalKey<FormState>();
  final _kmController = TextEditingController();

  @override
  void dispose() {
    _kmController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final km = int.tryParse(_kmController.text.trim());
    if (km == null) return;
    Navigator.of(context).pop(km);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final dangerColor = isDark ? DesignColors.dangerDark : DesignColors.dangerLight;

    return Dialog(
      backgroundColor: isDark ? DesignColors.surfaceDark : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header con alerta visual
              Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: dangerColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.stop_circle_rounded,
                      color: dangerColor,
                      size: 24,
                    ),
                  ),
                  DesignSpacing.spacerH12,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Cerrar Viaje',
                          style: DesignTypography.titleMedium.copyWith(
                            fontWeight: FontWeight.bold,
                            color: isDark ? DesignColors.textPrimaryDark : DesignColors.textPrimaryLight,
                          ),
                        ),
                        Text(
                          widget.trip.unitCode,
                          style: DesignTypography.caption.copyWith(
                            color: isDark ? DesignColors.textSecondaryDark : DesignColors.textSecondaryLight,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              DesignSpacing.spacerV16,

              // Resumen del viaje
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E1E24) : const Color(0xFFF9FAFB),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isDark ? DesignColors.borderDark : DesignColors.borderLight,
                  ),
                ),
                child: Column(
                  children: [
                    _buildSummaryRow(
                      icon: Icons.route_rounded,
                      label: 'Ruta',
                      value: widget.trip.route,
                      isDark: isDark,
                    ),
                    if (widget.startKm != null) ...[
                      const Divider(height: 16),
                      _buildSummaryRow(
                        icon: Icons.speed_outlined,
                        label: 'Km inicial',
                        value: '${widget.startKm} km',
                        isDark: isDark,
                      ),
                    ],
                    const Divider(height: 16),
                    _buildSummaryRow(
                      icon: Icons.people_alt_outlined,
                      label: 'Pasajeros',
                      value: '${widget.trip.passengerCount} / ${widget.trip.capacity}',
                      isDark: isDark,
                    ),
                  ],
                ),
              ),
              DesignSpacing.spacerV20,

              // Campo de Kilometraje Final
              Text(
                'Kilometraje Final (Odómetro)',
                style: DesignTypography.labelLarge.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isDark ? DesignColors.textPrimaryDark : DesignColors.textPrimaryLight,
                ),
              ),
              DesignSpacing.spacerV8,
              TextFormField(
                controller: _kmController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                autofocus: true,
                style: DesignTypography.titleMedium.copyWith(
                  color: isDark ? DesignColors.textPrimaryDark : DesignColors.textPrimaryLight,
                  fontWeight: FontWeight.bold,
                ),
                decoration: InputDecoration(
                  hintText: 'Ej: 120540',
                  hintStyle: DesignTypography.bodyMedium.copyWith(
                    color: isDark ? DesignColors.textSecondaryDark : DesignColors.textSecondaryLight,
                  ),
                  prefixIcon: Icon(
                    Icons.speed_outlined,
                    color: dangerColor,
                  ),
                  suffixText: 'km',
                  suffixStyle: DesignTypography.bodyMedium.copyWith(
                    color: isDark ? DesignColors.textSecondaryDark : DesignColors.textSecondaryLight,
                  ),
                  filled: true,
                  fillColor: isDark ? const Color(0xFF1E1E24) : const Color(0xFFF9FAFB),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: isDark ? DesignColors.borderDark : DesignColors.borderLight,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: isDark ? DesignColors.borderDark : DesignColors.borderLight,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: dangerColor, width: 2),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.red),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Ingresa el kilometraje del odómetro al finalizar';
                  }
                  final km = int.tryParse(value.trim());
                  if (km == null || km <= 0) {
                    return 'El kilometraje debe ser mayor a cero';
                  }
                  if (widget.startKm != null && km <= widget.startKm!) {
                    return 'Debe ser mayor al Km inicial (${widget.startKm} km)';
                  }
                  return null;
                },
              ),
              DesignSpacing.spacerV8,
              Text(
                'Esta acción cerrará el viaje y bloqueará el embarque de nuevos pasajeros.',
                style: DesignTypography.caption.copyWith(
                  color: dangerColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
              DesignSpacing.spacerV24,

              // Botones
              Row(
                children: [
                  Expanded(
                    child: DesignButton.outlined(
                      text: 'Cancelar',
                      onTap: () => Navigator.of(context).pop(null),
                      fullWidth: true,
                    ),
                  ),
                  DesignSpacing.spacerH12,
                  Expanded(
                    child: DesignButton.danger(
                      text: 'Cerrar Viaje',
                      icon: Icons.stop_circle_outlined,
                      onTap: _submit,
                      fullWidth: true,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryRow({
    required IconData icon,
    required String label,
    required String value,
    required bool isDark,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: isDark ? DesignColors.textSecondaryDark : DesignColors.textSecondaryLight,
        ),
        DesignSpacing.spacerH8,
        Text(
          '$label: ',
          style: DesignTypography.caption.copyWith(
            color: isDark ? DesignColors.textSecondaryDark : DesignColors.textSecondaryLight,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: DesignTypography.caption.copyWith(
              fontWeight: FontWeight.bold,
              color: isDark ? DesignColors.textPrimaryDark : DesignColors.textPrimaryLight,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
