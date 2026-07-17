import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mining_transport_app/shared/design_system/design_system.dart';

/// Diálogo modal para capturar el kilometraje inicial (odómetro)
/// antes de aperturar un viaje.
class TripOpenDialog extends StatefulWidget {
  final String tripRoute;
  final String unitCode;

  const TripOpenDialog({
    super.key,
    required this.tripRoute,
    required this.unitCode,
  });

  @override
  State<TripOpenDialog> createState() => _TripOpenDialogState();
}

class _TripOpenDialogState extends State<TripOpenDialog> {
  final _formKey = GlobalKey<FormState>();
  final _kmController = TextEditingController();
  final bool _isSubmitting = false;

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
              // Header
              Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: (isDark ? DesignColors.primaryDark : DesignColors.primaryLight)
                          .withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.speed_rounded,
                      color: isDark ? DesignColors.primaryDark : DesignColors.primaryLight,
                      size: 24,
                    ),
                  ),
                  DesignSpacing.spacerH12,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Aperturar Viaje',
                          style: DesignTypography.titleMedium.copyWith(
                            fontWeight: FontWeight.bold,
                            color: isDark ? DesignColors.textPrimaryDark : DesignColors.textPrimaryLight,
                          ),
                        ),
                        Text(
                          widget.unitCode,
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

              // Ruta
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
                child: Row(
                  children: [
                    Icon(
                      Icons.route_rounded,
                      size: 16,
                      color: isDark ? DesignColors.textSecondaryDark : DesignColors.textSecondaryLight,
                    ),
                    DesignSpacing.spacerH8,
                    Expanded(
                      child: Text(
                        widget.tripRoute,
                        style: DesignTypography.bodyMedium.copyWith(
                          fontWeight: FontWeight.w600,
                          color: isDark ? DesignColors.textPrimaryDark : DesignColors.textPrimaryLight,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              DesignSpacing.spacerV20,

              // Campo de Kilometraje
              Text(
                'Kilometraje Inicial (Odómetro)',
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
                  hintText: 'Ej: 120500',
                  hintStyle: DesignTypography.bodyMedium.copyWith(
                    color: isDark ? DesignColors.textSecondaryDark : DesignColors.textSecondaryLight,
                  ),
                  prefixIcon: Icon(
                    Icons.speed_outlined,
                    color: isDark ? DesignColors.primaryDark : DesignColors.primaryLight,
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
                    borderSide: BorderSide(
                      color: isDark ? DesignColors.primaryDark : DesignColors.primaryLight,
                      width: 2,
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.red),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Ingresa el kilometraje del odómetro';
                  }
                  final km = int.tryParse(value.trim());
                  if (km == null || km <= 0) {
                    return 'El kilometraje debe ser mayor a cero';
                  }
                  return null;
                },
              ),
              DesignSpacing.spacerV8,
              Text(
                'Registra la lectura exacta del velocímetro del bus antes de partir.',
                style: DesignTypography.caption.copyWith(
                  color: isDark ? DesignColors.textSecondaryDark : DesignColors.textSecondaryLight,
                ),
              ),
              DesignSpacing.spacerV24,

              // Botones
              Row(
                children: [
                  Expanded(
                    child: DesignButton.outlined(
                      text: 'Cancelar',
                      onTap: _isSubmitting ? null : () => Navigator.of(context).pop(null),
                      fullWidth: true,
                    ),
                  ),
                  DesignSpacing.spacerH12,
                  Expanded(
                    child: DesignButton.primary(
                      text: 'Aperturar',
                      icon: Icons.play_arrow_rounded,
                      onTap: _isSubmitting ? null : _submit,
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
}
