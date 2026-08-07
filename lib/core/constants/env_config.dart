enum AppEnvironment { dev, staging, prod }

/// Configuración de entorno de la aplicación.
///
/// Selección de ambiente vía `--dart-define=ENV=dev|staging|prod`
/// (ver [main.dart]).
///
/// La URL base puede sobreescribirse en build/CI sin cambiar código:
/// `--dart-define=API_BASE_URL=https://ejemplo.example/wsadryanbus/`
/// o `--dart-define-from-file=config/staging.json`.
///
/// Nota de seguridad: estos valores terminan en el binario compilado.
/// Solo deben usarse para URLs/flags públicas, nunca para secrets
/// (passwords, client secrets, API keys privadas, tokens permanentes).
class EnvConfig {
  final AppEnvironment environment;
  final String baseUrl;
  final Duration connectTimeout;
  final Duration receiveTimeout;

  EnvConfig({
    required this.environment,
    required this.baseUrl,
    this.connectTimeout = const Duration(seconds: 15),
    this.receiveTimeout = const Duration(seconds: 15),
  });

  static EnvConfig? _instance;

  /// Override opcional inyectado en compile-time.
  /// Vacío = usar el fallback del ambiente.
  static const String _apiBaseUrlOverride =
      String.fromEnvironment('API_BASE_URL');

  /// Fallbacks actuales por ambiente (comportamiento histórico del proyecto).
  /// Hoy coinciden; cuando exista URL de producción real, actualizar solo
  /// el caso [AppEnvironment.prod] o inyectar `API_BASE_URL` en CI.
  static const String _defaultDevBaseUrl =
      'http://40.75.87.68/wsadryanbus/';
  static const String _defaultStagingBaseUrl =
      'http://40.75.87.68/wsadryanbus/';
  static const String _defaultProdBaseUrl =
      'http://40.75.87.68/wsadryanbus/';

  static void initialize(AppEnvironment env) {
    switch (env) {
      case AppEnvironment.dev:
        _instance = EnvConfig(
          environment: AppEnvironment.dev,
          baseUrl: _resolveBaseUrl(_defaultDevBaseUrl),
        );
        break;
      case AppEnvironment.staging:
        _instance = EnvConfig(
          environment: AppEnvironment.staging,
          baseUrl: _resolveBaseUrl(_defaultStagingBaseUrl),
        );
        break;
      case AppEnvironment.prod:
        _instance = EnvConfig(
          environment: AppEnvironment.prod,
          baseUrl: _resolveBaseUrl(_defaultProdBaseUrl),
        );
        break;
    }
  }

  static String _resolveBaseUrl(String fallback) {
    final override = _apiBaseUrlOverride.trim();
    if (override.isNotEmpty) {
      return override.endsWith('/') ? override : '$override/';
    }
    return fallback;
  }

  static EnvConfig get instance {
    if (_instance == null) {
      throw StateError(
        'EnvConfig has not been initialized. Call initialize() first.',
      );
    }
    return _instance!;
  }
}
