/// ===========================================
/// ZSOLT AI PRO
/// Version: v4.1.0
/// File: config.dart
/// ===========================================

class AppConfig {
  const AppConfig._();

  /// TheSportsDB Premium API Key
  static const String sportsDbApiKey = String.fromEnvironment(
    'SPORTSDB_API_KEY',
    defaultValue: '',
  );

  static const String sportsDbBaseUrl =
      'https://www.thesportsdb.com/api/v2/json';

  static bool get hasApiKey => sportsDbApiKey.isNotEmpty;
}
