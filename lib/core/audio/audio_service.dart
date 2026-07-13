import 'package:audioplayers/audioplayers.dart';
import 'package:mining_transport_app/core/utils/logger.dart';

abstract class AudioService {
  Future<void> playAlertSound();
}

class AudioServiceImpl implements AudioService {
  final AudioPlayer _audioPlayer;
  final AppLogger _logger;

  AudioServiceImpl(this._logger, {AudioPlayer? audioPlayer})
      : _audioPlayer = audioPlayer ?? AudioPlayer();

  @override
  Future<void> playAlertSound() async {
    try {
      _logger.i('Reproduciendo alerta sonora desde assets (assets/audio/Alert.mp3)...');
      await _audioPlayer.stop(); // Detener cualquier sonido en curso
      await _audioPlayer.play(AssetSource('audio/Alert.mp3'));
    } catch (e, stack) {
      _logger.e('Error al reproducir audio de alerta: $e', e, stack);
    }
  }
}
