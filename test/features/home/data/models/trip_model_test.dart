import 'package:flutter_test/flutter_test.dart';
import 'package:mining_transport_app/features/home/data/models/trip_model.dart';
import 'package:mining_transport_app/features/home/domain/entities/trip_entity.dart';

void main() {
  group('TripModel.fromJson parsing', () {
    test('should parse fechaProgramada and FechaProgramada as scheduledTime', () {
      final json1 = {
        'id': 'TRIP-999',
        'route': 'Test Route',
        'fechaProgramada': '2026-08-02T15:00:00',
        'shift': 'Día',
        'busCode': 'BUS-01',
        'capacity': 40,
        'passengerCount': 0,
        'status': 'scheduled',
      };
      
      final model1 = TripModel.fromJson(json1);
      expect(model1.scheduledTime, '2026-08-02T15:00:00');

      final json2 = {
        'id': 'TRIP-999',
        'route': 'Test Route',
        'FechaProgramada': '2026-08-02T16:30:00',
        'shift': 'Día',
        'busCode': 'BUS-01',
        'capacity': 40,
        'passengerCount': 0,
        'status': 'scheduled',
      };
      
      final model2 = TripModel.fromJson(json2);
      expect(model2.scheduledTime, '2026-08-02T16:30:00');
    });

    test('should parse bus/Bus fields correctly for unitCode', () {
      // 1. As direct String
      final jsonString = {
        'id': 'TRIP-999',
        'route': 'Test Route',
        'fechaProgramada': '2026-08-02T15:00:00',
        'shift': 'Día',
        'bus': 'BUS-777',
        'capacity': 40,
        'passengerCount': 0,
        'status': 'scheduled',
      };
      final modelString = TripModel.fromJson(jsonString);
      expect(modelString.unitCode, 'BUS-777');

      // 2. As Map object
      final jsonMap = {
        'id': 'TRIP-999',
        'route': 'Test Route',
        'fechaProgramada': '2026-08-02T15:00:00',
        'shift': 'Día',
        'Bus': {
          'placa': 'PLACA-ABC',
          'capacidad': 45,
        },
        'capacity': 40,
        'passengerCount': 0,
        'status': 'scheduled',
      };
      final modelMap = TripModel.fromJson(jsonMap);
      expect(modelMap.unitCode, 'PLACA-ABC');

      // 3. Fallback to Placa or original unitCode fields
      final jsonFallback = {
        'id': 'TRIP-999',
        'route': 'Test Route',
        'fechaProgramada': '2026-08-02T15:00:00',
        'shift': 'Día',
        'Placa': 'PLACA-XYZ',
        'capacity': 40,
        'passengerCount': 0,
        'status': 'scheduled',
      };
      final modelFallback = TripModel.fromJson(jsonFallback);
      expect(modelFallback.unitCode, 'PLACA-XYZ');
    });

    test('should parse fechaInicio/FechaInicio correctly for startedAt', () {
      final json1 = {
        'id': 'TRIP-999',
        'route': 'Test Route',
        'fechaProgramada': '2026-08-02T15:00:00',
        'shift': 'Día',
        'bus': 'BUS-01',
        'capacity': 40,
        'passengerCount': 0,
        'status': 'inProgress',
        'fechaInicio': '2026-08-02T15:05:00',
      };
      final model1 = TripModel.fromJson(json1);
      expect(model1.startedAt, '2026-08-02T15:05:00');

      final json2 = {
        'id': 'TRIP-999',
        'route': 'Test Route',
        'fechaProgramada': '2026-08-02T15:00:00',
        'shift': 'Día',
        'bus': 'BUS-01',
        'capacity': 40,
        'passengerCount': 0,
        'status': 'inProgress',
        'FechaInicio': '2026-08-02T15:10:00',
      };
      final model2 = TripModel.fromJson(json2);
      expect(model2.startedAt, '2026-08-02T15:10:00');
    });

    test('should parse "P" status correctly as TripStatus.scheduled', () {
      final json = {
        'id': 'TRIP-999',
        'route': 'Test Route',
        'fechaProgramada': '2026-08-02T15:00:00',
        'shift': 'Día',
        'bus': 'BUS-01',
        'capacity': 40,
        'passengerCount': 0,
        'status': 'P',
      };
      final model = TripModel.fromJson(json);
      expect(model.toEntity().status, TripStatus.scheduled);
    });

    test('should parse "A" status correctly as TripStatus.inProgress', () {
      final json = {
        'id': 'TRIP-999',
        'route': 'Test Route',
        'fechaProgramada': '2026-08-02T15:00:00',
        'shift': 'Día',
        'bus': 'BUS-01',
        'capacity': 40,
        'passengerCount': 0,
        'status': 'A',
      };
      final model = TripModel.fromJson(json);
      expect(model.toEntity().status, TripStatus.inProgress);
    });
  });
}
