import 'package:flutter/material.dart';
import 'package:mining_transport_app/shared/design_system/design_system.dart';
import 'package:mining_transport_app/core/utils/date_formatter.dart';

/// Cabecera con saludo dinámico y fecha actual formateada en español.
class GreetingHeader extends StatelessWidget {
  final String driverName;

  const GreetingHeader({
    super.key,
    required this.driverName,
  });

  String _getGreeting() {
    final nowPeru = PeruDateFormatter.toPeruTime(DateTime.now());
    final hour = nowPeru.hour;
    if (hour < 12) return 'Buenos días';
    if (hour < 19) return 'Buenas tardes';
    return 'Buenas noches';
  }

  String _formatSpanishDate() {
    final now = PeruDateFormatter.toPeruTime(DateTime.now());
    final weekdays = ['Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes', 'Sábado', 'Domingo'];
    final months = [
      'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio',
      'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'
    ];
    return '${weekdays[now.weekday - 1]}, ${now.day} de ${months[now.month - 1]}';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              '${_getGreeting()}, ',
              style: DesignTypography.headline.copyWith(
                color: isDark ? DesignColors.textPrimaryDark : DesignColors.textPrimaryLight,
                fontWeight: FontWeight.normal,
              ),
            ),
            Expanded(
              child: Text(
                driverName,
                style: DesignTypography.headline.copyWith(
                  color: isDark ? DesignColors.primaryDark : DesignColors.primaryLight,
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        DesignSpacing.spacerV4,
        Text(
          _formatSpanishDate(),
          style: DesignTypography.bodyMedium.copyWith(
            color: isDark ? DesignColors.textSecondaryDark : DesignColors.textSecondaryLight,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
