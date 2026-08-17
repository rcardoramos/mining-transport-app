import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(createTripViewModelProvider.notifier).load();
    });
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
    final ok = await ref.read(createTripViewModelProvider.notifier).submit();
    if (!mounted) return;
    if (ok) {
      await ref.read(homeDashboardViewModelProvider.notifier).refreshDashboard();
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

    return ListView(
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
        DesignDropdown<int>(
          labelText: 'Ruta',
          value: state.selectedRouteId,
          items: catalogs.routes
              .map(
                (r) => DropdownMenuItem<int>(
                  value: r.id,
                  child: Text(r.displayLabel),
                ),
              )
              .toList(),
          onChanged: (v) =>
              ref.read(createTripViewModelProvider.notifier).selectRoute(v),
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
        DesignTextField(
          labelText: 'Fecha',
          controller: TextEditingController(
            text:
                _formatServiceDate(state.serviceDate),
          ),
          enabled: false,
        ),
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
        DesignDropdown<int>(
          labelText: 'Placa',
          value: state.selectedBusId,
          items: catalogs.buses
              .map(
                (b) => DropdownMenuItem<int>(
                  value: b.id,
                  child: Text(b.plate),
                ),
              )
              .toList(),
          onChanged: (v) =>
              ref.read(createTripViewModelProvider.notifier).selectBus(v),
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
        DesignTextField(
          labelText: 'Conductor',
          controller: TextEditingController(
            text: state.user == null
                ? ''
                : '${state.user!.fullName} · ${state.user!.username}',
          ),
          enabled: false,
        ),
        DesignSpacing.spacerV24,
      ],
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
