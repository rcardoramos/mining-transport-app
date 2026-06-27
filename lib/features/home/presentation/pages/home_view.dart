import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mining_transport_app/features/auth/presentation/viewmodels/login_viewmodel.dart';
import 'package:mining_transport_app/shared/design_system/design_system.dart';
import '../viewmodels/home_dashboard_viewmodel.dart';
import '../widgets/greeting_header.dart';
import '../widgets/driver_profile_card.dart';
import '../widgets/trip_item_card.dart';
import '../widgets/dashboard_stats_section.dart';

/// Vista principal de Dashboard (Home) del conductor.
class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  ConsumerState<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView> with SingleTickerProviderStateMixin {
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

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(homeDashboardViewModelProvider);

    return Scaffold(
      appBar: DesignAppBar(
        title: 'APP Buses - Miski Mayo',
        centerTitle: false,
        actions: [
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
                  _buildTripList(data.todayTrips, 'No tienes viajes programados para hoy'),
                  _buildTripList(data.pendingTrips, 'No tienes viajes pendientes programados'),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTripList(List<dynamic> trips, String emptyText) {
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
          onStatusChanged: (newStatus) {
            ref.read(homeDashboardViewModelProvider.notifier).updateTripStatus(trip.id, newStatus);
          },
        );
      },
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
