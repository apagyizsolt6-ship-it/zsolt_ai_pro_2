/*
===========================================
ZSOLT AI PRO - ROMÁN SZUPER LIGA HOZZÁADVA
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

  // Itt a lista, hozzáadva a Román Szuper Liga (ID: 4406)
  static const List<String> supportedLeagues = [
    'Premier League', 'La Liga', 'Serie A', 'Bundesliga', 'NB I', 'SuperLiga'
  ];

  Future<List<MatchModel>> loadMatches() async {
    final List<MatchModel> allMatches = [];
    
    // A Román Szuper Liga ID-ja: 4406
    final List<int> leagueIdsToFetch = [4328, 4335, 4331, 4332, 4347, 4406];

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
