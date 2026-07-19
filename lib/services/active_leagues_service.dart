/*
===========================================
ZSOLT AI PRO - VÉGLEGES ADATBETÖLTŐ
File: lib/services/active_leagues_service.dart
===========================================
*/

import '../models/match_model.dart';
import 'api_service.dart';
import 'match_mapper.dart';
import 'dart:developer';

class ActiveLeaguesService {
  ActiveLeaguesService();
  final ApiService _api = ApiService();

  // Csökkentett lista a gyorsabb teszteléshez, de bármennyit hozzáadhatsz
  static const List<String> supportedLeagues = [
    'Premier League', 'La Liga', 'Serie A', 'Bundesliga', 'NB I'
  ];

  Future<List<MatchModel>> loadMatches() async {
    final List<MatchModel> allMatches = [];

    try {
      // Lekérjük az összes ligát, hogy megkapjuk az ID-kat
      final leagues = await _api.getAllLeagues();
      
      for (final league in leagues) {
        final leagueName = (league['strLeague'] ?? '').toString().trim();
        if (!supportedLeagues.contains(leagueName)) continue;

        final leagueId = int.tryParse(league['idLeague']?.toString() ?? '');
        if (leagueId == null) continue;

        try {
          // 1. Következő meccsek lekérése
          final nextEvents = await _api.getNextLeagueMatches(leagueId);
          if (nextEvents.isNotEmpty) {
            allMatches.addAll(MatchMapper.fromSportsDbList(nextEvents));
          }
          
          // 2. Múltbéli meccsek lekérése (hogy biztosan legyen adat)
          // Mivel nincs közvetlen 'past' metódusunk, ezt a logikát itt kezeljük
          // vagy simán csak a meglévő nextEvents-re támaszkodunk.
          
        } catch (e) {
          log("Hiba a $leagueName liga betöltésekor: $e");
          continue;
        }
      }
    } catch (e) {
      log("Hiba a liga lista lekérésekor: $e");
    }

    // Duplikációk szűrése és dátum szerinti rendezés
    final Map<int, MatchModel> uniqueMatches = {};
    for (final match in allMatches) {
      if (match.id != 0) uniqueMatches[match.id] = match;
    }

    final result = uniqueMatches.values.toList();
    result.sort((a, b) => a.kickoff.compareTo(b.kickoff));
    
    log("Összesen betöltött meccsek száma: ${result.length}");
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
    return await _api.testConnection();
  }
}
