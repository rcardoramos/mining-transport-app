import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mining_transport_app/features/home/domain/entities/trip_entity.dart';
import 'package:mining_transport_app/shared/design_system/design_system.dart';
import 'package:mining_transport_app/core/utils/date_formatter.dart';
import '../viewmodels/trip_viewmodel.dart';
import '../widgets/trip_open_dialog.dart';
import '../widgets/trip_close_dialog.dart';

/// Pantalla principal de gestión de viajes.
/// Muestra en tabs los viajes de Hoy y los viajes Pendientes.
class TripListView extends ConsumerStatefulWidget {
  const TripListView({super.key});

  @override
  ConsumerState<TripListView> createState() => _TripListViewState();
}

class _TripListViewState extends ConsumerState<TripListView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // ── Apertura ───────────────────────────────────────────────────────────────

  Future<void> _handleOpenTrip(TripEntity trip) async {
    final km = await showDialog<int>(
      context: context,
      barrierDismissible: false,
      builder: (_) => TripOpenDialog(
        tripRoute: trip.route,
        unitCode: trip.unitCode,
      ),
    );

    if (km == null || !mounted) return;

    final success = await ref.read(tripViewModelProvider.notifier).openTrip(
          tripId: trip.id,
          startKm: km,
        );

    if (!mounted) return;
    if (success) {
      DesignSnackbar.showSuccess(context, 'Viaje aperturado correctamente.');
    } else {
      final error = ref.read(tripViewModelProvider).errorMessage;
      DesignSnackbar.showError(context, error ?? 'Error al aperturar el viaje');
    }
  }

  // ── Cierre ─────────────────────────────────────────────────────────────────

  Future<void> _handleCloseTrip(TripEntity trip) async {
    final state = ref.read(tripViewModelProvider);
    final km = await showDialog<int>(
      context: context,
      barrierDismissible: false,
      builder: (_) => TripCloseDialog(
        trip: trip,
        startKm: state.activeStartKm,
      ),
    );

    if (km == null || !mounted) return;

    final success = await ref.read(tripViewModelProvider.notifier).closeTrip(
          tripId: trip.id,
          endKm: km,
        );

    if (!mounted) return;
    if (success) {
      DesignSnackbar.showSuccess(context, 'Viaje cerrado exitosamente.');
    } else {
      final error = ref.read(tripViewModelProvider).errorMessage;
      DesignSnackbar.showError(context, error ?? 'Error al cerrar el viaje');
    }
  }

  // ── Embarque ───────────────────────────────────────────────────────────────

  void _handleEmbarque(TripEntity trip) {
    context.push('/dashboard/boarding/${trip.id}');
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(tripViewModelProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (state.isLoading) {
      return _buildSkeletonLoader();
    }

    if (state.errorMessage != null &&
        state.todayTrips.isEmpty &&
        state.pendingTrips.isEmpty) {
      return DesignErrorState(
        title: 'Error al cargar viajes',
        description: state.errorMessage!,
        onRetry: () => ref.read(tripViewModelProvider.notifier).loadTrips(),
      );
    }

    return NestedScrollView(
      headerSliverBuilder: (context, innerBoxIsScrolled) => [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          sliver: SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header de estado activo
                if (state.hasActiveTrip) _buildActiveTripBanner(state.activeTrip!, isDark),
                if (state.hasActiveTrip) DesignSpacing.spacerV16,

                // Tab selector
                Container(
                  decoration: BoxDecoration(
                    color: isDark ? DesignColors.surfaceDark : const Color(0xFFF3F4F6),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.all(4),
                  child: TabBar(
                    controller: _tabController,
                    labelColor: Colors.white,
                    unselectedLabelColor:
                        isDark ? DesignColors.textSecondaryDark : DesignColors.textSecondaryLight,
                    labelStyle: DesignTypography.labelLarge.copyWith(fontWeight: FontWeight.bold),
                    unselectedLabelStyle: DesignTypography.labelMedium,
                    indicatorSize: TabBarIndicatorSize.tab,
                    dividerColor: Colors.transparent,
                    indicator: BoxDecoration(
                      color: isDark ? DesignColors.primaryDark : DesignColors.primaryLight,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    tabs: [
                      Tab(text: 'Hoy (${state.todayTrips.length})'),
                      Tab(text: 'Pendientes (${state.pendingTrips.length})'),
                    ],
                  ),
                ),
                DesignSpacing.spacerV4,
              ],
            ),
          ),
        ),
      ],
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildTripList(state.todayTrips, 'No tienes viajes programados para hoy',
              state.hasActiveTrip, isDark),
          _buildTripList(state.pendingTrips, 'No tienes viajes pendientes',
              state.hasActiveTrip, isDark),
        ],
      ),
    );
  }

  Widget _buildActiveTripBanner(TripEntity trip, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            (isDark ? DesignColors.primaryDark : DesignColors.primaryLight),
            (isDark ? DesignColors.primaryDark : DesignColors.primaryLight).withValues(alpha: 0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.directions_bus_rounded, color: Colors.white, size: 22),
          ),
          DesignSpacing.spacerH12,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Viaje en curso',
                  style: DesignTypography.caption.copyWith(
                    color: Colors.white70,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  trip.route,
                  style: DesignTypography.bodyMedium.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          DesignSpacing.spacerH8,
          Text(
            '${trip.passengerCount}/${trip.capacity}',
            style: DesignTypography.titleMedium.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTripList(
    List<TripEntity> trips,
    String emptyText,
    bool hasActiveTrip,
    bool isDark,
  ) {
    if (trips.isEmpty) {
      return Center(
        child: Padding(
          padding: DesignSpacing.allM,
          child: DesignEmptyState(
            title: 'Lista Vacía',
            description: emptyText,
            icon: Icons.calendar_today_rounded,
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => ref.read(tripViewModelProvider.notifier).refreshTrips(),
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        itemCount: trips.length,
        separatorBuilder: (context, index) => DesignSpacing.spacerV16,
        itemBuilder: (context, index) {
          final trip = trips[index];
          return _buildTripCard(trip, hasActiveTrip, isDark);
        },
      ),
    );
  }

  Widget _buildTripCard(TripEntity trip, bool hasActiveTrip, bool isDark) {
    final isTripActive = trip.status == TripStatus.inProgress ||
        trip.status == TripStatus.travelling;
    final isAperturarEnabled = !hasActiveTrip &&
        (trip.status == TripStatus.scheduled ||
            trip.status == TripStatus.readyToStart);

    Color statusColor = _getStatusColor(trip.status, isDark);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: isTripActive
          ? BoxDecoration(
              borderRadius: DesignRadius.allCard,
              boxShadow: [
                BoxShadow(
                  color: (isDark ? DesignColors.primaryDark : DesignColors.primaryLight)
                      .withValues(alpha: 0.15),
                  blurRadius: 16,
                  spreadRadius: 2,
                  offset: const Offset(0, 4),
                ),
              ],
            )
          : null,
      child: DesignCard.status(
        statusColor: isTripActive
            ? (isDark ? DesignColors.primaryDark : DesignColors.primaryLight)
            : statusColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: ruta + badge
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
                DesignSpacing.spacerH8,
                DesignBadge(
                  label: _getStatusText(trip.status),
                  color: statusColor,
                ),
              ],
            ),
            DesignSpacing.spacerV12,

            // Info rápida
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildInfoCell(
                    Icons.access_time_outlined,
                    'Hora',
                    PeruDateFormatter.formatTime(trip.scheduledTime),
                    isDark),
                _buildInfoCell(
                    Icons.wb_sunny_outlined, 'Turno', trip.shift, isDark),
                _buildInfoCell(
                    Icons.directions_bus_outlined, 'Bus', trip.unitCode, isDark),
                _buildInfoCell(Icons.people_alt_outlined, 'Cap.',
                    '${trip.capacity}', isDark),
              ],
            ),

            // Barra de progreso en viaje activo
            if (isTripActive) ...[
              DesignSpacing.spacerV16,
              const DesignDivider(),
              DesignSpacing.spacerV12,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildInfoCell(
                      Icons.play_circle_outline_rounded,
                      'Inicio',
                      PeruDateFormatter.formatTime(trip.startedAt),
                      isDark),
                  _buildInfoCell(
                      Icons.people_outline_rounded,
                      'Pasajeros',
                      '${trip.passengerCount} / ${trip.capacity}',
                      isDark),
                ],
              ),
              DesignSpacing.spacerV12,
              _buildProgressBar(
                trip.passengerCount / trip.capacity,
                isDark ? DesignColors.primaryDark : DesignColors.primaryLight,
                isDark,
              ),
            ],

            // Botones de acción
            if (trip.status != TripStatus.cancelled) ...[
              DesignSpacing.spacerV16,
              _buildActionButtons(trip, isAperturarEnabled, isTripActive),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(
      TripEntity trip, bool isAperturarEnabled, bool isTripActive) {
    final state = ref.watch(tripViewModelProvider);
    final isLoading = state.isActionLoading;

    if (trip.status == TripStatus.scheduled || trip.status == TripStatus.readyToStart) {
      return DesignButton.primary(
        text: 'Aperturar Viaje',
        icon: Icons.play_arrow_rounded,
        isLoading: isLoading,
        onTap: isAperturarEnabled ? () => _handleOpenTrip(trip) : null,
        fullWidth: true,
      );
    }

    if (isTripActive) {
      return Row(
        children: [
          Expanded(
            child: DesignButton.primary(
              text: 'Embarque',
              icon: Icons.qr_code_scanner_rounded,
              onTap: () => _handleEmbarque(trip),
              fullWidth: true,
            ),
          ),
          DesignSpacing.spacerH12,
          Expanded(
            child: DesignButton.danger(
              text: 'Cerrar',
              icon: Icons.stop_circle_outlined,
              isLoading: isLoading,
              onTap: () => _handleCloseTrip(trip),
              fullWidth: true,
            ),
          ),
        ],
      );
    }

    if (trip.status == TripStatus.completed || trip.status == TripStatus.travelling) {
      return DesignButton.outlined(
        text: 'Ver Resumen',
        icon: Icons.assignment_turned_in_outlined,
        onTap: () => context.push('/dashboard/manifest/${trip.id}'),
        fullWidth: true,
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildInfoCell(IconData icon, String label, String value, bool isDark) {
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
            color: isDark ? DesignColors.textPrimaryDark : DesignColors.textPrimaryLight,
          ),
        ),
      ],
    );
  }

  Widget _buildProgressBar(double pct, Color color, bool isDark) {
    final safe = pct.clamp(0.0, 1.0);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Ocupación',
              style: DesignTypography.caption.copyWith(
                color: isDark ? DesignColors.textSecondaryDark : DesignColors.textSecondaryLight,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '${(safe * 100).toInt()}%',
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
            value: safe,
            backgroundColor: isDark ? const Color(0xFF2C2C2C) : const Color(0xFFE5E7EB),
            color: safe >= 0.9 ? DesignColors.dangerLight : color,
            minHeight: 8,
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(TripStatus status, bool isDark) {
    switch (status) {
      case TripStatus.scheduled:
      case TripStatus.readyToStart:
        return isDark ? DesignColors.warningDark : DesignColors.warningLight;
      case TripStatus.inProgress:
        return isDark ? DesignColors.infoDark : DesignColors.infoLight;
      case TripStatus.travelling:
        return isDark ? DesignColors.successDark : DesignColors.successLight;
      case TripStatus.completed:
        return isDark ? DesignColors.successDark : DesignColors.successLight;
      case TripStatus.cancelled:
        return isDark ? DesignColors.dangerDark : DesignColors.dangerLight;
    }
  }

  String _getStatusText(TripStatus status) {
    switch (status) {
      case TripStatus.scheduled:
      case TripStatus.readyToStart:
        return 'Por iniciar';
      case TripStatus.inProgress:
        return 'Embarque activo';
      case TripStatus.travelling:
        return 'En tránsito';
      case TripStatus.completed:
        return 'Finalizado';
      case TripStatus.cancelled:
        return 'Cancelado';
    }
  }

  Widget _buildSkeletonLoader() {
    return ListView(
      padding: DesignSpacing.allM,
      children: [
        const DesignSkeletonLoader(height: 80),
        DesignSpacing.spacerV16,
        const DesignSkeletonLoader(height: 48),
        DesignSpacing.spacerV16,
        const DesignSkeletonLoader(height: 140),
        DesignSpacing.spacerV16,
        const DesignSkeletonLoader(height: 140),
      ],
    );
  }
}
