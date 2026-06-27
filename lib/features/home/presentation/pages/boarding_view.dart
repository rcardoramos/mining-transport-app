import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mining_transport_app/shared/design_system/design_system.dart';
import '../viewmodels/home_dashboard_viewmodel.dart';
import '../../domain/entities/trip_entity.dart';

/// Pantalla de Embarque de Pasajeros.
/// Permite al conductor registrar pasajeros mediante escaneo QR o ingreso manual de DNI.
class BoardingView extends ConsumerStatefulWidget {
  final String tripId;

  const BoardingView({super.key, required this.tripId});

  @override
  ConsumerState<BoardingView> createState() => _BoardingViewState();
}

class _BoardingViewState extends ConsumerState<BoardingView> {
  final _dniController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isManualInputVisible = false;
  bool _isRegistering = false;

  @override
  void dispose() {
    _dniController.dispose();
    super.dispose();
  }

  String _formatTime(DateTime? dateTime) {
    if (dateTime == null) return '--:--';
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  void _showCameraSimulator(TripEntity trip) {
    showDialog(
      context: context,
      builder: (ctx) => DesignDialog(
        title: 'Escaneo de Fotocheck / DNI',
        content:
            'Simulando activación de cámara trasera...\n\n'
            'Alinee el código de barras o QR del fotocheck dentro del recuadro.\n\n'
            '¿Desea simular un escaneo exitoso?',
        confirmLabel: 'Simular Escaneo',
        cancelLabel: 'Cancelar',
        onConfirm: () async {
          setState(() => _isRegistering = true);
          final success = await ref
              .read(homeDashboardViewModelProvider.notifier)
              .registerPassenger(trip.id, '48102030');
          setState(() => _isRegistering = false);
          if (mounted) {
            if (success) {
              DesignSnackbar.showSuccess(context,
                  'Pasajero registrado exitosamente vía escaneo.');
            } else {
              DesignSnackbar.showError(context,
                  'No se pudo registrar al pasajero. Intente nuevamente.');
            }
          }
        },
      ),
    );
  }

  Future<void> _submitManualDni(TripEntity trip) async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isRegistering = true);

    final success = await ref
        .read(homeDashboardViewModelProvider.notifier)
        .registerPassenger(trip.id, _dniController.text.trim());

    setState(() {
      _isManualInputVisible = false;
      _isRegistering = false;
    });

    if (mounted) {
      if (success) {
        DesignSnackbar.showSuccess(
            context, 'DNI ${_dniController.text.trim()} registrado con éxito.');
        _dniController.clear();
      } else {
        DesignSnackbar.showError(
            context, 'Error al registrar. Verifique el DNI e intente de nuevo.');
      }
    }
  }

  Future<void> _iniciarViaje(TripEntity trip) async {
    // Confirmar la acción con el conductor
    final confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => DesignDialog(
        title: '¿Iniciar el viaje?',
        content:
            'Se cerrará el registro de embarque y el bus comenzará el recorrido.\n\n'
            'Pasajeros registrados: ${trip.passengerCount} / ${trip.capacity}\n\n'
            'Esta acción no se puede deshacer.',
        confirmLabel: 'Iniciar Viaje',
        cancelLabel: 'Cancelar',
        onConfirm: () => Navigator.of(ctx).pop(true),
        onCancel: () => Navigator.of(ctx).pop(false),
      ),
    );

    if (confirmed != true || !mounted) return;

    // Cambiar estado a "en tránsito"
    await ref
        .read(homeDashboardViewModelProvider.notifier)
        .updateTripStatus(trip.id, TripStatus.travelling);

    if (mounted) {
      DesignSnackbar.showSuccess(
          context, '¡Viaje iniciado! El bus está en camino.');
      // Regresar al Dashboard
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final state = ref.watch(homeDashboardViewModelProvider);
    final colors = Theme.of(context).extension<DesignThemeExtension>()!;

    if (state.isLoading) {
      return const Scaffold(body: Center(child: DesignCircularLoader()));
    }

    final data = state.data;

    // Buscar el viaje activo
    TripEntity? trip;
    if (data != null) {
      final all = [...data.todayTrips, ...data.pendingTrips];
      try {
        trip = all.firstWhere((t) => t.id == widget.tripId);
      } catch (_) {}
    }

    if (trip == null) {
      return Scaffold(
        appBar: DesignAppBar(
          title: 'Embarque',
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
            onPressed: () => context.pop(),
          ),
        ),
        body: const DesignEmptyState(
          title: 'Viaje no encontrado',
          description: 'No se pudo localizar el viaje activo. Regresa al Dashboard.',
          icon: Icons.directions_bus_outlined,
        ),
      );
    }

    final safePercentage = (trip.passengerCount / trip.capacity).clamp(0.0, 1.0);

    return Scaffold(
      appBar: DesignAppBar(
        title: 'Embarque de Pasajeros',
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      // ── Botón fijo "Iniciar Viaje" ──────────────────────────────────────────
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Contador rápido de embarque
              Container(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1A2332) : const Color(0xFFEFF6FF),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isDark ? DesignColors.primaryDark.withOpacity(0.3) : DesignColors.primaryLight.withOpacity(0.2),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.people_rounded,
                      size: 18,
                      color: isDark ? DesignColors.primaryDark : DesignColors.primaryLight,
                    ),
                    const SizedBox(width: 8),
                    RichText(
                      text: TextSpan(
                        style: DesignTypography.bodyMedium.copyWith(
                          color: isDark ? DesignColors.textSecondaryDark : DesignColors.textSecondaryLight,
                        ),
                        children: [
                          const TextSpan(text: 'Pasajeros registrados: '),
                          TextSpan(
                            text: '${trip.passengerCount}',
                            style: DesignTypography.titleMedium.copyWith(
                              fontWeight: FontWeight.bold,
                              color: isDark ? DesignColors.primaryDark : DesignColors.primaryLight,
                            ),
                          ),
                          TextSpan(text: ' / ${trip.capacity}'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              DesignButton.primary(
                text: 'Iniciar Viaje',
                onTap: _isRegistering ? null : () => _iniciarViaje(trip!),
                icon: Icons.directions_bus_filled_rounded,
                fullWidth: true,
              ),
            ],
          ),
        ),
      ),
      body: ListView(
        padding: DesignSpacing.allM,
        children: [
          // ── Cabecera con datos del viaje activo ──────────────────────────
          DesignCard.status(
            statusColor:
                isDark ? DesignColors.primaryDark : DesignColors.primaryLight,
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
                          color: isDark
                              ? DesignColors.textPrimaryDark
                              : DesignColors.textPrimaryLight,
                        ),
                      ),
                    ),
                    DesignBadge(label: 'En curso', color: colors.info),
                  ],
                ),
                DesignSpacing.spacerV12,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildMeta(Icons.access_time_rounded, 'Prog.',
                        _formatTime(trip.scheduledTime), isDark),
                    _buildMeta(Icons.play_circle_fill_rounded, 'Inicio',
                        _formatTime(trip.startedAt), isDark),
                    _buildMeta(Icons.directions_bus_rounded, 'Vehículo',
                        trip.unitCode, isDark),
                  ],
                ),
                DesignSpacing.spacerV16,
                const DesignDivider(),
                DesignSpacing.spacerV16,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Ocupación actual',
                      style: DesignTypography.bodyMedium.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isDark
                            ? DesignColors.textPrimaryDark
                            : DesignColors.textPrimaryLight,
                      ),
                    ),
                    Text(
                      '${trip.passengerCount} / ${trip.capacity}',
                      style: DesignTypography.titleMedium.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isDark
                            ? DesignColors.primaryDark
                            : DesignColors.primaryLight,
                      ),
                    ),
                  ],
                ),
                DesignSpacing.spacerV8,
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: safePercentage,
                    backgroundColor: isDark
                        ? const Color(0xFF2C2C2C)
                        : const Color(0xFFE5E7EB),
                    color: isDark
                        ? DesignColors.primaryDark
                        : DesignColors.primaryLight,
                    minHeight: 10,
                  ),
                ),
              ],
            ),
          ),

          DesignSpacing.spacerV24,
          Text(
            'Selecciona el método de registro:',
            style: DesignTypography.bodyMedium.copyWith(
              fontWeight: FontWeight.bold,
              color: isDark
                  ? DesignColors.textSecondaryDark
                  : DesignColors.textSecondaryLight,
            ),
          ),
          DesignSpacing.spacerV12,

          // ── Opción 1: Escaneo QR ─────────────────────────────────────────
          DesignCard.basic(
            onTap: _isRegistering ? null : () => _showCameraSimulator(trip!),
            child: Row(
              children: [
                Container(
                  padding: DesignSpacing.allS,
                  decoration: BoxDecoration(
                    color: colors.info.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.qr_code_scanner_rounded,
                      size: 32, color: colors.info),
                ),
                DesignSpacing.spacerH16,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Escanear DNI o Fotocheck',
                        style: DesignTypography.titleMedium.copyWith(
                          fontWeight: FontWeight.bold,
                          color: isDark
                              ? DesignColors.textPrimaryDark
                              : DesignColors.textPrimaryLight,
                        ),
                      ),
                      DesignSpacing.spacerV4,
                      Text(
                        'Usa la cámara para leer el código QR o barras del fotocheck corporativo.',
                        style: DesignTypography.caption.copyWith(
                          color: isDark
                              ? DesignColors.textSecondaryDark
                              : DesignColors.textSecondaryLight,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  color: isDark
                      ? DesignColors.textSecondaryDark
                      : DesignColors.textSecondaryLight,
                ),
              ],
            ),
          ),

          DesignSpacing.spacerV16,

          // ── Opción 2: Embarque Manual ─────────────────────────────────────
          DesignCard.basic(
            onTap: _isRegistering
                ? null
                : () {
                    setState(() {
                      _isManualInputVisible = !_isManualInputVisible;
                    });
                  },
            child: Row(
              children: [
                Container(
                  padding: DesignSpacing.allS,
                  decoration: BoxDecoration(
                    color: colors.warning.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.keyboard_rounded,
                      size: 32, color: colors.warning),
                ),
                DesignSpacing.spacerH16,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Embarque Manual',
                        style: DesignTypography.titleMedium.copyWith(
                          fontWeight: FontWeight.bold,
                          color: isDark
                              ? DesignColors.textPrimaryDark
                              : DesignColors.textPrimaryLight,
                        ),
                      ),
                      DesignSpacing.spacerV4,
                      Text(
                        'Ingresa el DNI manualmente si el fotocheck no puede ser leído por la cámara.',
                        style: DesignTypography.caption.copyWith(
                          color: isDark
                              ? DesignColors.textSecondaryDark
                              : DesignColors.textSecondaryLight,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  _isManualInputVisible
                      ? Icons.keyboard_arrow_up_rounded
                      : Icons.keyboard_arrow_down_rounded,
                  color: isDark
                      ? DesignColors.textSecondaryDark
                      : DesignColors.textSecondaryLight,
                ),
              ],
            ),
          ),

          // ── Panel de ingreso de DNI manual ───────────────────────────────
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 280),
            transitionBuilder: (child, animation) =>
                FadeTransition(opacity: animation, child: child),
            child: _isManualInputVisible
                ? Padding(
                    key: const ValueKey('manual_form'),
                    padding: const EdgeInsets.only(top: 16),
                    child: Container(
                      padding: DesignSpacing.allM,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: isDark
                              ? DesignColors.borderDark
                              : DesignColors.borderLight,
                          width: 1.2,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        color: isDark
                            ? const Color(0xFF1E1E1E)
                            : const Color(0xFFFAFAFA),
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Ingresa el DNI del pasajero',
                              style: DesignTypography.bodyMedium.copyWith(
                                fontWeight: FontWeight.bold,
                                color: isDark
                                    ? DesignColors.textPrimaryDark
                                    : DesignColors.textPrimaryLight,
                              ),
                            ),
                            DesignSpacing.spacerV12,
                            DesignTextField(
                              controller: _dniController,
                              labelText: 'Número de DNI',
                              hintText: 'Ingresa los 8 dígitos',
                              keyboardType: TextInputType.number,
                              prefixIcon: const Icon(Icons.badge_rounded),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Por favor ingresa el DNI';
                                }
                                if (value.trim().length != 8 ||
                                    int.tryParse(value.trim()) == null) {
                                  return 'El DNI debe tener exactamente 8 dígitos numéricos';
                                }
                                return null;
                              },
                            ),
                            DesignSpacing.spacerV16,
                            DesignButton.primary(
                              text: _isRegistering
                                  ? 'Procesando...'
                                  : 'Registrar Embarque',
                              onTap: _isRegistering
                                  ? null
                                  : () => _submitManualDni(trip!),
                              icon: Icons.check_circle_outline_rounded,
                              fullWidth: true,
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                : const SizedBox.shrink(key: ValueKey('manual_hidden')),
          ),

          DesignSpacing.spacerV32,
        ],
      ),
    );
  }

  Widget _buildMeta(
      IconData icon, String label, String value, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon,
                size: 13,
                color: isDark
                    ? DesignColors.textSecondaryDark
                    : DesignColors.textSecondaryLight),
            DesignSpacing.spacerH4,
            Text(
              label,
              style: DesignTypography.caption.copyWith(
                color: isDark
                    ? DesignColors.textSecondaryDark
                    : DesignColors.textSecondaryLight,
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
            color: isDark
                ? DesignColors.textPrimaryDark
                : DesignColors.textPrimaryLight,
          ),
        ),
      ],
    );
  }
}
