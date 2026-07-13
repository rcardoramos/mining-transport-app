import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:mining_transport_app/core/audio/audio_service.dart';
import 'package:mining_transport_app/core/utils/logger.dart';

class MockAudioPlayer extends Mock implements AudioPlayer {}
class MockLogger extends Mock implements AppLogger {}

void main() {
  late MockLogger mockLogger;
  late MockAudioPlayer mockAudioPlayer;
  late AudioService audioService;

  setUp(() {
    mockLogger = MockLogger();
    mockAudioPlayer = MockAudioPlayer();
    audioService = AudioServiceImpl(mockLogger, audioPlayer: mockAudioPlayer);
    registerFallbackValue(AssetSource('audio/Alert.mp3'));
  });

  test('playAlertSound should stop current playback and play new sound from assets', () async {
    // Configurar comportamiento esperado de los mocks
    when(() => mockLogger.i(any())).thenAnswer((_) {});
    when(() => mockAudioPlayer.stop()).thenAnswer((_) => Future.value());
    when(() => mockAudioPlayer.play(any())).thenAnswer((_) => Future.value());

    // Ejecutar el método
    await expectLater(audioService.playAlertSound(), completes);

    // Verificar invocaciones
    verify(() => mockLogger.i(any())).called(1);
    verify(() => mockAudioPlayer.stop()).called(1);
    verify(() => mockAudioPlayer.play(any(that: isA<AssetSource>()))).called(1);
  });
}
