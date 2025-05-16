import 'package:vgv/config/app_config.dart';

/// Helper to load environment configuration
class EnvLoader {
  /// Get environment configuration based on environment name
  static AppConfig getConfig(String environment) {
    switch (environment) {
      case 'development':
        return AppConfig.development;
      case 'staging':
        return AppConfig.staging;
      case 'production':
        return AppConfig.production;
      default:
        throw Exception('Unknown environment: $environment');
    }
  }
}
