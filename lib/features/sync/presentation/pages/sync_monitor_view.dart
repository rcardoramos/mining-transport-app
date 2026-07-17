import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mining_transport_app/features/sync/presentation/viewmodels/sync_viewmodel.dart';
import 'package:mining_transport_app/core/sync/sync_queue.dart';
import 'package:mining_transport_app/core/database/app_database.dart';
import 'package:mining_transport_app/shared/design_system/design_system.dart';
import 'package:get_it/get_it.dart';

class SyncMonitorView extends ConsumerStatefulWidget {
  const SyncMonitorView({super.key});

  @override
  ConsumerState<SyncMonitorView> createState() => _SyncMonitorViewState();
}

class _SyncMonitorViewState extends ConsumerState<SyncMonitorView> {
  final SyncQueueManager _queueManager = GetIt.I<SyncQueueManager>();
  List<SyncQueueData> _queueHistory = [];
  bool _isLoadingHistory = false;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    setState(() => _isLoadingHistory = true);
    try {
      final list = await _queueManager.getAllActions();
      setState(() {
        _queueHistory = list;
      });
    } catch (_) {}
    setState(() => _isLoadingHistory = false);
  }

  Future<void> _manualSync() async {
    final notifier = ref.read(syncProvider.notifier);
    if (!ref.read(syncProvider).isOnline) {
      DesignSnackbar.showWarning(context, 'Debes estar Online para sincronizar.');
      return;
    }
    await notifier.syncLocalData();
    await _loadHistory();
    if (mounted) {
      DesignSnackbar.showSuccess(context, 'Sincronización completada.');
    }
  }

  Future<void> _clearQueue() async {
    await _queueManager.clearQueue();
    await _loadHistory();
    if (mounted) {
      DesignSnackbar.showSuccess(context, 'Cola limpiada con éxito.');
    }
  }

  String _getPayloadSummary(String actionType, String payloadJson) {
    try {
      final payload = jsonDecode(payloadJson) as Map<String, dynamic>;
      if (actionType == 'BOARD_PASSENGER') {
        return 'Abordaje - DNI: ${payload['dni']} | Viaje: ${payload['tripId']}';
      } else if (actionType == 'CLOSE_TRIP') {
        return 'Cierre - Viaje: ${payload['tripId']}';
      } else if (actionType == 'COMPLETE_STOP') {
        return 'Paradero - Id: ${payload['stopId']} | Viaje: ${payload['tripId']}';
      }
    } catch (_) {}
    return payloadJson;
  }

  @override
  Widget build(BuildContext context) {
    final syncState = ref.watch(syncProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: DesignAppBar(
        title: 'Monitor de Sincronización',
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: DesignSpacing.allM,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Connectivity status card ─────────────────────────────────────
            Container(
              padding: DesignSpacing.allM,
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E1E24) : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isDark ? DesignColors.borderDark : DesignColors.borderLight,
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.02),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Estado de Conexión',
                            style: DesignTypography.bodyMedium.copyWith(
                              color: isDark ? DesignColors.textSecondaryDark : DesignColors.textSecondaryLight,
                            ),
                          ),
                          DesignSpacing.spacerV4,
                          Row(
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: syncState.isOnline ? const Color(0xFF10B981) : const Color(0xFFF59E0B),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              DesignSpacing.spacerH8,
                              Text(
                                syncState.isOnline ? 'Online (Conectado)' : 'Offline (Desconectado)',
                                style: DesignTypography.titleMedium.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: isDark ? DesignColors.textPrimaryDark : DesignColors.textPrimaryLight,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Switch.adaptive(
                        value: syncState.isOnline,
                        onChanged: (_) {
                          ref.read(syncProvider.notifier).toggleConnectionManual();
                          _loadHistory();
                        },
                        activeColor: const Color(0xFF10B981),
                      ),
                    ],
                  ),
                  DesignSpacing.spacerV16,
                  const DesignDivider(),
                  DesignSpacing.spacerV16,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatColumn('Pendientes', '${syncState.pendingSyncCount}', Colors.amber),
                      _buildStatColumn(
                        'Total Historial',
                        '${_queueHistory.length}',
                        isDark ? DesignColors.textPrimaryDark : DesignColors.textPrimaryLight,
                      ),
                      _buildStatColumn(
                        'Procesando',
                        syncState.isSyncing ? 'SÍ' : 'NO',
                        syncState.isSyncing ? Colors.blue : Colors.grey,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            DesignSpacing.spacerV24,

            // ── Action Buttons ──────────────────────────────────────────────
            Row(
              children: [
                Expanded(
                  child: DesignButton.primary(
                    text: 'Sincronizar Ahora',
                    icon: Icons.sync_rounded,
                    onTap: syncState.isSyncing || syncState.pendingSyncCount == 0 || !syncState.isOnline
                        ? null
                        : _manualSync,
                  ),
                ),
                DesignSpacing.spacerH12,
                Expanded(
                  child: DesignButton.outlined(
                    text: 'Limpiar Cola',
                    icon: Icons.delete_outline_rounded,
                    onTap: _queueHistory.isEmpty ? null : _clearQueue,
                  ),
                ),
              ],
            ),

            DesignSpacing.spacerV24,

            // ── Queue History Title ──────────────────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Cola de Acciones Local',
                  style: DesignTypography.titleMedium.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isDark ? DesignColors.textPrimaryDark : DesignColors.textPrimaryLight,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.refresh_rounded),
                  onPressed: _loadHistory,
                ),
              ],
            ),
            
            DesignSpacing.spacerV12,

            // ── Queue List ──────────────────────────────────────────────────
            if (_isLoadingHistory)
              const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 40.0),
                  child: DesignCircularLoader(),
                ),
              )
            else if (_queueHistory.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 60),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E1E24) : const Color(0xFFFAFAFA),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isDark ? DesignColors.borderDark : DesignColors.borderLight,
                  ),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.folder_open_rounded,
                      size: 48,
                      color: isDark ? DesignColors.textSecondaryDark : DesignColors.textSecondaryLight,
                    ),
                    DesignSpacing.spacerV12,
                    Text(
                      'No hay acciones en el historial de la cola.',
                      style: DesignTypography.bodyMedium.copyWith(
                        color: isDark ? DesignColors.textSecondaryDark : DesignColors.textSecondaryLight,
                      ),
                    ),
                  ],
                ),
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _queueHistory.length,
                separatorBuilder: (context, index) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final item = _queueHistory[index];
                  final payloadText = _getPayloadSummary(item.actionType, item.payloadJson);
                  
                  Color statusColor = Colors.grey;
                  if (item.status == 'Synced') statusColor = const Color(0xFF10B981);
                  if (item.status == 'Pending') statusColor = Colors.amber;
                  if (item.status == 'Error') statusColor = Colors.red;

                  return DesignListTile(
                    title: item.actionType,
                    subtitleWidget: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          payloadText,
                          style: DesignTypography.bodyMedium.copyWith(
                            fontWeight: FontWeight.w600,
                            color: isDark ? DesignColors.textPrimaryDark : DesignColors.textPrimaryLight,
                          ),
                        ),
                        DesignSpacing.spacerV4,
                        Text(
                          'Intentos: ${item.attempts} • Creado: ${item.createdAt.toLocal().toString().split('.').first}',
                          style: DesignTypography.caption.copyWith(
                            color: isDark ? DesignColors.textSecondaryDark : DesignColors.textSecondaryLight,
                          ),
                        ),
                        if (item.errorDetails != null) ...[
                          DesignSpacing.spacerV4,
                          Text(
                            'Error: ${item.errorDetails}',
                            style: DesignTypography.caption.copyWith(
                              color: Colors.redAccent,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ],
                    ),
                    leading: CircleAvatar(
                      backgroundColor: statusColor.withOpacity(0.1),
                      child: Icon(
                        item.status == 'Synced'
                            ? Icons.check_circle_outline_rounded
                            : item.status == 'Pending'
                                ? Icons.hourglass_empty_rounded
                                : Icons.error_outline_rounded,
                        color: statusColor,
                      ),
                    ),
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: statusColor.withOpacity(0.5)),
                      ),
                      child: Text(
                        item.status,
                        style: DesignTypography.caption.copyWith(
                          color: statusColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatColumn(String label, String value, Color color) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      children: [
        Text(
          value,
          style: DesignTypography.titleLarge.copyWith(
            fontWeight: FontWeight.w900,
            color: color,
          ),
        ),
        DesignSpacing.spacerV4,
        Text(
          label,
          style: DesignTypography.caption.copyWith(
            fontWeight: FontWeight.bold,
            color: isDark ? DesignColors.textSecondaryDark : DesignColors.textSecondaryLight,
          ),
        ),
      ],
    );
  }
}
