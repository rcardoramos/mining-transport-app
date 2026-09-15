import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mining_transport_app/features/catalog/domain/entities/catalog_entities.dart';
import 'package:mining_transport_app/features/home/presentation/viewmodels/create_trip_viewmodel.dart';
import 'package:mining_transport_app/features/home/presentation/viewmodels/home_dashboard_viewmodel.dart';
import 'package:mining_transport_app/shared/design_system/design_system.dart';

/// Abre el bottom sheet de creación de viaje.
/// Retorna `true` si se creó un viaje exitosamente.
Future<bool?> showCreateTripBottomSheet(BuildContext context) {
  return showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) => const CreateTripBottomSheet(),
  );
}

class CreateTripBottomSheet extends ConsumerStatefulWidget {
  const CreateTripBottomSheet({super.key});

  @override
  ConsumerState<CreateTripBottomSheet> createState() =>
      _CreateTripBottomSheetState();
}

class _CreateTripBottomSheetState extends ConsumerState<CreateTripBottomSheet> {
  /// Incrementa al scrollear el formulario para cerrar desplegables abiertos.
  final ValueNotifier<int> _collapseMenus = ValueNotifier<int>(0);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(createTripViewModelProvider.notifier).load();
    });
  }

  @override
  void dispose() {
    _collapseMenus.dispose();
    super.dispose();
  }

  Future<bool> _onWillPop() async {
    final state = ref.read(createTripViewModelProvider);
    if (!state.isDirty || state.phase == CreateTripPhase.creating) {
      return true;
    }
    final discard = await showDialog<bool>(
      context: context,
      builder: (ctx) => DesignDialog(
        title: '¿Descartar viaje?',
        content: 'Los datos seleccionados no se guardarán.',
        confirmLabel: 'Descartar',
        cancelLabel: 'Continuar editando',
        onConfirm: () {},
        onCancel: () {},
      ),
    );
    return discard == true;
  }

  String _formatServiceDate(DateTime d) {
    final dd = d.day.toString().padLeft(2, '0');
    final mm = d.month.toString().padLeft(2, '0');
    final yyyy = d.year.toString();
    return 'Hoy · $dd/$mm/$yyyy';
  }

  Future<void> _submit() async {
    final notifier = ref.read(createTripViewModelProvider.notifier);
    final ok = await notifier.submit();
    if (!mounted) return;
    if (ok) {
      final preview =
          ref.read(createTripViewModelProvider).buildLocalTripPreview();
      await ref.read(homeDashboardViewModelProvider.notifier).refreshDashboard();
      if (preview != null) {
        ref
            .read(homeDashboardViewModelProvider.notifier)
            .ensureCreatedTripVisible(preview);
      }
      if (!mounted) return;
      DesignSnackbar.showSuccess(context, 'Viaje creado correctamente');
      Navigator.of(context).pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(createTripViewModelProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;
    final height = MediaQuery.sizeOf(context).height * 0.92;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final allow = await _onWillPop();
        if (allow && context.mounted) {
          Navigator.of(context).pop(result);
        }
      },
      child: Padding(
        padding: EdgeInsets.only(bottom: bottomInset),
        child: Container(
          height: height,
          decoration: BoxDecoration(
            color: isDark ? DesignColors.surfaceDark : DesignColors.surfaceLight,
            borderRadius: BorderRadius.vertical(top: DesignRadius.radiusLarge),
          ),
          child: Column(
            children: [
              DesignSpacing.spacerV12,
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: isDark ? Colors.white24 : Colors.black12,
                  borderRadius: DesignRadius.allCircular,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 8, 8),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Crear viaje',
                            style: DesignTypography.titleMedium.copyWith(
                              color: isDark
                                  ? DesignColors.textPrimaryDark
                                  : DesignColors.textPrimaryLight,
                            ),
                          ),
                          DesignSpacing.spacerV4,
                          Text(
                            'Complete la información del servicio y del vehículo.',
                            style: DesignTypography.caption.copyWith(
                              color: isDark
                                  ? DesignColors.textSecondaryDark
                                  : DesignColors.textSecondaryLight,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      tooltip: 'Cerrar',
                      icon: const Icon(Icons.close_rounded),
                      onPressed: () async {
                        final allow = await _onWillPop();
                        if (allow && context.mounted) {
                          Navigator.of(context).pop();
                        }
                      },
                    ),
                  ],
                ),
              ),
              Divider(
                height: 1,
                color: isDark ? DesignColors.borderDark : DesignColors.borderLight,
              ),
              Expanded(child: _buildBody(state, isDark)),
              SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                  child: DesignButton.primary(
                    text: 'Crear Viaje',
                    isLoading: state.phase == CreateTripPhase.creating,
                    onTap: state.isFormValid &&
                            state.phase != CreateTripPhase.offline
                        ? _submit
                        : null,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody(CreateTripState state, bool isDark) {
    if (state.phase == CreateTripPhase.loadingCatalogs ||
        state.phase == CreateTripPhase.initial) {
      return ListView(
        padding: DesignSpacing.allM,
        children: const [
          DesignSkeletonLoader(height: 56),
          SizedBox(height: 12),
          DesignSkeletonLoader(height: 40),
          SizedBox(height: 12),
          DesignSkeletonLoader(height: 40),
          SizedBox(height: 12),
          DesignSkeletonLoader(height: 56),
          SizedBox(height: 12),
          DesignSkeletonLoader(height: 56),
          SizedBox(height: 12),
          DesignSkeletonLoader(height: 56),
        ],
      );
    }

    if (state.phase == CreateTripPhase.error && state.catalogs == null) {
      return DesignErrorState(
        title: 'Error al cargar catálogos',
        description: state.errorMessage ?? 'Inténtelo nuevamente.',
        onRetry: () => ref.read(createTripViewModelProvider.notifier).load(),
      );
    }

    final catalogs = state.catalogs;
    if (catalogs == null) {
      return DesignErrorState(
        title: 'Sin catálogos',
        description: state.errorMessage ?? 'No hay datos disponibles.',
        onRetry: () => ref.read(createTripViewModelProvider.notifier).load(),
      );
    }

    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        // depth == 0: scroll del formulario; >0: scroll interno de un desplegable.
        if (notification.depth != 0) return false;
        final isUserDrag = (notification is ScrollUpdateNotification &&
                notification.dragDetails != null) ||
            (notification is ScrollStartNotification &&
                notification.dragDetails != null);
        if (isUserDrag) {
          _collapseMenus.value++;
        }
        return false;
      },
      child: ListView(
      padding: DesignSpacing.allM,
      children: [
        if (state.errorMessage != null) ...[
          _ErrorBanner(
            message: state.errorMessage!,
            onRetry: state.phase == CreateTripPhase.offline ||
                    state.phase == CreateTripPhase.error
                ? () => ref.read(createTripViewModelProvider.notifier).load()
                : null,
          ),
          DesignSpacing.spacerV16,
        ],
        Text(
          'Datos del servicio',
          style: DesignTypography.labelLarge.copyWith(
            color: isDark
                ? DesignColors.textPrimaryDark
                : DesignColors.textPrimaryLight,
          ),
        ),
        DesignSpacing.spacerV12,
        _RouteDropdown(
          routes: catalogs.routes,
          selectedRouteId: state.selectedRouteId,
          collapseListenable: _collapseMenus,
          onSelected: (id) =>
              ref.read(createTripViewModelProvider.notifier).selectRoute(id),
        ),
        DesignSpacing.spacerV16,
        Text(
          'Servicio',
          style: DesignTypography.labelMedium.copyWith(
            color: isDark
                ? DesignColors.textSecondaryDark
                : DesignColors.textSecondaryLight,
          ),
        ),
        DesignSpacing.spacerV8,
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: catalogs.services.map((s) {
            final selected = state.selectedServiceId == s.id;
            return GestureDetector(
              onTap: () => ref
                  .read(createTripViewModelProvider.notifier)
                  .selectService(s.id),
              child: DesignChip(label: s.name, selected: selected),
            );
          }).toList(),
        ),
        DesignSpacing.spacerV16,
        Text(
          'Horario',
          style: DesignTypography.labelMedium.copyWith(
            color: isDark
                ? DesignColors.textSecondaryDark
                : DesignColors.textSecondaryLight,
          ),
        ),
        DesignSpacing.spacerV8,
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: catalogs.schedules.map((s) {
            final selected = state.selectedScheduleId == s.id;
            return GestureDetector(
              onTap: () => ref
                  .read(createTripViewModelProvider.notifier)
                  .selectSchedule(s.id),
              child: DesignChip(label: s.displayLabel, selected: selected),
            );
          }).toList(),
        ),
        DesignSpacing.spacerV16,
        _ReadonlyField(
          label: 'Fecha',
          value: _formatServiceDate(state.serviceDate),
        ),
        if (state.requiresManualStopSelection) ...[
          DesignSpacing.spacerV24,
          Text(
            'Paraderos',
            style: DesignTypography.labelLarge.copyWith(
              color: isDark
                  ? DesignColors.textPrimaryDark
                  : DesignColors.textPrimaryLight,
            ),
          ),
          DesignSpacing.spacerV8,
          Text(
            'El catálogo no asocia paraderos a la ruta. Seleccione uno o más paraderos en el orden mostrado (orden del backend).',
            style: DesignTypography.caption.copyWith(
              color: isDark
                  ? DesignColors.textSecondaryDark
                  : DesignColors.textSecondaryLight,
            ),
          ),
          DesignSpacing.spacerV12,
          _StopDropdown(
            stops: state.availableStops,
            selectedStopIds: state.selectedStopIds,
            collapseListenable: _collapseMenus,
            onToggle: (id) =>
                ref.read(createTripViewModelProvider.notifier).selectStop(id),
          ),
        ] else if (state.linkedStopsForRoute.isNotEmpty) ...[
          DesignSpacing.spacerV24,
          Text(
            'Paraderos de la ruta',
            style: DesignTypography.labelLarge.copyWith(
              color: isDark
                  ? DesignColors.textPrimaryDark
                  : DesignColors.textPrimaryLight,
            ),
          ),
          DesignSpacing.spacerV12,
          ...state.linkedStopsForRoute.map(
            (s) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _ReadonlyField(
                label: 'Paradero ${s.order > 0 ? s.order : ''}'.trim(),
                value: s.name,
              ),
            ),
          ),
        ],
        DesignSpacing.spacerV24,
        Text(
          'Datos del bus',
          style: DesignTypography.labelLarge.copyWith(
            color: isDark
                ? DesignColors.textPrimaryDark
                : DesignColors.textPrimaryLight,
          ),
        ),
        DesignSpacing.spacerV12,
        _BusDropdown(
          buses: catalogs.buses,
          selectedBusId: state.selectedBusId,
          collapseListenable: _collapseMenus,
          onSelected: (id) =>
              ref.read(createTripViewModelProvider.notifier).selectBus(id),
        ),
        DesignSpacing.spacerV12,
        _ReadonlyField(
          label: 'Modelo',
          value: (state.selectedBus?.model ?? '').isEmpty
              ? '—'
              : state.selectedBus!.model,
        ),
        DesignSpacing.spacerV12,
        _ReadonlyField(
          label: 'Capacidad',
          value: state.selectedBus != null
              ? '${state.selectedBus!.capacity}'
              : '—',
        ),
        DesignSpacing.spacerV24,
        Text(
          'Chofer',
          style: DesignTypography.labelLarge.copyWith(
            color: isDark
                ? DesignColors.textPrimaryDark
                : DesignColors.textPrimaryLight,
          ),
        ),
        DesignSpacing.spacerV12,
        _ReadonlyField(
          label: 'Conductor',
          value: state.driverDisplayLabel,
        ),
        DesignSpacing.spacerV24,
      ],
      ),
    );
  }
}

class _BusDropdown extends StatefulWidget {
  const _BusDropdown({
    required this.buses,
    required this.selectedBusId,
    required this.onSelected,
    this.collapseListenable,
  });

  final List<CatalogBus> buses;
  final int? selectedBusId;
  final ValueChanged<int> onSelected;
  final Listenable? collapseListenable;

  @override
  State<_BusDropdown> createState() => _BusDropdownState();
}

class _BusDropdownState extends State<_BusDropdown> {
  bool _expanded = false;

  static const Color _selectedBgLight = Color(0xFFE6F4EF);
  static const Color _selectedBgDark = Color(0xFF1A2E28);
  static const Color _selectedAccent = DesignColors.successLight;
  static const double _menuMaxHeight = 220;

  @override
  void initState() {
    super.initState();
    widget.collapseListenable?.addListener(_collapse);
  }

  @override
  void didUpdateWidget(covariant _BusDropdown oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.collapseListenable != widget.collapseListenable) {
      oldWidget.collapseListenable?.removeListener(_collapse);
      widget.collapseListenable?.addListener(_collapse);
    }
  }

  @override
  void dispose() {
    widget.collapseListenable?.removeListener(_collapse);
    super.dispose();
  }

  void _collapse() {
    if (!_expanded || !mounted) return;
    setState(() => _expanded = false);
  }

  CatalogBus? get _selected {
    final id = widget.selectedBusId;
    if (id == null) return null;
    return widget.buses.where((b) => b.id == id).firstOrNull;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final borderColor =
        isDark ? DesignColors.borderDark : DesignColors.borderLight;
    final unselectedIcon = isDark
        ? DesignColors.textSecondaryDark
        : DesignColors.textSecondaryLight;
    final textColor = isDark
        ? DesignColors.textPrimaryDark
        : DesignColors.textPrimaryLight;
    final selected = _selected;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Material(
          color: isDark ? const Color(0xFF1E1E24) : Colors.white,
          borderRadius: DesignRadius.allMedium,
          child: InkWell(
            borderRadius: DesignRadius.allMedium,
            onTap: () => setState(() => _expanded = !_expanded),
            child: InputDecorator(
              isFocused: _expanded,
              decoration: InputDecoration(
                labelText: 'Placa',
                filled: true,
                fillColor: isDark ? const Color(0xFF1E1E24) : Colors.white,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                border: OutlineInputBorder(
                  borderRadius: DesignRadius.allMedium,
                  borderSide: BorderSide(color: borderColor, width: 1.5),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: DesignRadius.allMedium,
                  borderSide: BorderSide(color: borderColor, width: 1.5),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: DesignRadius.allMedium,
                  borderSide: BorderSide(
                    color: isDark
                        ? DesignColors.primaryDark
                        : DesignColors.primaryLight,
                    width: 2,
                  ),
                ),
                suffixIcon: Icon(
                  _expanded
                      ? Icons.keyboard_arrow_up_rounded
                      : Icons.keyboard_arrow_down_rounded,
                  color: unselectedIcon,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.directions_bus_rounded,
                    size: 18,
                    color: selected != null ? _selectedAccent : unselectedIcon,
                  ),
                  DesignSpacing.spacerH12,
                  Expanded(
                    child: Text(
                      selected?.plate ?? 'Seleccione la placa',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: DesignTypography.caption.copyWith(
                        fontSize: 12.5,
                        fontWeight:
                            selected != null ? FontWeight.w600 : FontWeight.w500,
                        color: selected != null ? textColor : unselectedIcon,
                        height: 1.25,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (_expanded) ...[
          DesignSpacing.spacerV8,
          Container(
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E1E24) : const Color(0xFFF7F9F9),
              borderRadius: DesignRadius.allMedium,
              border: Border.all(color: borderColor),
            ),
            clipBehavior: Clip.antiAlias,
            constraints: const BoxConstraints(maxHeight: _menuMaxHeight),
            child: ListView.separated(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              itemCount: widget.buses.length,
              separatorBuilder: (_, _) =>
                  Divider(height: 1, thickness: 1, color: borderColor),
              itemBuilder: (context, i) {
                final bus = widget.buses[i];
                final isSelected = widget.selectedBusId == bus.id;
                return _SingleSelectTile(
                  label: bus.plate,
                  icon: Icons.directions_bus_rounded,
                  selected: isSelected,
                  selectedBg: isDark ? _selectedBgDark : _selectedBgLight,
                  selectedAccent: _selectedAccent,
                  unselectedIcon: unselectedIcon,
                  textColor: textColor,
                  onTap: () {
                    widget.onSelected(bus.id);
                    setState(() => _expanded = false);
                  },
                );
              },
            ),
          ),
        ],
      ],
    );
  }
}

class _RouteDropdown extends StatefulWidget {
  const _RouteDropdown({
    required this.routes,
    required this.selectedRouteId,
    required this.onSelected,
    this.collapseListenable,
  });

  final List<CatalogRoute> routes;
  final int? selectedRouteId;
  final ValueChanged<int> onSelected;
  final Listenable? collapseListenable;

  @override
  State<_RouteDropdown> createState() => _RouteDropdownState();
}

class _RouteDropdownState extends State<_RouteDropdown> {
  bool _expanded = false;

  static const Color _selectedBgLight = Color(0xFFE6F4EF);
  static const Color _selectedBgDark = Color(0xFF1A2E28);
  static const Color _selectedAccent = DesignColors.successLight;
  static const double _menuMaxHeight = 220;

  @override
  void initState() {
    super.initState();
    widget.collapseListenable?.addListener(_collapse);
  }

  @override
  void didUpdateWidget(covariant _RouteDropdown oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.collapseListenable != widget.collapseListenable) {
      oldWidget.collapseListenable?.removeListener(_collapse);
      widget.collapseListenable?.addListener(_collapse);
    }
  }

  @override
  void dispose() {
    widget.collapseListenable?.removeListener(_collapse);
    super.dispose();
  }

  void _collapse() {
    if (!_expanded || !mounted) return;
    setState(() => _expanded = false);
  }

  CatalogRoute? get _selected {
    final id = widget.selectedRouteId;
    if (id == null) return null;
    return widget.routes.where((r) => r.id == id).firstOrNull;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final borderColor =
        isDark ? DesignColors.borderDark : DesignColors.borderLight;
    final unselectedIcon = isDark
        ? DesignColors.textSecondaryDark
        : DesignColors.textSecondaryLight;
    final textColor = isDark
        ? DesignColors.textPrimaryDark
        : DesignColors.textPrimaryLight;
    final selected = _selected;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Material(
          color: isDark ? const Color(0xFF1E1E24) : Colors.white,
          borderRadius: DesignRadius.allMedium,
          child: InkWell(
            borderRadius: DesignRadius.allMedium,
            onTap: () => setState(() => _expanded = !_expanded),
            child: InputDecorator(
              isFocused: _expanded,
              decoration: InputDecoration(
                labelText: 'Ruta',
                filled: true,
                fillColor: isDark ? const Color(0xFF1E1E24) : Colors.white,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                border: OutlineInputBorder(
                  borderRadius: DesignRadius.allMedium,
                  borderSide: BorderSide(color: borderColor, width: 1.5),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: DesignRadius.allMedium,
                  borderSide: BorderSide(color: borderColor, width: 1.5),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: DesignRadius.allMedium,
                  borderSide: BorderSide(
                    color: isDark
                        ? DesignColors.primaryDark
                        : DesignColors.primaryLight,
                    width: 2,
                  ),
                ),
                suffixIcon: Icon(
                  _expanded
                      ? Icons.keyboard_arrow_up_rounded
                      : Icons.keyboard_arrow_down_rounded,
                  color: unselectedIcon,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.route_rounded,
                    size: 18,
                    color: selected != null ? _selectedAccent : unselectedIcon,
                  ),
                  DesignSpacing.spacerH12,
                  Expanded(
                    child: Text(
                      selected?.displayLabel ?? 'Seleccione la ruta',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: DesignTypography.caption.copyWith(
                        fontSize: 12.5,
                        fontWeight:
                            selected != null ? FontWeight.w600 : FontWeight.w500,
                        color: selected != null ? textColor : unselectedIcon,
                        height: 1.25,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (_expanded) ...[
          DesignSpacing.spacerV8,
          Container(
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E1E24) : const Color(0xFFF7F9F9),
              borderRadius: DesignRadius.allMedium,
              border: Border.all(color: borderColor),
            ),
            clipBehavior: Clip.antiAlias,
            constraints: const BoxConstraints(maxHeight: _menuMaxHeight),
            child: ListView.separated(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              itemCount: widget.routes.length,
              separatorBuilder: (_, _) =>
                  Divider(height: 1, thickness: 1, color: borderColor),
              itemBuilder: (context, i) {
                final route = widget.routes[i];
                final isSelected = widget.selectedRouteId == route.id;
                return _SingleSelectTile(
                  label: route.displayLabel,
                  icon: Icons.route_rounded,
                  selected: isSelected,
                  selectedBg: isDark ? _selectedBgDark : _selectedBgLight,
                  selectedAccent: _selectedAccent,
                  unselectedIcon: unselectedIcon,
                  textColor: textColor,
                  onTap: () {
                    widget.onSelected(route.id);
                    setState(() => _expanded = false);
                  },
                );
              },
            ),
          ),
        ],
      ],
    );
  }
}

class _SingleSelectTile extends StatelessWidget {
  const _SingleSelectTile({
    required this.label,
    required this.icon,
    required this.selected,
    required this.selectedBg,
    required this.selectedAccent,
    required this.unselectedIcon,
    required this.textColor,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final Color selectedBg;
  final Color selectedAccent;
  final Color unselectedIcon;
  final Color textColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? selectedBg : Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              Icon(
                icon,
                size: 18,
                color: selected ? selectedAccent : unselectedIcon,
              ),
              DesignSpacing.spacerH12,
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: DesignTypography.caption.copyWith(
                    fontSize: 12.5,
                    fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                    color: textColor,
                    height: 1.25,
                  ),
                ),
              ),
              DesignSpacing.spacerH8,
              AnimatedContainer(
                duration: const Duration(milliseconds: 160),
                width: 22,
                height: 22,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: selected ? selectedAccent : Colors.transparent,
                  border: Border.all(
                    color: selected ? selectedAccent : unselectedIcon,
                    width: 1.6,
                  ),
                ),
                child: selected
                    ? const Icon(Icons.check_rounded, size: 14, color: Colors.white)
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StopDropdown extends StatefulWidget {
  const _StopDropdown({
    required this.stops,
    required this.selectedStopIds,
    required this.onToggle,
    this.collapseListenable,
  });

  final List<CatalogStop> stops;
  final List<int> selectedStopIds;
  final ValueChanged<int> onToggle;
  final Listenable? collapseListenable;

  @override
  State<_StopDropdown> createState() => _StopDropdownState();
}

class _StopDropdownState extends State<_StopDropdown> {
  bool _expanded = false;

  static const Color _selectedBgLight = Color(0xFFE6F4EF);
  static const Color _selectedBgDark = Color(0xFF1A2E28);
  static const Color _selectedAccent = DesignColors.successLight;
  static const double _menuMaxHeight = 220;

  @override
  void initState() {
    super.initState();
    widget.collapseListenable?.addListener(_collapse);
  }

  @override
  void didUpdateWidget(covariant _StopDropdown oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.collapseListenable != widget.collapseListenable) {
      oldWidget.collapseListenable?.removeListener(_collapse);
      widget.collapseListenable?.addListener(_collapse);
    }
  }

  @override
  void dispose() {
    widget.collapseListenable?.removeListener(_collapse);
    super.dispose();
  }

  void _collapse() {
    if (!_expanded || !mounted) return;
    setState(() => _expanded = false);
  }

  int? _orderOf(int stopId) {
    final index = widget.selectedStopIds.indexOf(stopId);
    return index < 0 ? null : index + 1;
  }

  String get _summary {
    // El detalle vive en los chips; el campo actúa como disparador.
    return 'Seleccione los paraderos';
  }

  List<({int id, String name, int order})> get _selectedChips {
    final byId = {for (final s in widget.stops) s.id: s};
    final chips = <({int id, String name, int order})>[];
    for (var i = 0; i < widget.selectedStopIds.length; i++) {
      final id = widget.selectedStopIds[i];
      final stop = byId[id];
      if (stop == null) continue;
      chips.add((id: id, name: stop.name, order: i + 1));
    }
    return chips;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final borderColor =
        isDark ? DesignColors.borderDark : DesignColors.borderLight;
    final unselectedIcon = isDark
        ? DesignColors.textSecondaryDark
        : DesignColors.textSecondaryLight;
    final textColor = isDark
        ? DesignColors.textPrimaryDark
        : DesignColors.textPrimaryLight;
    final chips = _selectedChips;
    final hasSelection = chips.isNotEmpty;
    final chipBg = isDark ? _selectedBgDark : _selectedBgLight;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Material(
          color: isDark ? const Color(0xFF1E1E24) : const Color(0xFFF7F9F9),
          borderRadius: DesignRadius.allMedium,
          child: InkWell(
            borderRadius: DesignRadius.allMedium,
            onTap: () => setState(() => _expanded = !_expanded),
            child: InputDecorator(
              isFocused: _expanded,
              decoration: InputDecoration(
                labelText: 'Paraderos',
                filled: true,
                fillColor:
                    isDark ? const Color(0xFF1E1E24) : const Color(0xFFF7F9F9),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                border: OutlineInputBorder(
                  borderRadius: DesignRadius.allMedium,
                  borderSide: BorderSide(color: borderColor, width: 1.5),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: DesignRadius.allMedium,
                  borderSide: BorderSide(color: borderColor, width: 1.5),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: DesignRadius.allMedium,
                  borderSide: BorderSide(
                    color: isDark
                        ? DesignColors.primaryDark
                        : DesignColors.primaryLight,
                    width: 2,
                  ),
                ),
                suffixIcon: Icon(
                  _expanded
                      ? Icons.keyboard_arrow_up_rounded
                      : Icons.keyboard_arrow_down_rounded,
                  color: unselectedIcon,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.location_on_rounded,
                    size: 18,
                    color: hasSelection ? _selectedAccent : unselectedIcon,
                  ),
                  DesignSpacing.spacerH12,
                  Expanded(
                    child: Text(
                      hasSelection
                          ? '${chips.length} seleccionado${chips.length == 1 ? '' : 's'}'
                          : _summary,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: DesignTypography.caption.copyWith(
                        fontSize: 12.5,
                        fontWeight:
                            hasSelection ? FontWeight.w600 : FontWeight.w500,
                        color: hasSelection ? textColor : unselectedIcon,
                        height: 1.25,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (_expanded) ...[
          DesignSpacing.spacerV8,
          Container(
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E1E24) : const Color(0xFFF7F9F9),
              borderRadius: DesignRadius.allMedium,
              border: Border.all(color: borderColor),
            ),
            clipBehavior: Clip.antiAlias,
            constraints: const BoxConstraints(maxHeight: _menuMaxHeight),
            child: ListView.separated(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              itemCount: widget.stops.length,
              separatorBuilder: (_, _) =>
                  Divider(height: 1, thickness: 1, color: borderColor),
              itemBuilder: (context, i) {
                final stop = widget.stops[i];
                final order = _orderOf(stop.id);
                final isSelected = order != null;
                return _StopSelectionTile(
                  name: stop.name,
                  order: order,
                  selected: isSelected,
                  selectedBg:
                      isDark ? _selectedBgDark : _selectedBgLight,
                  selectedAccent: _selectedAccent,
                  unselectedIcon: unselectedIcon,
                  textColor: textColor,
                  onTap: () => widget.onToggle(stop.id),
                );
              },
            ),
          ),
        ],
        if (hasSelection) ...[
          DesignSpacing.spacerV8,
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final chip in chips)
                _SelectedStopChip(
                  order: chip.order,
                  name: chip.name,
                  background: chipBg,
                  accent: _selectedAccent,
                  textColor: textColor,
                  onRemove: () => widget.onToggle(chip.id),
                ),
            ],
          ),
        ],
      ],
    );
  }
}

class _SelectedStopChip extends StatelessWidget {
  const _SelectedStopChip({
    required this.order,
    required this.name,
    required this.background,
    required this.accent,
    required this.textColor,
    required this.onRemove,
  });

  final int order;
  final String name;
  final Color background;
  final Color accent;
  final Color textColor;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: background,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 6, 6, 6),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.location_on_rounded, size: 14, color: accent),
            const SizedBox(width: 4),
            Text(
              '$order',
              style: DesignTypography.caption.copyWith(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: accent,
                height: 1,
              ),
            ),
            const SizedBox(width: 4),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 140),
              child: Text(
                name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: DesignTypography.caption.copyWith(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                  height: 1.2,
                ),
              ),
            ),
            const SizedBox(width: 2),
            InkWell(
              onTap: onRemove,
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: Icon(Icons.close_rounded, size: 14, color: accent),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StopSelectionTile extends StatelessWidget {
  const _StopSelectionTile({
    required this.name,
    required this.order,
    required this.selected,
    required this.selectedBg,
    required this.selectedAccent,
    required this.unselectedIcon,
    required this.textColor,
    required this.onTap,
  });

  final String name;
  final int? order;
  final bool selected;
  final Color selectedBg;
  final Color selectedAccent;
  final Color unselectedIcon;
  final Color textColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? selectedBg : Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              Icon(
                Icons.location_on_rounded,
                size: 18,
                color: selected ? selectedAccent : unselectedIcon,
              ),
              DesignSpacing.spacerH12,
              Expanded(
                child: Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: DesignTypography.caption.copyWith(
                    fontSize: 12.5,
                    fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                    color: textColor,
                    height: 1.25,
                  ),
                ),
              ),
              DesignSpacing.spacerH8,
              AnimatedContainer(
                duration: const Duration(milliseconds: 160),
                width: 22,
                height: 22,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: selected ? selectedAccent : Colors.transparent,
                  border: Border.all(
                    color: selected ? selectedAccent : unselectedIcon,
                    width: 1.6,
                  ),
                ),
                child: selected
                    ? Text(
                        '$order',
                        style: DesignTypography.caption.copyWith(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          height: 1,
                        ),
                      )
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ReadonlyField extends StatelessWidget {
  const _ReadonlyField({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return InputDecorator(
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: isDark ? const Color(0xFF1E1E24) : const Color(0xFFF3F4F6),
        border: OutlineInputBorder(borderRadius: DesignRadius.allMedium),
        enabled: false,
      ),
      child: Text(
        value,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: DesignTypography.bodyLarge.copyWith(
          color: isDark
              ? DesignColors.textPrimaryDark
              : DesignColors.textPrimaryLight,
        ),
      ),
    );
  }
}

class _ErrorBanner extends StatelessWidget {
  const _ErrorBanner({required this.message, this.onRetry});

  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: DesignColors.dangerLight.withValues(alpha: 0.12),
        borderRadius: DesignRadius.allMedium,
        border: Border.all(color: DesignColors.dangerLight.withValues(alpha: 0.35)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            message,
            style: DesignTypography.caption.copyWith(
              color: isDark
                  ? DesignColors.textPrimaryDark
                  : DesignColors.textPrimaryLight,
            ),
          ),
          if (onRetry != null) ...[
            DesignSpacing.spacerV8,
            DesignButton.text(
              text: 'Reintentar',
              onTap: onRetry,
              fullWidth: false,
            ),
          ],
        ],
      ),
    );
  }
}
