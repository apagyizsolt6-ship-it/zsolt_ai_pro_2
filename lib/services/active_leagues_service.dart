/*
===========================================
ZSOLT AI PRO - TELJES LIGA LISTA (ALL LEAGUES)
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

  static const List<String> supportedLeagues = [
    'Premier League', 'La Liga', 'Serie A', 'Bundesliga', 'Ligue 1', 
    'Eredivisie', 'Primeira Liga', 'SuperLiga', 'NB I', 'Champions League', 'Europa League'
  ];

  Future<List<MatchModel>> loadMatches() async {
    final List<MatchModel> allMatches = [];
    
    // Az összes jelentős liga ID-ja a TheSportsDB-ből:
    // 4328: PL, 4335: La Liga, 4331: Bundesliga, 4332: Serie A, 4334: Ligue 1, 
    // 4337: Eredivisie, 4339: Primeira Liga, 4406: SuperLiga, 4347: NB I, 
    // 4480: Champions League, 4481: Europa League
    final List<int> leagueIdsToFetch = [
      4328, 4335, 4331, 4332, 4334, 4337, 4339, 4406, 4347, 4480, 4481
    ];

    for (int id in leagueIdsToFetch) {
      try {
        log("Adatok betöltése $id ID-jú ligából...");
        final events = await _api.getNextLeagueMatches(id);
        
        if (events.isNotEmpty) {
          allMatches.addAll(MatchMapper.fromSportsDbList(events));
        }
      } catch (e) {
        log("Hiba a $id ID-jú liga betöltésekor: $e");
      }
    }

    final Map<int, MatchModel> uniqueMatches = {};
    for (final match in allMatches) {
      if (match.id != 0) uniqueMatches[match.id] = match;
    }

    final result = uniqueMatches.values.toList();
    
    // Rendezés dátum szerint
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
