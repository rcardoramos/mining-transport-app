import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mining_transport_app/core/router/app_router.dart';

void main() {
  testWidgets('SplashView smoke test - displays title and bus icon',
      (WidgetTester tester) async {
    // Build our widget and trigger a frame.
    await tester.pumpWidget(const MaterialApp(
      home: SplashView(),
    ));

    // Verify that the title is displayed.
    expect(find.text('APP Buses - Miski Mayo'), findsOneWidget);

    // Verify that the progress indicator is present.
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // Verify that the bus icon is present.
    expect(find.byIcon(Icons.directions_bus), findsOneWidget);
  });
}
