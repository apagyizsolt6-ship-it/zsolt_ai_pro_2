// ===========================================
// ZSOLT AI PRO
// Version: v4.3.0
// File: lib/services/active_leagues_service.dart
// ===========================================

import '../models/match_model.dart';
import 'api_service.dart';
import 'match_mapper.dart';

class ActiveLeaguesService {
  ActiveLeaguesService({
    ApiService? apiService,
  }) : _api = apiService ?? ApiService();

  final ApiService _api;

  /// Alapértelmezésben figyelt bajnokságok.
  /// Később ezt a felhasználó szabadon módosíthatja.
  static const List<int> defaultLeagueIds = [
    4335, // Premier League
    4332, // Serie A
    4331, // Bundesliga
    4334, // Ligue 1
    4337, // Eredivisie
    4339, // Primeira Liga
    4346, // NB I
    4356, // Allsvenskan
    4352, // Eliteserien
    4355, // Veikkausliiga
    4340, // Danish Superliga
    4456, // Ekstraklasa
    4344, // Irish Premier Division
    4689, // J1 League
    292,  // K League 1
    4350, // Brazilian Serie A
    4400, // Argentine Primera
  ];

  Future<List<MatchModel>> loadMatches() async {
    final List<MatchModel> matches = [];

    for (final leagueId in defaultLeagueIds) {
      try {
        final events =
            await _api.getNextLeagueMatches(leagueId);

        matches.addAll(
          MatchMapper.fromSportsDbList(events),
        );
      } catch (_) {
        // Ha egy liga nem elérhető,
        // a többit tovább töltjük.
      }
    }

    matches.sort(
      (a, b) => a.kickoff.compareTo(b.kickoff),
    );

    return matches;
  }
}
