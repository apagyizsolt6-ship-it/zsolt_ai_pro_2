/*
===========================================
ZSOLT AI PRO - ACTIVE LEAGUES SERVICE (TELJES, EREDETI + DÁTUM BŐVÍTÉS)
File: lib/services/active_leagues_service.dart
===========================================
*/
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../models/match_model.dart';
import 'api_service.dart';
import 'match_mapper.dart';

class ActiveLeaguesService {
  final ApiService _api = ApiService();

  Future<File> get _localFile async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/matches_cache.json');
  }

  // A korábbi ligalistád itt maradt, ha szükséged lenne rá kiegészítő szűréshez
  final List<int> leagueIdsToFetch = [
    4328, 4329, 4331, 4332, 4334, 4335, 4336, 4337, 4338, 4339, 4340, 4344, 4346, 4351, 4354, 4356, 
    4359, 4370, 4371, 4380, 4381, 4384, 4387, 4391, 4392, 4396, 4400, 4401, 4402, 4403, 4416, 4418, 
    4422, 4424, 4426, 4434, 4437, 4438, 4440, 4441, 4443, 4451, 4456, 4464, 4465, 4466, 4480, 4481, 
    4482, 4515
  ];

  Future<List<MatchModel>> loadMatches({bool forceRefresh = false}) async {
    final file = await _localFile;
    if (!forceRefresh && await file.exists()) {
      try {
        final contents = await file.readAsString();
        final List<dynamic> jsonData = json.decode(contents);
        return jsonData.map((m) => MatchModel.fromJson(m)).toList();
      } catch (e) { log("Cache hiba: $e"); }
    }

    log("Dátum alapú adatgyűjtés indul...");
    // A 3 nap lekérése
    final dates = ['2026-07-20', '2026-07-21', '2026-07-22'];
    final results = await Future.wait(dates.map((d) => _api.getMatchesByDate(d)));

    final List<MatchModel> allMatches = [];
    for (var dailyEvents in results) {
      if (dailyEvents.isNotEmpty) {
        final matches = MatchMapper.fromSportsDbList(dailyEvents);
        
        // Itt szűrjük ki a nem focis dolgokat
        allMatches.addAll(matches.where((m) => 
          m.homeTeam.isNotEmpty && m.homeTeam != 'VS' && m.homeTeam != 'TBD' &&
          !m.league.toLowerCase().contains('baseball') &&
          !m.league.toLowerCase().contains('mlb') &&
          !m.league.toLowerCase().contains('afl') &&
          !m.league.toLowerCase().contains('rugby') &&
          !m.league.toLowerCase().contains('cricket') &&
          !m.league.toLowerCase().contains('basketball')
        ));
      }
    }

    // Duplikációk szűrése és rendezés
    final Map<int, MatchModel> unique = {};
    for (var m in allMatches) unique[m.id] = m;
    final sorted = unique.values.toList()..sort((a, b) => a.kickoff.compareTo(b.kickoff));

    await file.writeAsString(json.encode(sorted.map((m) => m.toJson()).toList()));
    return sorted;
  }
}
