/*
===========================================
ZSOLT AI PRO - MŰKÖDŐ VERZIÓ (AKTÍV LIGA: 4370)
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

  Future<List<MatchModel>> loadMatches() async {
    log("Betöltés indítva a Brazil bajnokságra (4370)...");
    
    try {
      // A 4370 azonosítóval rendelkező liga (Brasileirao) most aktív, 
      // így biztosan érkezik adat.
      final events = await _api.getNextLeagueMatches(4370);
      
      log("API válasz érkezett, darabszám: ${events.length}");
      
      if (events.isEmpty) {
        log("FIGYELMEZTETÉS: Az API üres listát küldött.");
        return [];
      }

      final matches = MatchMapper.fromSportsDbList(events);
      log("Sikeresen leképezve ${matches.length} meccs.");
      
      return matches;
      
    } catch (e) {
      log("HIBA: $e");
      return [];
    }
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
