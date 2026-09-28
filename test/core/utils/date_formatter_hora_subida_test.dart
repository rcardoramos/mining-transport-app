import 'package:flutter_test/flutter_test.dart';
import 'package:mining_transport_app/core/utils/date_formatter.dart';
import 'package:mining_transport_app/features/passenger/data/models/passenger_model.dart';

void main() {
  group('PeruDateFormatter.parsePeruWallClock', () {
    test('HoraSubida con Z falsa muestra hora Perú sin restar 5h', () {
      // Backend: SWITCHOFFSET(..., '-05:00') → DATETIME2 → JSON con Z.
      const raw = '2026-09-28T11:12:21.5428975Z';
      final parsed = PeruDateFormatter.parsePeruWallClock(raw);
      expect(parsed, isNotNull);
      expect(PeruDateFormatter.formatTime(parsed), '11:12');
    });

    test('parseFlexible con Z resta 5h (contrato UTC real)', () {
      const raw = '2026-09-28T11:12:21.5428975Z';
      final parsed = PeruDateFormatter.parseFlexible(raw);
      expect(PeruDateFormatter.formatTime(parsed), '06:12');
    });
  });

  group('PassengerModel HoraSubida', () {
    test('Lista usa wall-clock Perú', () {
      final entity = PassengerModel.fromJson({
        'Dni': '42475115',
        'NombreCompleto': 'CHRISTIAM OSWALDO ECHE FIESTAS',
        'HoraSubida': '2026-09-28T11:12:21.5428975Z',
        'Empresa': 'COMPAÑÍA MINERA MISKI MAYO S.R.L.',
        'EstadoLaboral': 'OK',
      }).toEntity();

      expect(PeruDateFormatter.formatTime(entity.boardedAt), '11:12');
    });
  });
}
