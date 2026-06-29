import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mining_transport_app/features/auth/presentation/viewmodels/login_viewmodel.dart';
import 'package:mining_transport_app/shared/design_system/design_system.dart';
import '../viewmodels/home_dashboard_viewmodel.dart';
import '../widgets/greeting_header.dart';
import '../widgets/driver_profile_card.dart';
import '../widgets/trip_item_card.dart';
import '../widgets/dashboard_stats_section.dart';
import '../../domain/entities/home_dashboard_data.dart';
import '../../domain/entities/trip_entity.dart';
import '../../domain/entities/driver_entity.dart';

/// Vista principal de Dashboard (Home) del conductor con barra de navegación inferior.
class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  ConsumerState<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentNavigationIndex = 0;

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

  String _getAppBarTitle() {
    switch (_currentNavigationIndex) {
      case 0:
        return 'APP Buses - Miski Mayo';
      case 1:
        return 'Mis Viajes';
      case 2:
        return 'Manifiestos';
      case 3:
        return 'Mi Perfil';
      default:
        return 'APP Buses';
    }
  }

  String _formatTime(DateTime? dateTime) {
    if (dateTime == null) return '--:--';
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(homeDashboardViewModelProvider);

    return Scaffold(
      appBar: DesignAppBar(
        title: _getAppBarTitle(),
        centerTitle: false,
        actions: [
          if (_currentNavigationIndex == 3)
            DesignIconButton(
              icon: Icons.logout_rounded,
              tooltip: 'Cerrar Sesión',
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => DesignDialog(
                    title: 'Cerrar Sesión',
                    content: '¿Estás seguro de que deseas salir de la aplicación?',
                    confirmLabel: 'Cerrar Sesión',
                    cancelLabel: 'Cancelar',
                    onConfirm: () => ref.read(loginViewModelProvider.notifier).logout(),
                  ),
                );
              },
            ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.read(homeDashboardViewModelProvider.notifier).refreshDashboard(),
        child: Builder(
          builder: (context) {
            if (state.isLoading) {
              return _buildSkeletonLoader();
            }

            if (state.errorMessage != null && state.data == null) {
              return DesignErrorState(
                title: 'Error de Conexión',
                description: state.errorMessage!,
                onRetry: () => ref.read(homeDashboardViewModelProvider.notifier).loadDashboard(),
              );
            }

            final data = state.data;
            if (data == null) {
              return const DesignEmptyState(
                title: 'Sin Asignación',
                description: 'No hay datos disponibles para mostrar en tu turno.',
                icon: Icons.info_outline_rounded,
              );
            }

            return _buildActiveTab(data);
          },
        ),
      ),
      bottomNavigationBar: DesignBottomNavigation(
        currentIndex: _currentNavigationIndex,
        onTap: (index) {
          setState(() {
            _currentNavigationIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_bus_rounded),
            label: 'Viajes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment_rounded),
            label: 'Manifiestos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_rounded),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }

  Widget _buildActiveTab(HomeDashboardData data) {
    switch (_currentNavigationIndex) {
      case 0:
        return _buildInicioTab(data);
      case 1:
        return _buildViajesTab(data);
      case 2:
        return _buildManifiestosTab(data);
      case 3:
        return _buildPerfilTab(data);
      default:
        return _buildInicioTab(data);
    }
  }

  Widget _buildInicioTab(HomeDashboardData data) {
    // Regla de Negocio: Verificar si hay algún viaje en curso para deshabilitar aperturas adicionales
    final hasActiveTrip = data.todayTrips.any((t) => t.status == TripStatus.inProgress) ||
        data.pendingTrips.any((t) => t.status == TripStatus.inProgress);

    return NestedScrollView(
      headerSliverBuilder: (context, innerBoxIsScrolled) {
        return [
          SliverPadding(
            padding: DesignSpacing.allM,
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                GreetingHeader(driverName: data.driver.name),
                DesignSpacing.spacerV16,
                DriverProfileCard(driver: data.driver),
                DesignSpacing.spacerV24,
                DashboardStatsSection(summary: data.summary),
                DesignSpacing.spacerV24,
                TabBar(
                  controller: _tabController,
                  labelStyle: DesignTypography.labelLarge.copyWith(fontWeight: FontWeight.bold),
                  unselectedLabelStyle: DesignTypography.labelMedium,
                  tabs: const [
                    Tab(text: 'Viajes de Hoy'),
                    Tab(text: 'Viajes Pendientes'),
                  ],
                ),
              ]),
            ),
          ),
        ];
      },
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildTripList(data.todayTrips, 'No tienes viajes programados para hoy', hasActiveTrip),
          _buildTripList(data.pendingTrips, 'No tienes viajes pendientes programados', hasActiveTrip),
        ],
      ),
    );
  }

  Widget _buildViajesTab(HomeDashboardData data) {
    final allTrips = [...data.todayTrips, ...data.pendingTrips];
    final hasActiveTrip = allTrips.any((t) => t.status == TripStatus.inProgress);

    return ListView.separated(
      padding: DesignSpacing.allM,
      itemCount: allTrips.length,
      separatorBuilder: (context, index) => DesignSpacing.spacerV16,
      itemBuilder: (context, index) {
        final trip = allTrips[index];
        return TripItemCard(
          trip: trip,
          isAperturarDisabled: hasActiveTrip && trip.status != TripStatus.inProgress,
          onStatusChanged: (newStatus) {
            ref.read(homeDashboardViewModelProvider.notifier).updateTripStatus(trip.id, newStatus);
          },
          onContinuarEmbarque: () => _showEmbarqueSimulator(trip),
          onVerResumen: () => _showResumenDialog(trip),
        );
      },
    );
  }

  Widget _buildManifiestosTab(HomeDashboardData data) {
    final completedTrips = [...data.todayTrips, ...data.pendingTrips]
        .where((t) => t.status == TripStatus.completed)
        .toList();

    return ListView(
      padding: DesignSpacing.allM,
      children: [
        const DesignSectionHeader(title: 'Manifiestos de Pasajeros'),
        DesignSpacing.spacerV12,
        if (completedTrips.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 40.0),
            child: DesignEmptyState(
              title: 'Sin Manifiestos',
              description: 'Aún no has completado ningún viaje para generar manifiestos.',
              icon: Icons.assignment_outlined,
            ),
          )
        else
          ...completedTrips.map((trip) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: _buildManifestCard(
                'MAN-${trip.id.replaceAll("TRIP-", "")}',
                trip.route,
                '${trip.passengerCount} Pasajeros registrados',
                'Completado',
                true,
                onTap: () => context.push('/dashboard/manifest/${trip.id}'),
              ),
            );
          }),
      ],
    );
  }

  Widget _buildManifestCard(
    String code,
    String route,
    String passengers,
    String status,
    bool completed, {
    VoidCallback? onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = Theme.of(context).extension<DesignThemeExtension>()!;

    return DesignCard.basic(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                code,
                style: DesignTypography.titleMedium.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isDark ? DesignColors.textPrimaryDark : DesignColors.textPrimaryLight,
                ),
              ),
              DesignSpacing.spacerV4,
              Text(
                route,
                style: DesignTypography.bodyMedium.copyWith(
                  color: isDark ? DesignColors.textPrimaryDark : DesignColors.textPrimaryLight,
                ),
              ),
              DesignSpacing.spacerV4,
              Text(
                passengers,
                style: DesignTypography.caption.copyWith(
                  color: isDark ? DesignColors.textSecondaryDark : DesignColors.textSecondaryLight,
                ),
              ),
            ],
          ),
          DesignBadge(
            label: status,
            color: completed ? colors.success : colors.warning,
          ),
        ],
      ),
    );
  }

  Widget _buildPerfilTab(HomeDashboardData data) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ListView(
      padding: DesignSpacing.allM,
      children: [
        Center(
          child: Column(
            children: [
              DesignAvatar(name: data.driver.name, size: 80),
              DesignSpacing.spacerV16,
              Text(
                data.driver.name,
                style: DesignTypography.titleLarge.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isDark ? DesignColors.textPrimaryDark : DesignColors.textPrimaryLight,
                ),
              ),
              DesignSpacing.spacerV4,
              Text(
                data.driver.code,
                style: DesignTypography.bodyMedium.copyWith(
                  color: isDark ? DesignColors.textSecondaryDark : DesignColors.textSecondaryLight,
                ),
              ),
            ],
          ),
        ),
        DesignSpacing.spacerV24,
        const DesignSectionHeader(title: 'Información del Turno'),
        DesignSpacing.spacerV8,
        DesignCard.basic(
          child: Column(
            children: [
              _buildProfileRow(
                'Estado del Conductor',
                data.driver.status == DriverStatus.active ? 'Activo (En Turno)' : 'Inactivo',
                isDark,
              ),
              const DesignDivider(),
              _buildProfileRow(
                'Viajes completados hoy',
                '${data.summary.completedTrips} viajes',
                isDark,
              ),
              const DesignDivider(),
              _buildProfileRow(
                'Pasajeros transportados',
                '${data.summary.passengersTransported} pasajeros',
                isDark,
              ),
            ],
          ),
        ),
        DesignSpacing.spacerV32,
        DesignButton.secondary(
          text: 'Cerrar Sesión',
          icon: Icons.logout_rounded,
          onTap: () {
            showDialog(
              context: context,
              builder: (context) => DesignDialog(
                title: 'Cerrar Sesión',
                content: '¿Estás seguro de que deseas salir de la aplicación?',
                confirmLabel: 'Cerrar Sesión',
                cancelLabel: 'Cancelar',
                onConfirm: () => ref.read(loginViewModelProvider.notifier).logout(),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildProfileRow(String label, String value, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: DesignTypography.bodyMedium.copyWith(
              color: isDark ? DesignColors.textPrimaryDark : DesignColors.textPrimaryLight,
            ),
          ),
          Text(
            value,
            style: DesignTypography.bodyMedium.copyWith(
              fontWeight: FontWeight.bold,
              color: isDark ? DesignColors.textPrimaryDark : DesignColors.textPrimaryLight,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTripList(List<dynamic> trips, String emptyText, bool hasActiveTrip) {
    if (trips.isEmpty) {
      return DesignEmptyState(
        title: 'Lista Vacía',
        description: emptyText,
        icon: Icons.calendar_today_rounded,
      );
    }

    return ListView.separated(
      padding: DesignSpacing.allM,
      itemCount: trips.length,
      separatorBuilder: (context, index) => DesignSpacing.spacerV16,
      itemBuilder: (context, index) {
        final trip = trips[index];
        return TripItemCard(
          trip: trip,
          isAperturarDisabled: hasActiveTrip && trip.status != TripStatus.inProgress,
          onStatusChanged: (newStatus) {
            ref.read(homeDashboardViewModelProvider.notifier).updateTripStatus(trip.id, newStatus);
          },
          onContinuarEmbarque: () => _showEmbarqueSimulator(trip),
          onVerResumen: () => _showResumenDialog(trip),
        );
      },
    );
  }

  void _showEmbarqueSimulator(TripEntity trip) {
    context.push('/dashboard/boarding/${trip.id}');
  }

  void _showResumenDialog(TripEntity trip) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Resumen del Viaje',
          style: DesignTypography.titleLarge.copyWith(
            color: isDark ? DesignColors.textPrimaryDark : DesignColors.textPrimaryLight,
          ),
        ),
        content: Text(
          'Detalles del Servicio Finalizado:\n\n'
          '• Ruta: ${trip.route}\n'
          '• Hora Prog: ${_formatTime(trip.scheduledTime)}\n'
          '• Hora Inicio: ${_formatTime(trip.startedAt)}\n'
          '• Pasajeros Transportados: ${trip.passengerCount} / ${trip.capacity}\n'
          '• Bus Asignado: ${trip.unitCode}\n\n'
          'Los datos se encuentran sincronizados y guardados en almacenamiento local.',
          style: DesignTypography.bodyMedium.copyWith(
            color: isDark ? DesignColors.textSecondaryDark : DesignColors.textSecondaryLight,
          ),
        ),
        backgroundColor: isDark ? DesignColors.surfaceDark : DesignColors.surfaceLight,
        shape: RoundedRectangleBorder(borderRadius: DesignRadius.allLarge),
        actionsPadding: const EdgeInsets.all(16),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.push('/dashboard/manifest/${trip.id}');
            },
            child: Text(
              'Ver Manifiesto',
              style: DesignTypography.labelLarge.copyWith(
                color: isDark ? DesignColors.primaryDark : DesignColors.primaryLight,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: isDark ? DesignColors.primaryDark : DesignColors.primaryLight,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: DesignRadius.allMedium),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            ),
            child: Text(
              'Aceptar',
              style: DesignTypography.labelLarge.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkeletonLoader() {
    return ListView(
      padding: DesignSpacing.allM,
      children: [
        const DesignSkeletonLoader(width: 200, height: 28),
        DesignSpacing.spacerV8,
        const DesignSkeletonLoader(width: 120, height: 16),
        DesignSpacing.spacerV24,
        const DesignSkeletonLoader(height: 100),
        DesignSpacing.spacerV24,
        const DesignSkeletonLoader(height: 120),
        DesignSpacing.spacerV24,
        const DesignSkeletonLoader(height: 80),
      ],
    );
  }
}
