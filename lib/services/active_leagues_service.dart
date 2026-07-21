/*
===========================================
ZSOLT AI PRO - ACTIVE LEAGUES SERVICE (PROFI AUTOMATA + FOCI SZŰRÉS)
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

  final List<int> leagueIdsToFetch = [
    4328, 4329, 4331, 4332, 4334, 4335, 4336, 4337, 4338, 4339, 4340, 4344, 4346, 4351, 4354, 4356, 
    4359, 4370, 4371, 4380, 4381, 4384, 4387, 4391, 4392, 4396, 4400, 4401, 4402, 4403, 4416, 4418, 
    4422, 4424, 4426, 4434, 4437, 4438, 4440, 4441, 4443, 4451, 4456, 4464, 4465, 4466, 4480, 4481, 
    4482, 4515
  ];

  // Profi automata magyarító a bajnokságnevekhez
  String _formatLeagueName(String name) {
    final Map<String, String> dictionary = {
      "Club Friendlies": "Barátságos klubmérkőzések",
      "Argentinian Primera C": "Argentin Primera C",
      "Copa Paulista": "Copa Paulista",
      "Argentinian Primera B Nacional": "Argentin Primera B Nacional",
      "Argentinian Torneo Promocional Amateur": "Argentin Torneo Promocional Amateur",
      "Bulgarian First League": "Bolgár első osztály",
      "Romanian Liga I": "Román Liga I",
      "Lebanon Premier League": "Libanoni Premier League",
      "Bolivian Primera División": "Bolíviai Primera División",
      "Ecuadorian Serie A": "Ecuadori Serie A",
      "Icelandic 1 Deild Karla": "Izlandi 1. Deild Karla",
      "Icelandic Úrvalsdeild Karla": "Izlandi Úrvalsdeild Karla",
      "Uruguayan Primera Division": "Uruguayi Primera Division",
    };

    if (dictionary.containsKey(name)) {
      return dictionary[name]!.toUpperCase();
    }

    String clean = name
        .replaceAll("Division", "Osztály")
        .replaceAll("League", "Liga")
        .replaceAll("Friendlies", "Barátságos mérkőzések")
        .replaceAll("Premier", "Premier")
        .replaceAll("National", "Nemzeti")
        .replaceAll("Supercopa", "Szuperkupa")
        .replaceAll("Cup", "Kupa")
        .trim();
        
    return clean.toUpperCase();
  }

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
    final dates = ['2026-07-20', '2026-07-21', '2026-07-22'];
    final results = await Future.wait(dates.map((d) => _api.getMatchesByDate(d)));

    final List<MatchModel> allMatches = [];
    for (var dailyEvents in results) {
      if (dailyEvents.isNotEmpty) {
        final matches = MatchMapper.fromSportsDbList(dailyEvents);
        
        // Szigorú foci szűrő (kiszűri az összes nem-foci sportágat)
        for (var m in matches) {
          final lowerLeague = m.league.toLowerCase();
          final isNotFootball = lowerLeague.contains('baseball') ||
              lowerLeague.contains('mlb') ||
              lowerLeague.contains('afl') ||
              lowerLeague.contains('rugby') ||
              lowerLeague.contains('cricket') ||
              lowerLeague.contains('basketball') ||
              lowerLeague.contains('nba') ||
              lowerLeague.contains('wnba') ||
              lowerLeague.contains('tennis') ||
              lowerLeague.contains('hockey') ||
              lowerLeague.contains('esports') ||
              lowerLeague.contains('béisbol');

          if (m.homeTeam.isNotEmpty && 
              m.homeTeam != 'VS' && 
              m.homeTeam != 'TBD' && 
              !isNotFootball) {
            
            // Létrehozzuk a frissített modellt a magyarított ligájú névvel
            allMatches.add(MatchModel(
              id: m.id,
              league: _formatLeagueName(m.league),
              homeTeam: m.homeTeam,
              awayTeam: m.awayTeam,
              kickoff: m.kickoff,
              aiScore: m.aiScore,
              valueBet: m.valueBet,
              status: m.status,
            ));
          }
        }
      }
    }

    final Map<int, MatchModel> unique = {};
    for (var m in allMatches) unique[m.id] = m;
    final sorted = unique.values.toList()..sort((a, b) => a.kickoff.compareTo(b.kickoff));

    await file.writeAsString(json.encode(sorted.map((m) => m.toJson()).toList()));
    return sorted;
  }
}
