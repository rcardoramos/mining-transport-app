enum AppEnvironment { dev, staging, prod }

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

  static void initialize(AppEnvironment env) {
    switch (env) {
      case AppEnvironment.dev:
        _instance = EnvConfig(
          environment: AppEnvironment.dev,
          baseUrl: 'https://api-dev.miskimayo.pe/api/v1',
        );
        break;
      case AppEnvironment.staging:
        _instance = EnvConfig(
          environment: AppEnvironment.staging,
          baseUrl: 'https://api-qa.miskimayo.pe/api/v1',
        );
        break;
      case AppEnvironment.prod:
        _instance = EnvConfig(
          environment: AppEnvironment.prod,
          baseUrl: 'https://api.miskimayo.pe/api/v1',
        );
        break;
    }
  }

  static EnvConfig get instance {
    if (_instance == null) {
      throw StateError('EnvConfig has not been initialized. Call initialize() first.');
    }
    return _instance!;
  }
}
