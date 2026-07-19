// ===========================================
// ZSOLT AI PRO
// Version: v4.1.0
// File: lib/config/config.dart
// ===========================================

class AppConfig {
  const AppConfig._();

  /// TheSportsDB Premium API Key
  static const String sportsDbApiKey = String.fromEnvironment(
    'SPORTSDB_API_KEY',
    defaultValue: '',
  );

  /// TheSportsDB API Base URL
  static const String sportsDbBaseUrl =
      'https://thesportsdb.com/api/v2/json';

  /// Igaz, ha van beállított API kulcs
  static bool get hasApiKey => sportsDbApiKey.isNotEmpty;
}
