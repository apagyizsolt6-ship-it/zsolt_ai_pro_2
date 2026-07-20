/*
===========================================
ZSOLT AI PRO - OKOS FRISSÍTŐ MOTOR (BUILD #055)
File: lib/services/active_leagues_service.dart
===========================================
*/

import 'dart:developer';
import '../models/match_model.dart';
import 'api_service.dart';
import 'match_mapper.dart';

class ActiveLeaguesService {
  final ApiService _api = ApiService();
  
  // Cache és időzítés
  List<MatchModel> _cachedMatches = [];
  DateTime? _lastFetchTime;
  static const Duration _cooldown = Duration(seconds: 60);

  final List<int> leagueIdsToFetch = [
    // Európa
    4328, 4335, 4331, 4332, 4334, 4480, 4481, 4337, 4339, 4330, 4333, 4336, 4340, 4351, 4418, 4380, 4370, 4371, 4346, 4416, 4391, 4387,
    // Dél-Amerika
    4396, 4392, 4424, 4434, 4426, 4437,
    // Ázsia & Ausztrália
    4451, 4440, 4441, 4366, 4443, 4465, 4466,
    // Afrika & Amerika
    4432, 4464, 4438, 4456
  ];

  Future<List<MatchModel>> loadMatches({bool forceRefresh = false}) async {
    // Ha még nem telt el a cooldown és nem kényszerített frissítés van
    if (!forceRefresh && _cachedMatches.isNotEmpty && _lastFetchTime != null) {
      if (DateTime.now().difference(_lastFetchTime!) < _cooldown) {
        log("Cache-ből töltünk: ${_cachedMatches.length} meccs.");
        return _cachedMatches;
      }
    }

    log("Szerverről töltünk (Párhuzamos hívások)...");
    
    // Párhuzamos hívások - a 9$-os kulcsod ezt bírja!
    final futures = leagueIdsToFetch.map((id) => _api.getNextLeagueMatches(id));
    final results = await Future.wait(futures);

    final List<MatchModel> allMatches = [];
    for (var events in results) {
      if (events.isNotEmpty) {
        allMatches.addAll(MatchMapper.fromSportsDbList(events));
      }
    }

    // Egyediség szűrése
    final Map<int, MatchModel> uniqueMatches = {};
    for (final match in allMatches) uniqueMatches[match.id] = match;
    
    _cachedMatches = uniqueMatches.values.toList()..sort((a, b) => a.kickoff.compareTo(b.kickoff));
    _lastFetchTime = DateTime.now();

    log("Frissítés kész: ${_cachedMatches.length} meccs.");
    return _cachedMatches;
  }
}
