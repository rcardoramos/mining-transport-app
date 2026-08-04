import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mining_transport_app/features/home/domain/entities/trip_entity.dart';
import 'package:mining_transport_app/features/home/presentation/widgets/trip_item_card.dart';
import 'package:mining_transport_app/shared/design_system/design_system.dart';

void main() {
  testWidgets('TripItemCard should lay out successfully when trip is inProgress',
      (WidgetTester tester) async {
    final trip = TripEntity(
      id: 'TRIP-123',
      route: 'Ruta de prueba',
      scheduledTime: DateTime.now().add(const Duration(hours: 1)),
      shift: 'Día',
      unitCode: 'BUS-01',
      capacity: 40,
      passengerCount: 15,
      status: TripStatus.inProgress,
      startedAt: DateTime.now(),
    );

    // Build the widget inside a MaterialApp with AppDesignTheme.lightTheme
    // to resolve Theme extensions correctly.
    await tester.pumpWidget(
      MaterialApp(
        theme: AppDesignTheme.lightTheme,
        home: Scaffold(
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: TripItemCard(
                trip: trip,
                isAperturarDisabled: false,
                onStatusChanged: (_) {},
                onContinuarEmbarque: () {},
                onVerResumen: () {},
              ),
            ),
          ),
        ),
      ),
    );

    // Verify widget builds without exceptions and displays the route and labels.
    expect(find.text('Ruta de prueba'), findsOneWidget);
    expect(find.text('Hora Inicio'), findsOneWidget);
    expect(find.text('Pasajeros'), findsOneWidget);
    expect(find.text('15 / 40'), findsOneWidget);
  });
}
