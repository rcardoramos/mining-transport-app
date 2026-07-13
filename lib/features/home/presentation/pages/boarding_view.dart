import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:get_it/get_it.dart';
import 'package:mining_transport_app/shared/design_system/design_system.dart';
import 'package:mining_transport_app/core/utils/date_formatter.dart';
import '../widgets/connectivity_bar.dart';
import '../viewmodels/home_dashboard_viewmodel.dart';
import '../../domain/entities/trip_entity.dart';
import '../../domain/entities/passenger_entity.dart';
import '../../domain/entities/collaborator_entity.dart';
import '../../domain/usecases/get_passengers_on_board_usecase.dart';
import '../../domain/usecases/check_collaborator_usecase.dart';

import 'package:mining_transport_app/core/utils/result.dart';

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
  List<PassengerEntity> _passengersList = [];
  bool _isLoadingPassengers = false;
  bool _isPassengersListVisible = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadPassengers();
    });
  }

  Future<void> _loadPassengers() async {
    setState(() => _isLoadingPassengers = true);
    final useCase = GetIt.I<GetPassengersOnBoardUseCase>();
    final result = await useCase.call(widget.tripId);
    if (mounted) {
      setState(() {
        _isLoadingPassengers = false;
        result.fold(
          onSuccess: (data) => _passengersList = data,
          onFailure: (f) => _passengersList = [],
        );
      });
    }
  }

  @override
  void dispose() {
    _dniController.dispose();
    super.dispose();
  }

  String _formatTime(DateTime? dateTime) {
    return PeruDateFormatter.formatTime(dateTime);
  }

  void _showCameraSimulator(TripEntity trip) {
    showDialog(
      context: context,
      builder: (ctx) {
        final isDark = Theme.of(ctx).brightness == Brightness.dark;
        return AlertDialog(
          title: Text(
            'Simulador de Escaneo',
            style: DesignTypography.titleLarge.copyWith(
              color: isDark ? DesignColors.textPrimaryDark : DesignColors.textPrimaryLight,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Seleccione el perfil de colaborador que desea escanear para validar las reglas de negocio:',
                style: DesignTypography.bodyMedium.copyWith(
                  color: isDark ? DesignColors.textSecondaryDark : DesignColors.textSecondaryLight,
                ),
              ),
              DesignSpacing.spacerV16,
              _buildSimulateOption(ctx, trip, 'Colaborador Regular (OK)', '48102030', Colors.green),
              _buildSimulateOption(ctx, trip, 'Colaborador en Vacaciones', '11111111', Colors.amber),
              _buildSimulateOption(ctx, trip, 'Colaborador con Descanso Médico', '22222222', Colors.amber),
              _buildSimulateOption(ctx, trip, 'Colaborador con Licencia', '33333333', Colors.amber),
              _buildSimulateOption(ctx, trip, 'Colaborador Cesado (Bloqueado)', '44444444', Colors.red),
            ],
          ),
          backgroundColor: isDark ? DesignColors.surfaceDark : DesignColors.surfaceLight,
          shape: RoundedRectangleBorder(borderRadius: DesignRadius.allLarge),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(
                'Cancelar',
                style: DesignTypography.labelLarge.copyWith(
                  color: isDark ? DesignColors.textSecondaryDark : DesignColors.textSecondaryLight,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSimulateOption(BuildContext ctx, TripEntity trip, String title, String dni, Color color) {
    final isDark = Theme.of(ctx).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: InkWell(
        onTap: () {
          Navigator.pop(ctx);
          _handleCollaboratorBoarding(trip, dni);
        },
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            border: Border.all(
              color: color.withOpacity(0.5),
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(Icons.qr_code_scanner_rounded, color: color, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: DesignTypography.bodyMedium.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isDark ? DesignColors.textPrimaryDark : DesignColors.textPrimaryLight,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleCollaboratorBoarding(TripEntity trip, String dni) async {
    // 1. Verificar duplicidad de pasajero
    final isDuplicate = _passengersList.any((p) => p.dni.trim() == dni.trim());
    if (isDuplicate) {
      if (mounted) {
        showDialog(
          context: context,
          builder: (ctx) => DesignDialog(
            title: 'Alerta de Duplicidad',
            content: 'El colaborador con DNI $dni ya se encuentra registrado a bordo en este viaje.\n\nNo se permite el doble embarque.',
            confirmLabel: 'Entendido',
            onConfirm: () {},
          ),
        );
      }
      return;
    }

    // 2. Verificar aforo excedido
    if (trip.passengerCount >= trip.capacity) {
      if (mounted) {
        showDialog(
          context: context,
          builder: (ctx) => DesignDialog(
            title: 'Aforo Excedido',
            content: 'Se ha alcanzado la capacidad máxima del bus (${trip.capacity}/${trip.capacity}).\n\nNo se permite el embarque de más pasajeros.',
            confirmLabel: 'Entendido',
            onConfirm: () {},
          ),
        );
      }
      return;
    }

    setState(() => _isRegistering = true);
    final checkUseCase = GetIt.I<CheckCollaboratorUseCase>();
    final result = await checkUseCase.execute(dni);
    
    setState(() => _isRegistering = false);

    if (!mounted) return;

    if (result.isFailure) {
      final failure = result.failureOrNull!;
      if (failure is CollaboratorNotFoundFailure) {
        if (mounted) {
          showDialog(
            context: context,
            builder: (ctx) => DesignDialog(
              title: 'Colaborador No Encontrado',
              content: 'El DNI $dni no se encuentra registrado en el padrón del sistema.\nNo se permite su embarque.',
              confirmLabel: 'Entendido',
              onConfirm: () {},
            ),
          );
        }
      } else {
        DesignSnackbar.showError(context, 'Error al verificar colaborador.');
      }
      return;
    }

    final collaborator = result.successOrNull!;

    if (collaborator.status == CollaboratorStatus.ok) {
      // Registrar de inmediato
      setState(() => _isRegistering = true);
      final success = await ref
          .read(homeDashboardViewModelProvider.notifier)
          .registerPassenger(trip.id, dni, CollaboratorStatus.ok, collaborator.category);
      setState(() => _isRegistering = false);

      if (mounted) {
        if (success) {
          DesignSnackbar.showSuccess(context, 'Pasajero ${collaborator.fullName} (${collaborator.category}) registrado exitosamente.');
          _loadPassengers();
        } else {
          DesignSnackbar.showError(context, 'Fallo al registrar pasajero.');
        }
      }
    } else if (collaborator.status == CollaboratorStatus.terminated) {
      // Acceso denegado
      if (mounted) {
        showDialog(
          context: context,
          builder: (ctx) => DesignDialog(
            title: 'Acceso Denegado',
            content: 'El colaborador ${collaborator.fullName} (DNI: $dni) se encuentra en estado CESADO.\nNo está permitido su embarque.',
            confirmLabel: 'Entendido',
            onConfirm: () {},
          ),
        );
      }
    } else {
      // Vacaciones, descanso médico o licencia
      String alertType = '';
      if (collaborator.status == CollaboratorStatus.vacation) alertType = 'Vacaciones';
      if (collaborator.status == CollaboratorStatus.medicalLeave) alertType = 'DM';
      if (collaborator.status == CollaboratorStatus.license) alertType = 'Licencia';

      if (mounted) {
        final confirmBoard = await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (ctx) => DesignDialog(
            title: 'Alerta de Embarque',
            content: 'Este colaborador (${collaborator.fullName}) está con $alertType.\n\n¿Desea permitir el embarque a bordo del bus?',
            confirmLabel: 'Embarcar',
            cancelLabel: 'No embarcar',
            onConfirm: () {},
            onCancel: () {},
          ),
        );

        if (confirmBoard == true && mounted) {
          setState(() => _isRegistering = true);
          final success = await ref
              .read(homeDashboardViewModelProvider.notifier)
              .registerPassenger(trip.id, dni, collaborator.status, collaborator.category);
          setState(() => _isRegistering = false);

          if (mounted) {
            if (success) {
              DesignSnackbar.showSuccess(context, 'Pasajero ${collaborator.fullName} (${collaborator.category}) registrado con estado de excepción ($alertType).');
              _loadPassengers();
            } else {
              DesignSnackbar.showError(context, 'Fallo al registrar pasajero.');
            }
          }
        }
      }
    }
  }

  Future<void> _submitManualDni(TripEntity trip) async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() => _isRegistering = true);
    await _handleCollaboratorBoarding(trip, _dniController.text.trim());
    
    setState(() {
      _isManualInputVisible = false;
      _isRegistering = false;
    });
    _dniController.clear();
  }

  void _onGuardarLista() {
    DesignSnackbar.showSuccess(
        context, 'Lista de pasajeros guardada y sincronizada localmente.');
  }

  Future<void> _iniciarViaje(TripEntity trip) async {
    // Confirmar la acción con el conductor
    final confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => DesignDialog(
        title: '¿Iniciar el viaje?',
        content:
            'Se iniciará el recorrido del viaje.\n\n'
            'Pasajeros registrados: ${trip.passengerCount} / ${trip.capacity}\n\n'
            'Podrás continuar el embarque de pasajeros en las siguientes paradas durante el tránsito.',
        confirmLabel: 'Iniciar Viaje',
        cancelLabel: 'Cancelar',
        onConfirm: () {},
        onCancel: () {},
      ),
    );

    if (confirmed != true || !mounted) return;

    // Cambiar estado a "en tránsito"
    await ref
        .read(homeDashboardViewModelProvider.notifier)
        .updateTripStatus(trip.id, TripStatus.travelling);

    if (mounted) {
      DesignSnackbar.showSuccess(
          context, '¡Viaje iniciado! El bus está en tránsito.');
    }
  }

  Future<void> _finalizarViaje(TripEntity trip) async {
    // Confirmar la acción con el conductor
    final confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => DesignDialog(
        title: '¿Finalizar el viaje?',
        content:
            'Se cerrará el registro de embarque de forma definitiva.\n\n'
            'Pasajeros registrados: ${trip.passengerCount} / ${trip.capacity}\n\n'
            'Esta acción no se puede deshacer.',
        confirmLabel: 'Finalizar Viaje',
        cancelLabel: 'Cancelar',
        onConfirm: () {},
        onCancel: () {},
      ),
    );

    if (confirmed != true || !mounted) return;

    // Cambiar estado a "finalizado"
    await ref
        .read(homeDashboardViewModelProvider.notifier)
        .updateTripStatus(trip.id, TripStatus.completed);

    if (mounted) {
      DesignSnackbar.showSuccess(
          context, '¡Viaje finalizado con éxito!');
      // Regresar al Dashboard
      context.pop();
    }
  }


  Widget _buildCategoryBadge(String category, bool isDark) {
    Color bgColor;
    Color textColor;

    switch (category) {
      case 'Miski Mayo':
        bgColor = isDark ? const Color(0xFF065F46) : const Color(0xFFD1FAE5);
        textColor = isDark ? const Color(0xFF34D399) : const Color(0xFF065F46);
        break;
      case 'Contratista':
        bgColor = isDark ? const Color(0xFF7C2D12) : const Color(0xFFFFEDD5);
        textColor = isDark ? const Color(0xFFFDBA74) : const Color(0xFF7C2D12);
        break;
      case 'Terceros':
        bgColor = isDark ? const Color(0xFF581C87) : const Color(0xFFF3E8FF);
        textColor = isDark ? const Color(0xFFC084FC) : const Color(0xFF581C87);
        break;
      case 'Visita':
        bgColor = isDark ? const Color(0xFF1E3A8A) : const Color(0xFFDBEAFE);
        textColor = isDark ? const Color(0xFF60A5FA) : const Color(0xFF1E3A8A);
        break;
      default:
        bgColor = isDark ? const Color(0xFF2D2D2D) : const Color(0xFFECECEC);
        textColor = isDark ? DesignColors.textSecondaryDark : DesignColors.textSecondaryLight;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        category,
        style: DesignTypography.caption.copyWith(
          color: textColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
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
      // ── Botón fijo de control de viaje ─────────────────────────────────────
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: DesignButton.primary(
            text: trip!.status == TripStatus.travelling ? 'Finalizar Viaje' : 'Iniciar Viaje',
            onTap: _isRegistering ? null : () {
              if (trip!.status == TripStatus.travelling) {
                _finalizarViaje(trip);
              } else {
                _iniciarViaje(trip);
              }
            },
            icon: trip.status == TripStatus.travelling
                ? Icons.check_circle_rounded
                : Icons.directions_bus_filled_rounded,
            fullWidth: true,
          ),
        ),
      ),
      body: Column(
        children: [
          const ConnectivityBar(),
          Expanded(
            child: ListView(
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
                    DesignBadge(
                      label: trip.status == TripStatus.travelling ? 'En tránsito' : 'En curso',
                      color: trip.status == TripStatus.travelling ? colors.success : colors.info,
                    ),
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

          DesignSpacing.spacerV16,

          // ── Opción 3: Pasajeros a Bordo ───────────────────────────────────
          DesignCard.basic(
            onTap: () {
              setState(() {
                _isPassengersListVisible = !_isPassengersListVisible;
              });
            },
            child: Row(
              children: [
                Container(
                  padding: DesignSpacing.allS,
                  decoration: BoxDecoration(
                    color: colors.success.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.people_alt_rounded,
                      size: 32, color: colors.success),
                ),
                DesignSpacing.spacerH16,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Pasajeros a bordo',
                        style: DesignTypography.titleMedium.copyWith(
                          fontWeight: FontWeight.bold,
                          color: isDark
                              ? DesignColors.textPrimaryDark
                              : DesignColors.textPrimaryLight,
                        ),
                      ),
                      DesignSpacing.spacerV4,
                      Text(
                        'Visualiza la lista de pasajeros registrados en este viaje (${_passengersList.length} pasajeros).',
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
                  _isPassengersListVisible
                      ? Icons.keyboard_arrow_up_rounded
                      : Icons.keyboard_arrow_down_rounded,
                  color: isDark
                      ? DesignColors.textSecondaryDark
                      : DesignColors.textSecondaryLight,
                ),
              ],
            ),
          ),

          // ── Panel con la lista de pasajeros ────────────────────────────────
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 280),
            transitionBuilder: (child, animation) =>
                FadeTransition(opacity: animation, child: child),
            child: _isPassengersListVisible
                ? Padding(
                    key: const ValueKey('passengers_list'),
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Lista de Pasajeros',
                                style: DesignTypography.bodyLarge.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: isDark
                                      ? DesignColors.textPrimaryDark
                                      : DesignColors.textPrimaryLight,
                                ),
                              ),
                              Row(
                                children: [
                                  if (_isLoadingPassengers) ...[
                                    const SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: DesignCircularLoader(),
                                    ),
                                    DesignSpacing.spacerH12,
                                  ],
                                  if (_passengersList.isNotEmpty) ...[
                                    DesignIconButton(
                                      icon: Icons.save_rounded,
                                      color: isDark ? DesignColors.primaryDark : DesignColors.primaryLight,
                                      onTap: _onGuardarLista,
                                      tooltip: 'Guardar lista',
                                    ),
                                    DesignSpacing.spacerH8,
                                  ],
                                  DesignIconButton(
                                    icon: Icons.keyboard_arrow_up_rounded,
                                    onTap: () {
                                      setState(() {
                                        _isPassengersListVisible = false;
                                      });
                                    },
                                    tooltip: 'Ocultar lista',
                                  ),
                                ],
                              ),
                            ],
                          ),
                          DesignSpacing.spacerV12,
                          if (!_isLoadingPassengers && _passengersList.isEmpty)
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 24),
                              child: Center(
                                child: Text(
                                  'Aún no hay pasajeros a bordo.',
                                  style: DesignTypography.bodyMedium.copyWith(
                                    color: isDark
                                        ? DesignColors.textSecondaryDark
                                        : DesignColors.textSecondaryLight,
                                  ),
                                ),
                              ),
                            ),
                          if (_passengersList.isNotEmpty) ...[
                            ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: _passengersList.length,
                              separatorBuilder: (context, index) => const Divider(),
                              itemBuilder: (context, index) {
                                final passenger = _passengersList[index];
                                final timeStr =
                                    '${passenger.boardedAt.hour.toString().padLeft(2, '0')}:${passenger.boardedAt.minute.toString().padLeft(2, '0')}';
                                
                                final isWarning = passenger.status != CollaboratorStatus.ok;
                                String statusLabel = '';
                                if (passenger.status == CollaboratorStatus.vacation) statusLabel = 'Vacaciones';
                                if (passenger.status == CollaboratorStatus.medicalLeave) statusLabel = 'DM';
                                if (passenger.status == CollaboratorStatus.license) statusLabel = 'Licencia';

                                return DesignListTile(
                                  title: passenger.fullName,
                                  subtitle:
                                      'DNI: ${passenger.dni} • Asiento: ${passenger.seatNumber ?? "-"} • $timeStr${isWarning ? ' • [$statusLabel]' : ''}',
                                  leading: CircleAvatar(
                                    backgroundColor: isWarning
                                        ? (isDark ? Colors.amber.shade900.withOpacity(0.4) : Colors.amber.shade100)
                                        : (isDark ? const Color(0xFF2D2D2D) : const Color(0xFFECECEC)),
                                    child: Text(
                                      passenger.seatNumber ?? '${index + 1}',
                                      style: DesignTypography.bodyMedium.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: isWarning
                                            ? (isDark ? Colors.amberAccent : Colors.amber.shade900)
                                            : (isDark ? DesignColors.textPrimaryDark : DesignColors.textPrimaryLight),
                                      ),
                                    ),
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      _buildCategoryBadge(passenger.category, isDark),
                                      DesignSpacing.spacerH8,
                                      if (passenger.registrationMethod.endsWith('_transit')) ...[
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: isDark ? const Color(0xFF1E3A8A) : const Color(0xFFDBEAFE),
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          child: Text(
                                            'P2',
                                            style: DesignTypography.caption.copyWith(
                                              color: isDark ? Colors.blue.shade100 : Colors.blue.shade800,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        DesignSpacing.spacerH8,
                                      ],
                                      if (isWarning) ...[
                                        Icon(
                                          Icons.warning_amber_rounded,
                                          color: isDark ? Colors.amberAccent : Colors.amber.shade900,
                                          size: 20,
                                        ),
                                        DesignSpacing.spacerH8,
                                      ],
                                      Icon(
                                        passenger.registrationMethod.startsWith('qr_scan')
                                            ? Icons.qr_code_scanner_rounded
                                            : Icons.keyboard_rounded,
                                        color: isDark
                                            ? DesignColors.textSecondaryDark
                                            : DesignColors.textSecondaryLight,
                                        size: 20,
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ],
                        ],
                      ),
                    ),
                  )
                : const SizedBox.shrink(key: ValueKey('passengers_hidden')),
          ),

          DesignSpacing.spacerV32,
        ],
      ),
          ),
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
