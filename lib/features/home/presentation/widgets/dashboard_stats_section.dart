import 'package:flutter/material.dart';
import 'package:mining_transport_app/shared/design_system/design_system.dart';
import '../../domain/entities/dashboard_summary_entity.dart';

/// Grid de indicadores ejecutivos que muestra estadísticas clave en tarjetas elevadas.
class DashboardStatsSection extends StatelessWidget {
  final DashboardSummaryEntity summary;

  const DashboardStatsSection({
    super.key,
    required this.summary,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = Theme.of(context).extension<DesignThemeExtension>()!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const DesignSectionHeader(title: 'Resumen de Indicadores'),
        DesignSpacing.spacerV8,
        GridView.count(
          crossAxisCount: 3,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.85,
          children: [
            _buildStatCard(
              context,
              '${summary.completedTrips}',
              'Viajes Concluidos',
              Icons.directions_bus_rounded,
              colors.success,
              isDark,
            ),
            _buildStatCard(
              context,
              '${summary.passengersTransported}',
              'Pasajeros',
              Icons.people_rounded,
              colors.info,
              isDark,
            ),
            _buildStatCard(
              context,
              '${summary.observationsRegistered}',
              'Reportes / Obs.',
              Icons.assignment_late_rounded,
              colors.danger,
              isDark,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String value,
    String label,
    IconData icon,
    Color iconColor,
    bool isDark,
  ) {
    return DesignCard.elevated(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: iconColor,
            size: 24,
          ),
          DesignSpacing.spacerV8,
          Text(
            value,
            style: DesignTypography.titleLarge.copyWith(
              fontWeight: FontWeight.w900,
              color: isDark ? DesignColors.textPrimaryDark : DesignColors.textPrimaryLight,
            ),
          ),
          DesignSpacing.spacerV4,
          Text(
            label,
            style: DesignTypography.caption.copyWith(
              color: isDark ? DesignColors.textSecondaryDark : DesignColors.textSecondaryLight,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
