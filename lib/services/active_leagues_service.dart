/*
===========================================
ZSOLT AI PRO - OPTIMALIZÁLT LIGA BETÖLTÉS
File: lib/services/active_leagues_service.dart
===========================================
*/

import '../models/match_model.dart';
import 'api_service.dart';
import 'match_mapper.dart';
import 'dart:developer';
import 'dart:async'; // Késleltetéshez szükséges

class ActiveLeaguesService {
  ActiveLeaguesService();
  final ApiService _api = ApiService();

  static const List<String> supportedLeagues = [
    'Premier League', 'La Liga', 'Serie A', 'Bundesliga', 'Ligue 1', 
    'Eredivisie', 'Primeira Liga', 'SuperLiga', 'NB I', 'Champions League', 'Europa League'
  ];

  Future<List<MatchModel>> loadMatches() async {
    final List<MatchModel> allMatches = [];
    
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
        
        // KÉSLELTETÉS BEÉPÍTVE: 500ms minden kérés után
        await Future.delayed(const Duration(milliseconds: 500));
        
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
  
  // ... (A loadLiveMatches és testConnection marad változatlan)
}
