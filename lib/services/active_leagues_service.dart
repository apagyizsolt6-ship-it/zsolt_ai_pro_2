/*
===========================================
ZSOLT AI PRO - OPTIMALIZÁLT VERZIÓ
File: lib/services/active_leagues_service.dart
===========================================
*/

import '../models/match_model.dart';
import 'api_service.dart';
import 'match_mapper.dart';

class ActiveLeaguesService {
  ActiveLeaguesService();

  final ApiService _api = ApiService();

  static const List<String> supportedLeagues = [
    'Premier League', 'La Liga', 'Serie A', 'Bundesliga', 'Ligue 1',
    'Eredivisie', 'Primeira Liga', 'Scottish Premiership', 'Super Lig',
    'Belgian Pro League', 'Super League Greece', 'Swiss Super League',
    'Eliteserien', 'Allsvenskan', 'Veikkausliiga', 'Ekstraklasa',
    'Superliga', 'Chance Liga', 'Liga I', 'Parva Liga', 'NB I', 'Premier Division',
  ];

  Future<List<MatchModel>> loadMatches() async {
    final List<MatchModel> allMatches = [];

    // Az API-ból jövő ligák lekérése
    final leagues = await _api.getAllLeagues();

    for (final league in leagues) {
      final leagueName = (league['strLeague'] ?? '').toString().trim();

      if (!supportedLeagues.contains(leagueName)) {
        continue;
      }

      final leagueId = int.tryParse(league['idLeague']?.toString() ?? '');
      if (leagueId == null) continue;

      try {
        // Lekérjük a jövőbeli meccseket
        final events = await _api.getNextLeagueMatches(leagueId);

        if (events.isNotEmpty) {
          allMatches.addAll(MatchMapper.fromSportsDbList(events));
        }
      } catch (e) {
        // Hiba esetén továbbmegyünk, hogy a többi liga betöltődjön
        continue;
      }
    }

    // Duplikációk szűrése és rendezés dátum szerint
    final Map<int, MatchModel> uniqueMatches = {};
    for (final match in allMatches) {
      if (match.id != 0) {
        uniqueMatches[match.id] = match;
      }
    }

    final result = uniqueMatches.values.toList();
    result.sort((a, b) => a.kickoff.compareTo(b.kickoff));
    
    return result;
  }

  Future<List<MatchModel>> loadLiveMatches() async {
    try {
      final events = await _api.getLiveSoccer();
      return MatchMapper.fromSportsDbList(events);
    } catch (e) {
      return [];
    }
  }

  Future<bool> testConnection() async {
    try {
      return await _api.testConnection();
    } catch (e) {
      return false;
    }
  }
}
