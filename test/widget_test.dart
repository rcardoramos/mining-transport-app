import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:get_it/get_it.dart';
import 'package:mining_transport_app/core/constants/env_config.dart';
import 'package:mining_transport_app/core/di/injection_container.dart';
import 'package:mining_transport_app/core/audio/audio_service.dart';
import 'package:mining_transport_app/features/auth/presentation/pages/splash_view.dart';

class MockAudioService extends Mock implements AudioService {}

void main() {
  setUpAll(() async {
    // Inicializar configuración de entorno para pruebas
    EnvConfig.initialize(AppEnvironment.dev);
    // Inicializar GetIt para resolver los casos de uso inyectados en el ViewModel
    await setupLocator();

    // Sobrescribir AudioService con el Mock
    final mockAudio = MockAudioService();
    when(() => mockAudio.playAlertSound()).thenAnswer((_) => Future.value());
    GetIt.I.unregister<AudioService>();
    GetIt.I.registerSingleton<AudioService>(mockAudio);
  });

  testWidgets('SplashView smoke test - displays title and bus icon',
      (WidgetTester tester) async {
    // Build our widget and trigger a frame.
    await tester.pumpWidget(const ProviderScope(
      child: MaterialApp(
        home: SplashView(),
      ),
    ));

    // Verify that the title is displayed.
    expect(find.text('APP Buses - Miski Mayo'), findsOneWidget);

    // Verify that the progress indicator is present.
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // Verify that the bus icon is present.
    expect(find.byIcon(Icons.directions_bus), findsOneWidget);
  });
}
