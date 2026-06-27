import 'dart:async';

/// Servicio global para notificar y reaccionar a la expiración de la sesión (ej. error 401/403).
class SessionStatusService {
  final _controller = StreamController<void>.broadcast();

  /// Stream que emite eventos cuando la sesión expira o es invalidada por el servidor.
  Stream<void> get sessionExpiredStream => _controller.stream;

  /// Notifica que la sesión actual ha expirado.
  void notifySessionExpired() {
    _controller.add(null);
  }

  /// Libera los recursos del StreamController.
  void dispose() {
    _controller.close();
  }
}
