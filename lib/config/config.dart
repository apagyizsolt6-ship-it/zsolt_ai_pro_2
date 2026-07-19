// ===========================================
// ZSOLT AI PRO - KONFIGURÁCIÓ
// File: lib/config/config.dart
// ===========================================

class AppConfig {
  const AppConfig._();

  /// A TheSportsDB Premium API kulcsod
  /// Másold be ide a saját prémium kulcsodat a '' jelek közé!
  static const String sportsDbApiKey = '4320050533';

  /// A TheSportsDB API Base URL (v1 verzió, az univerzális kompatibilitásért)
  static const String sportsDbBaseUrl = 'https://www.thesportsdb.com/api/v1/json/';

  /// Ellenőrzi, hogy a kulcs be van-e állítva
  static bool get hasApiKey => 
      sportsDbApiKey.isNotEmpty && 
      sportsDbApiKey != '4320050533';
}
