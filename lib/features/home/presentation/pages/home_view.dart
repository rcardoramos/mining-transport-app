import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mining_transport_app/features/auth/presentation/viewmodels/login_viewmodel.dart';
import 'package:mining_transport_app/shared/design_system/design_system.dart';
import 'package:mining_transport_app/core/utils/date_formatter.dart';
import 'package:mining_transport_app/features/sync/presentation/widgets/connectivity_bar.dart';
import '../viewmodels/home_dashboard_viewmodel.dart';
import '../widgets/greeting_header.dart';
import '../widgets/driver_profile_card.dart';
import '../widgets/trip_item_card.dart';
import '../widgets/dashboard_stats_section.dart';
import '../../domain/entities/home_dashboard_data.dart';
import '../../domain/entities/trip_entity.dart';

/// Vista principal de Dashboard (Home) del conductor con barra de navegación inferior.
class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  ConsumerState<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentNavigationIndex = 0;
  DateTime? _selectedCalendarDate;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    final nowUtc = DateTime.now().toUtc();
    final nowPeru = nowUtc.subtract(const Duration(hours: 5));
    _selectedCalendarDate = DateTime(nowPeru.year, nowPeru.month, nowPeru.day);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  String _getAppBarTitle() {
    switch (_currentNavigationIndex) {
      case 0:
        return 'Miski Mayo';
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
    return PeruDateFormatter.formatTime(dateTime);
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
                    content:
                        '¿Estás seguro de que deseas salir de la aplicación?',
                    confirmLabel: 'Cerrar Sesión',
                    cancelLabel: 'Cancelar',
                    onConfirm: () =>
                        ref.read(loginViewModelProvider.notifier).logout(),
                  ),
                );
              },
            ),
        ],
      ),
      body: Column(
        children: [
          const ConnectivityBar(),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () => ref
                  .read(homeDashboardViewModelProvider.notifier)
                  .refreshDashboard(),
              child: Builder(
                builder: (context) {
                  if (state.isLoading) {
                    return _buildSkeletonLoader();
                  }

                  if (state.errorMessage != null && state.data == null) {
                    return DesignErrorState(
                      title: 'Error de Conexión',
                      description: state.errorMessage!,
                      onRetry: () => ref
                          .read(homeDashboardViewModelProvider.notifier)
                          .loadDashboard(),
                    );
                  }

                  final data = state.data;
                  if (data == null) {
                    return const DesignEmptyState(
                      title: 'Sin Asignación',
                      description:
                          'No hay datos disponibles para mostrar en tu turno.',
                      icon: Icons.info_outline_rounded,
                    );
                  }

                  return _buildActiveTab(data);
                },
              ),
            ),
          ),
        ],
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    // Regla de Negocio: Verificar si hay algún viaje en curso para deshabilitar aperturas adicionales
    final hasActiveTrip =
        data.todayTrips.any((t) => t.status == TripStatus.inProgress) ||
        data.pendingTrips.any((t) => t.status == TripStatus.inProgress);
    final allEmpty = data.todayTrips.isEmpty && data.pendingTrips.isEmpty;

    return NestedScrollView(
      physics: allEmpty ? const NeverScrollableScrollPhysics() : null,
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
                TabBar(
                  controller: _tabController,
                  labelColor: isDark
                      ? DesignColors.primaryDark
                      : DesignColors.primaryLight,
                  unselectedLabelColor: isDark
                      ? DesignColors.textSecondaryDark
                      : DesignColors.textSecondaryLight,
                  labelStyle: DesignTypography.labelLarge.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  unselectedLabelStyle: DesignTypography.labelMedium,
                  indicatorSize: TabBarIndicatorSize.tab,
                  dividerColor: Colors.transparent,
                  indicator: BoxDecoration(
                    color:
                        (isDark
                                ? DesignColors.primaryDark
                                : DesignColors.primaryLight)
                            .withOpacity(0.1),
                    borderRadius: BorderRadius.circular(25),
                  ),
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
          _buildTripList(
            data.todayTrips,
            'No tienes viajes programados para hoy',
            hasActiveTrip,
            data.summary,
          ),
          _buildTripList(
            data.pendingTrips,
            'No tienes viajes pendientes programados',
            hasActiveTrip,
            data.summary,
          ),
        ],
      ),
    );
  }

  Widget _buildViajesTab(HomeDashboardData data) {
    final allTrips = [...data.todayTrips, ...data.pendingTrips];
    final hasActiveTrip = allTrips.any(
      (t) => t.status == TripStatus.inProgress,
    );

    if (allTrips.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 40.0),
        child: Center(
          child: DesignEmptyState(
            title: 'Sin Viajes',
            description: 'No tienes viajes programados por el momento.',
            icon: Icons.directions_bus_outlined,
          ),
        ),
      );
    }

    return ListView.separated(
      padding: DesignSpacing.allM,
      itemCount: allTrips.length,
      separatorBuilder: (context, index) => DesignSpacing.spacerV16,
      itemBuilder: (context, index) {
        final trip = allTrips[index];
        return TripItemCard(
          trip: trip,
          isAperturarDisabled:
              hasActiveTrip && trip.status != TripStatus.inProgress,
          onStatusChanged: (newStatus) {
            _handleTripStatusChanged(trip, newStatus);
          },
          onContinuarEmbarque: () => _showEmbarqueSimulator(trip),
          onVerResumen: () => _showResumenDialog(trip),
        );
      },
    );
  }

  Widget _buildManifiestosTab(HomeDashboardData data) {
    final completedTrips = [
      ...data.todayTrips,
      ...data.pendingTrips,
    ].where((t) => t.status == TripStatus.completed).toList();

    if (completedTrips.isEmpty) {
      return Padding(
        padding: DesignSpacing.allM,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const DesignSectionHeader(title: 'Manifiestos de Pasajeros'),
            Expanded(
              child: Center(
                child: const DesignEmptyState(
                  title: 'Sin Manifiestos',
                  description:
                      'Aún no has completado ningún viaje para generar manifiestos.',
                  icon: Icons.assignment_outlined,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return ListView(
      padding: DesignSpacing.allM,
      children: [
        const DesignSectionHeader(title: 'Manifiestos de Pasajeros'),
        DesignSpacing.spacerV12,
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
                  color: isDark
                      ? DesignColors.textPrimaryDark
                      : DesignColors.textPrimaryLight,
                ),
              ),
              DesignSpacing.spacerV4,
              Text(
                route,
                style: DesignTypography.bodyMedium.copyWith(
                  color: isDark
                      ? DesignColors.textPrimaryDark
                      : DesignColors.textPrimaryLight,
                ),
              ),
              DesignSpacing.spacerV4,
              Text(
                passengers,
                style: DesignTypography.caption.copyWith(
                  color: isDark
                      ? DesignColors.textSecondaryDark
                      : DesignColors.textSecondaryLight,
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
                  color: isDark
                      ? DesignColors.textPrimaryDark
                      : DesignColors.textPrimaryLight,
                ),
              ),
              DesignSpacing.spacerV4,
              Text(
                'Misky Mayo • Conductor',
                style: DesignTypography.bodyMedium.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ],
          ),
        ),
        DesignSpacing.spacerV24,

        // Datos Personales
        const DesignSectionHeader(title: 'Datos del Conductor'),
        DesignSpacing.spacerV8,
        DesignCard.basic(
          child: Column(
            children: [
              _buildProfileRow(
                'Código de Trabajador',
                data.driver.code,
                isDark,
              ),
              const DesignDivider(),
              _buildProfileRow('Empresa', 'COMPAÑÍA MINERA MISKI MAYO', isDark),
              const DesignDivider(),
              _buildProfileRow(
                'Correo',
                '${data.driver.name.toLowerCase().replaceAll(' ', '.')}@miskimayo.com',
                isDark,
              ),
              const DesignDivider(),
              _buildProfileRow('Número de Celular', '+51 987 654 321', isDark),
            ],
          ),
        ),

        /*
        DesignSpacing.spacerV24,
        
        // Historial de Turnos con Calendario
        _buildCalendarSection(data, isDark),
        */
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
                onConfirm: () =>
                    ref.read(loginViewModelProvider.notifier).logout(),
              ),
            );
          },
        ),
      ],
    );
  }

  // ignore: unused_element
  Widget _buildCalendarSection(HomeDashboardData data, bool isDark) {
    final nowUtc = DateTime.now().toUtc();
    final nowPeru = nowUtc.subtract(const Duration(hours: 5));
    final today = DateTime(nowPeru.year, nowPeru.month, nowPeru.day);

    // Generar la semana actual de Lunes a Domingo
    final weekDates = List.generate(7, (index) {
      return today.subtract(Duration(days: 6 - index));
    });

    final weekDaysLabels = ['Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb', 'Dom'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const DesignSectionHeader(title: 'Historial de Turnos'),
        DesignSpacing.spacerV8,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(7, (index) {
            final date = weekDates[index];
            final isSelected =
                _selectedCalendarDate != null &&
                _selectedCalendarDate!.year == date.year &&
                _selectedCalendarDate!.month == date.month &&
                _selectedCalendarDate!.day == date.day;

            final dayLabel = weekDaysLabels[index];
            final dayNumber = date.day.toString();

            final selectedBg = Theme.of(context).primaryColor;
            final unselectedBg = isDark
                ? const Color(0xFF2D2D2D)
                : const Color(0xFFF5F5F5);
            final borderColor = isSelected
                ? selectedBg
                : (isDark ? const Color(0xFF3D3D3D) : const Color(0xFFE5E5E5));

            return Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedCalendarDate = date;
                  });
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 2,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? selectedBg.withOpacity(0.12)
                        : unselectedBg,
                    border: Border.all(
                      color: isSelected ? selectedBg : borderColor,
                      width: 1.5,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      Text(
                        dayLabel,
                        style: DesignTypography.caption.copyWith(
                          fontWeight: FontWeight.bold,
                          color: isSelected
                              ? selectedBg
                              : (isDark
                                    ? DesignColors.textSecondaryDark
                                    : DesignColors.textSecondaryLight),
                        ),
                      ),
                      DesignSpacing.spacerV4,
                      Text(
                        dayNumber,
                        style: DesignTypography.bodyMedium.copyWith(
                          fontWeight: FontWeight.bold,
                          color: isSelected
                              ? selectedBg
                              : (isDark
                                    ? DesignColors.textPrimaryDark
                                    : DesignColors.textPrimaryLight),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
        DesignSpacing.spacerV16,
        _buildShiftDetailsCard(data, isDark),
      ],
    );
  }

  Widget _buildShiftDetailsCard(HomeDashboardData data, bool isDark) {
    if (_selectedCalendarDate == null) return const SizedBox.shrink();

    final date = _selectedCalendarDate!;
    String checkIn = '05:30 AM';
    String checkOut = '06:00 PM';
    String completedTrips = '3 viajes';
    String totalPassengers = '110 pasajeros';

    final nowUtc = DateTime.now().toUtc();
    final nowPeru = nowUtc.subtract(const Duration(hours: 5));
    final today = DateTime(nowPeru.year, nowPeru.month, nowPeru.day);

    final isToday =
        date.year == today.year &&
        date.month == today.month &&
        date.day == today.day;

    if (isToday) {
      checkIn = '05:31 AM';
      checkOut = 'En curso';
      completedTrips = '${data.summary.completedTrips} viajes';
      totalPassengers = '${data.summary.passengersTransported} pasajeros';
    } else {
      switch (date.weekday) {
        case DateTime.monday:
          checkIn = '05:30 AM';
          checkOut = '06:10 PM';
          completedTrips = '3 viajes';
          totalPassengers = '105 pasajeros';
          break;
        case DateTime.tuesday:
          checkIn = '05:29 AM';
          checkOut = '06:00 PM';
          completedTrips = '3 viajes';
          totalPassengers = '98 pasajeros';
          break;
        case DateTime.wednesday:
          checkIn = '05:30 AM';
          checkOut = '05:58 PM';
          completedTrips = '4 viajes';
          totalPassengers = '142 pasajeros';
          break;
        case DateTime.thursday:
          checkIn = '05:32 AM';
          checkOut = '06:02 PM';
          completedTrips = '2 viajes';
          totalPassengers = '80 pasajeros';
          break;
        case DateTime.friday:
          checkIn = '05:28 AM';
          checkOut = '06:12 PM';
          completedTrips = '3 viajes';
          totalPassengers = '112 pasajeros';
          break;
        case DateTime.saturday:
          checkIn = '05:30 AM';
          checkOut = '06:05 PM';
          completedTrips = '4 viajes';
          totalPassengers = '135 pasajeros';
          break;
      }
    }

    final dateStr =
        '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';

    return DesignCard.basic(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Detalle del Turno: $dateStr',
                style: DesignTypography.bodyMedium.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isDark
                      ? DesignColors.textPrimaryDark
                      : DesignColors.textPrimaryLight,
                ),
              ),
              if (isToday)
                const DesignBadge(label: 'Activo', color: Colors.blue),
            ],
          ),
          DesignSpacing.spacerV12,
          const DesignDivider(),
          DesignSpacing.spacerV12,
          _buildProfileRow('Hora de Ingreso (Apertura)', checkIn, isDark),
          const DesignDivider(),
          _buildProfileRow('Hora de Salida (Cierre)', checkOut, isDark),
          const DesignDivider(),
          _buildProfileRow('Viajes Completados', completedTrips, isDark),
          const DesignDivider(),
          _buildProfileRow('Pasajeros Transportados', totalPassengers, isDark),
        ],
      ),
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
              color: isDark
                  ? DesignColors.textPrimaryDark
                  : DesignColors.textPrimaryLight,
            ),
          ),
          DesignSpacing.spacerH16,
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: DesignTypography.bodyMedium.copyWith(
                fontWeight: FontWeight.bold,
                color: isDark
                    ? DesignColors.textPrimaryDark
                    : DesignColors.textPrimaryLight,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTripList(
    List<dynamic> trips,
    String emptyText,
    bool hasActiveTrip,
    dynamic summary,
  ) {
    return ListView(
      padding: DesignSpacing.allM,
      physics: trips.isEmpty ? const NeverScrollableScrollPhysics() : null,
      children: [
        if (trips.isEmpty) ...[
          DesignEmptyState(
            title: 'Lista Vacía',
            description: emptyText,
            icon: Icons.calendar_today_rounded,
          ),
        ] else ...[
          ...trips.map((trip) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: TripItemCard(
                trip: trip,
                isAperturarDisabled:
                    hasActiveTrip && trip.status != TripStatus.inProgress,
                onStatusChanged: (newStatus) {
                  _handleTripStatusChanged(trip, newStatus);
                },
                onContinuarEmbarque: () => _showEmbarqueSimulator(trip),
                onVerResumen: () => _showResumenDialog(trip),
              ),
            );
          }),
        ],
        DesignSpacing.spacerV24,
        DashboardStatsSection(summary: summary),
      ],
    );
  }

  void _handleTripStatusChanged(TripEntity trip, TripStatus newStatus) {
    if (newStatus == TripStatus.inProgress) {
      _checkTripTimeAndAperturar(trip);
    } else {
      ref
          .read(homeDashboardViewModelProvider.notifier)
          .updateTripStatus(trip.id, newStatus);
    }
  }

  Future<void> _checkTripTimeAndAperturar(TripEntity trip) async {
    final now = DateTime.now();
    final scheduledUtc = trip.scheduledTime.toUtc();
    final nowUtc = now.toUtc();
    final difference = nowUtc.difference(scheduledUtc).inMinutes;

    if (difference.abs() > 15) {
      final isEarly = difference < 0;
      final diffAbs = difference.abs();
      final hours = diffAbs ~/ 60;
      final minutes = diffAbs % 60;
      final timeStr = hours > 0 ? '$hours h y $minutes min' : '$minutes min';

      final scheduledStr = PeruDateFormatter.formatTime12(trip.scheduledTime);
      final currentStr = PeruDateFormatter.formatTime12(now);

      final confirm = await showDialog<bool>(
        context: context,
        builder: (ctx) => DesignDialog(
          title: 'Aviso de Horario',
          content:
              'El viaje está programado para las $scheduledStr.\n\n'
              'La hora actual es $currentStr (diferencia de $timeStr ${isEarly ? "antes" : "después"} de la hora).\n\n'
              '¿Está seguro de que desea aperturar el viaje fuera del horario programado?',
          confirmLabel: 'Sí, Iniciar',
          cancelLabel: 'Cancelar',
          onConfirm: () {},
          onCancel: () {},
        ),
      );

      if (confirm != true) return;
    }

    if (mounted) {
      ref
          .read(homeDashboardViewModelProvider.notifier)
          .updateTripStatus(trip.id, TripStatus.inProgress);
    }
  }

  void _showEmbarqueSimulator(TripEntity trip) {
    context.push('/dashboard/boarding/${trip.id}');
  }

  void _showResumenDialog(TripEntity trip) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showModalBottomSheet(
      context: context,
      backgroundColor: isDark
          ? DesignColors.surfaceDark
          : DesignColors.surfaceLight,
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
                      'Resumen del Viaje',
                      style: DesignTypography.titleMedium.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isDark
                            ? DesignColors.textPrimaryDark
                            : DesignColors.textPrimaryLight,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                DesignSpacing.spacerV12,
                _buildSummaryRow('Ruta:', trip.route, isDark),
                const Divider(height: 12),
                _buildSummaryRow(
                  'Hora Prog:',
                  _formatTime(trip.scheduledTime),
                  isDark,
                ),
                const Divider(height: 12),
                _buildSummaryRow(
                  'Hora Inicio:',
                  _formatTime(trip.startedAt),
                  isDark,
                ),
                const Divider(height: 12),
                _buildSummaryRow(
                  'Hora Fin:',
                  _formatTime(trip.completedAt),
                  isDark,
                ),
                const Divider(height: 12),
                _buildSummaryRow(
                  'Pasajeros:',
                  '${trip.passengerCount} de ${trip.capacity} pax',
                  isDark,
                ),
                const Divider(height: 12),
                _buildSummaryRow('Bus Asignado:', trip.unitCode, isDark),
                DesignSpacing.spacerV16,
                Text(
                  'Los datos se encuentran sincronizados y guardados en almacenamiento local.',
                  style: DesignTypography.caption.copyWith(
                    color: isDark
                        ? DesignColors.textSecondaryDark
                        : DesignColors.textSecondaryLight,
                  ),
                ),
                DesignSpacing.spacerV20,
                Row(
                  children: [
                    Expanded(
                      child: DesignButton.outlined(
                        text: 'Ver Manifiesto',
                        icon: Icons.assignment_rounded,
                        onTap: () {
                          Navigator.pop(context);
                          context.push('/dashboard/manifest/${trip.id}');
                        },
                        fullWidth: true,
                      ),
                    ),
                    DesignSpacing.spacerH12,
                    Expanded(
                      child: DesignButton.primary(
                        text: 'Aceptar',
                        icon: Icons.check_rounded,
                        onTap: () => Navigator.pop(context),
                        fullWidth: true,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSummaryRow(String label, String value, bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: DesignTypography.bodyMedium.copyWith(
            color: isDark
                ? DesignColors.textSecondaryDark
                : DesignColors.textSecondaryLight,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: DesignTypography.bodyMedium.copyWith(
            color: isDark
                ? DesignColors.textPrimaryDark
                : DesignColors.textPrimaryLight,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
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
