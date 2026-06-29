import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:get_it/get_it.dart';
import 'package:mining_transport_app/shared/design_system/design_system.dart';
import 'package:mining_transport_app/core/utils/date_formatter.dart';
import '../viewmodels/home_dashboard_viewmodel.dart';
import '../../domain/entities/trip_entity.dart';
import '../../domain/entities/passenger_entity.dart';
import '../../domain/entities/collaborator_entity.dart';
import '../../domain/usecases/get_passengers_on_board_usecase.dart';

/// Vista de Detalle de Manifiesto de Pasajeros para un Viaje Finalizado.
class ManifestDetailView extends ConsumerStatefulWidget {
  final String tripId;

  const ManifestDetailView({super.key, required this.tripId});

  @override
  ConsumerState<ManifestDetailView> createState() => _ManifestDetailViewState();
}

class _ManifestDetailViewState extends ConsumerState<ManifestDetailView> {
  List<PassengerEntity> _passengersList = [];
  bool _isLoadingPassengers = false;

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

  String _formatTime(DateTime? dateTime) {
    return PeruDateFormatter.formatTime(dateTime);
  }

  String _formatTime12(DateTime? dateTime) {
    return PeruDateFormatter.formatTime12(dateTime);
  }

  String _formatDate(DateTime? dateTime) {
    return PeruDateFormatter.formatDate(dateTime);
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

  void _exportManifest() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? DesignColors.surfaceDark : DesignColors.surfaceLight,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Compartir Manifiesto',
                      style: DesignTypography.titleMedium.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isDark ? DesignColors.textPrimaryDark : DesignColors.textPrimaryLight,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                DesignSpacing.spacerV12,
                DesignListTile(
                  title: 'Guardar en el dispositivo',
                  subtitle: 'Descarga y guarda el documento PDF localmente',
                  leading: const Icon(Icons.download_rounded, color: Colors.blue),
                  onTap: () {
                    Navigator.pop(context);
                    DesignSnackbar.showSuccess(context, 'Manifiesto guardado en el dispositivo.');
                  },
                ),
                const Divider(),
                DesignListTile(
                  title: 'Compartir por WhatsApp',
                  subtitle: 'Envía el PDF directamente a un chat o grupo',
                  leading: const Icon(Icons.chat_bubble_outline_rounded, color: Colors.green),
                  onTap: () {
                    Navigator.pop(context);
                    DesignSnackbar.showSuccess(context, 'Manifiesto compartido por WhatsApp exitosamente.');
                  },
                ),
                const Divider(),
                DesignListTile(
                  title: 'Enviar por Correo Electrónico',
                  subtitle: 'Envía el archivo PDF adjunto a un destinatario',
                  leading: const Icon(Icons.email_outlined, color: Colors.redAccent),
                  onTap: () {
                    Navigator.pop(context);
                    DesignSnackbar.showSuccess(context, 'Manifiesto enviado por correo electrónico.');
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = Theme.of(context).extension<DesignThemeExtension>()!;

    // Obtener los datos del viaje desde el viewmodel
    final state = ref.watch(homeDashboardViewModelProvider);
    final data = state.data;

    TripEntity? trip;
    if (data != null) {
      final all = [...data.todayTrips, ...data.pendingTrips];
      try {
        trip = all.firstWhere((t) => t.id == widget.tripId);
      } catch (_) {}
    }

    final driverName = data?.driver.name ?? 'Ricardo Ramos';

    if (trip == null) {
      return Scaffold(
        appBar: DesignAppBar(
          title: 'Manifiesto',
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
            onPressed: () => context.pop(),
          ),
        ),
        body: const DesignEmptyState(
          title: 'Viaje no encontrado',
          description: 'No se pudieron recuperar los detalles de este manifiesto.',
          icon: Icons.assignment_late_outlined,
        ),
      );
    }

    return Scaffold(
      appBar: DesignAppBar(
        title: 'Manifiesto de Viaje',
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: _isLoadingPassengers
          ? const Center(child: DesignCircularLoader())
          : SingleChildScrollView(
              padding: DesignSpacing.allM,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Document Header (Faux Print Document) ──────────────────────
                  Container(
                    width: double.infinity,
                    padding: DesignSpacing.allM,
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isDark ? DesignColors.borderDark : DesignColors.borderLight,
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Text(
                          'COMPAÑÍA MINERA MISKI MAYO',
                          style: DesignTypography.bodyLarge.copyWith(
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.2,
                            color: isDark ? DesignColors.textPrimaryDark : DesignColors.textPrimaryLight,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        DesignSpacing.spacerV4,
                        Text(
                          'MANIFIESTO DE PASAJEROS',
                          style: DesignTypography.titleMedium.copyWith(
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.8,
                            color: Theme.of(context).primaryColor,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        DesignSpacing.spacerV16,
                        const DesignDivider(),
                        DesignSpacing.spacerV16,
                        
                        // Metadata Grid
                        Table(
                          columnWidths: const {
                            0: FlexColumnWidth(1.2),
                            1: FlexColumnWidth(1.8),
                          },
                          children: [
                            _buildTableRow('Ruta:', trip.route, isDark),
                            _buildTableRow('Fecha:', _formatDate(trip.scheduledTime), isDark),
                            _buildTableRow('Servicio:', 'Operativo', isDark),
                            _buildTableRow('Horario:', '${trip.shift} ${_formatTime(trip.scheduledTime)}', isDark),
                            _buildTableRow('Placa:', trip.unitCode, isDark),
                            _buildTableRow('Capacidad:', '${trip.passengerCount} de ${trip.capacity} pax', isDark),
                            _buildTableRow('Chofer:', driverName, isDark),
                            _buildTableRow('Apertura:', _formatTime12(trip.startedAt), isDark),
                            _buildTableRow('Cierre:', _formatTime12(trip.completedAt), isDark),
                          ],
                        ),
                      ],
                    ),
                  ),

                  DesignSpacing.spacerV24,

                  // ── Passengers Section Title ─────────────────────────────────
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Pasajeros Registrados',
                        style: DesignTypography.titleMedium.copyWith(
                          fontWeight: FontWeight.bold,
                          color: isDark ? DesignColors.textPrimaryDark : DesignColors.textPrimaryLight,
                        ),
                      ),
                      DesignBadge(
                        label: '${_passengersList.length} PASAJEROS',
                        color: colors.success,
                      ),
                    ],
                  ),
                  
                  DesignSpacing.spacerV12,

                  // ── Passenger List ──────────────────────────────────────────
                  if (_passengersList.isEmpty)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 40),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF1E1E1E) : const Color(0xFFFAFAFA),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isDark ? DesignColors.borderDark : DesignColors.borderLight,
                        ),
                      ),
                      child: Center(
                        child: Column(
                          children: [
                            Icon(
                              Icons.people_outline_rounded,
                              size: 48,
                              color: isDark ? DesignColors.textSecondaryDark : DesignColors.textSecondaryLight,
                            ),
                            DesignSpacing.spacerV12,
                            Text(
                              'No se registraron pasajeros en este viaje.',
                              style: DesignTypography.bodyMedium.copyWith(
                                color: isDark ? DesignColors.textSecondaryDark : DesignColors.textSecondaryLight,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _passengersList.length,
                      separatorBuilder: (context, index) => const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final passenger = _passengersList[index];
                        final timeStr = _formatTime(passenger.boardedAt);
                        final isWarning = passenger.status != CollaboratorStatus.ok;
                        
                        String statusLabel = '';
                        if (passenger.status == CollaboratorStatus.vacation) statusLabel = 'Vacaciones';
                        if (passenger.status == CollaboratorStatus.medicalLeave) statusLabel = 'DM';
                        if (passenger.status == CollaboratorStatus.license) statusLabel = 'Licencia';

                        return DesignListTile(
                          title: passenger.fullName,
                          subtitle: 'DNI: ${passenger.dni} • Asiento: ${passenger.seatNumber ?? "-"} • $timeStr${isWarning ? ' • [$statusLabel]' : ''}',
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
                    
                  DesignSpacing.spacerV32,
                  
                  // simulated export footer
                  Center(
                    child: DesignButton.outlined(
                      text: 'Exportar Manifiesto',
                      icon: Icons.download_rounded,
                      onTap: _exportManifest,
                      fullWidth: false,
                    ),
                  ),
                  DesignSpacing.spacerV16,
                ],
              ),
            ),
    );
  }

  TableRow _buildTableRow(String label, String value, bool isDark) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6.0),
          child: Text(
            label,
            style: DesignTypography.bodyMedium.copyWith(
              fontWeight: FontWeight.bold,
              color: isDark ? DesignColors.textSecondaryDark : DesignColors.textSecondaryLight,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6.0),
          child: Text(
            value,
            style: DesignTypography.bodyMedium.copyWith(
              fontWeight: FontWeight.bold,
              color: isDark ? DesignColors.textPrimaryDark : DesignColors.textPrimaryLight,
            ),
          ),
        ),
      ],
    );
  }
}
