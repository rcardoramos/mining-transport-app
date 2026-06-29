import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mining_transport_app/core/utils/sync_provider.dart';
import 'package:mining_transport_app/shared/design_system/design_system.dart';

/// Barra de estado de conectividad con soporte para sincronización local.
class ConnectivityBar extends ConsumerWidget {
  const ConnectivityBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final syncState = ref.watch(syncProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Colores basados en el estado de conexión
    final bgColor = isDark 
        ? const Color(0xFF1E1E24) 
        : const Color(0xFFF5F5F7);
    
    final textColor = syncState.isOnline
        ? (isDark ? const Color(0xFF34D399) : const Color(0xFF059669))
        : (isDark ? const Color(0xFFFBBF24) : const Color(0xFFD97706));

    final iconColor = syncState.isOnline
        ? (isDark ? const Color(0xFF10B981) : const Color(0xFF10B981))
        : (isDark ? const Color(0xFFEF4444) : const Color(0xFFEF4444));

    final dotColor = syncState.isOnline
        ? const Color(0xFF10B981)
        : const Color(0xFFF59E0B);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: bgColor,
        border: Border(
          bottom: BorderSide(
            color: isDark ? const Color(0xFF2D2D35) : const Color(0xFFE5E5EA),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          // Dot indicador animado / resplandeciente
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: dotColor,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: dotColor.withOpacity(0.4),
                  blurRadius: 4,
                  spreadRadius: 1,
                ),
              ],
            ),
          ),
          DesignSpacing.spacerH12,
          
          // Icono nube online/offline
          Icon(
            syncState.isOnline ? Icons.cloud_done_rounded : Icons.cloud_off_rounded,
            color: iconColor,
            size: 16,
          ),
          DesignSpacing.spacerH8,
          
          // Texto interactivo de estado de conexión
          GestureDetector(
            onTap: () {
              ref.read(syncProvider.notifier).toggleConnectionManual();
              DesignSnackbar.showSuccess(
                context,
                'Modo alternado a: ${ref.read(syncProvider).isOnline ? "Online" : "Offline"}',
              );
            },
            child: Text(
              syncState.isOnline ? 'Online • Sincronizado' : 'Offline • Datos locales',
              style: DesignTypography.bodyMedium.copyWith(
                color: textColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          
          const Spacer(),
          
          // Sección de botón de pendientes
          if (syncState.pendingSyncCount > 0)
            InkWell(
              onTap: syncState.isSyncing
                  ? null
                  : () async {
                      if (!syncState.isOnline) {
                        DesignSnackbar.showWarning(
                          context,
                          'No hay conexión para realizar la sincronización.',
                        );
                        return;
                      }
                      
                      await ref.read(syncProvider.notifier).syncLocalData();
                      if (context.mounted) {
                        DesignSnackbar.showSuccess(
                          context,
                          'Sincronización completada con éxito.',
                        );
                      }
                    },
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                decoration: BoxDecoration(
                  color: syncState.isOnline
                      ? (isDark ? const Color(0xFF1E3A8A).withOpacity(0.2) : const Color(0xFFDBEAFE))
                      : (isDark ? const Color(0xFF451A03).withOpacity(0.2) : const Color(0xFFFFEDD5)),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: syncState.isOnline
                        ? const Color(0xFF3B82F6)
                        : const Color(0xFFF59E0B),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (syncState.isSyncing)
                      const SizedBox(
                        width: 12,
                        height: 12,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF3B82F6)),
                        ),
                      )
                    else
                      Icon(
                        Icons.sync_rounded,
                        size: 14,
                        color: syncState.isOnline
                            ? const Color(0xFF60A5FA)
                            : const Color(0xFFF59E0B),
                      ),
                    DesignSpacing.spacerH8,
                    Text(
                      '${syncState.pendingSyncCount} pend.',
                      style: DesignTypography.labelMedium.copyWith(
                        fontWeight: FontWeight.bold,
                        color: syncState.isOnline
                            ? const Color(0xFF60A5FA)
                            : const Color(0xFFF59E0B),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
