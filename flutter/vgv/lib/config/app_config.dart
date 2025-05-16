/// Environment types for the application
enum Environment {
  /// Development environment
  development,

  /// Staging environment
  staging,

  /// Production environment
  production,
}

/// App configuration that varies by environment
class AppConfig {
  /// Create app configuration for specific environment
  const AppConfig({
    required this.environment,
    required this.apiBaseUrl,
  });

  /// Current environment
  final Environment environment;

  /// API base URL
  final String apiBaseUrl;

  /// Development environment config
  static const development = AppConfig(
    environment: Environment.development,
    apiBaseUrl: 'https://api-dev.example.com',
  );

  /// Staging environment config
  static const staging = AppConfig(
    environment: Environment.staging,
    apiBaseUrl: 'https://api-stage.example.com',
  );

  /// Production environment config
  static const production = AppConfig(
    environment: Environment.production,
    apiBaseUrl: 'https://api.example.com',
  );
}
