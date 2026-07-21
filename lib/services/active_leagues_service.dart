/*
===========================================
ZSOLT AI PRO - ACTIVE LEAGUES SERVICE (FORCE REFRESH & DINAMIKUS DÁTUMOK)
File: lib/services/active_leagues_service.dart
===========================================
*/
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import '../models/match_model.dart';
import 'api_service.dart';
import 'match_mapper.dart';

class ActiveLeaguesService {
  final ApiService _api = ApiService();

  Future<File> get _localFile async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/matches_cache.json');
  }

  static const String _hiddenLeaguesKey = 'hidden_leagues_list';

  Future<List<String>> getHiddenLeagues() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_hiddenLeaguesKey) ?? [];
  }

  Future<void> hideLeague(String leagueName) async {
    final prefs = await SharedPreferences.getInstance();
    final hidden = prefs.getStringList(_hiddenLeaguesKey) ?? [];
    if (!hidden.contains(leagueName)) {
      hidden.add(leagueName);
      await prefs.setStringList(_hiddenLeaguesKey, hidden);
    }
  }

  Future<void> unhideLeague(String leagueName) async {
    final prefs = await SharedPreferences.getInstance();
    final hidden = prefs.getStringList(_hiddenLeaguesKey) ?? [];
    hidden.remove(leagueName);
    await prefs.setStringList(_hiddenLeaguesKey, hidden);
  }

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

  Future<List<MatchModel>> loadMatches({bool forceRefresh = true}) async {
    final file = await _localFile;
    
    // Alapértelmezésben mostantól töröljük a régit, hogy mindig a friss adatok jöjjenek le!
    if (!forceRefresh && await file.exists()) {
      try {
        final contents = await file.readAsString();
        final List<dynamic> jsonData = json.decode(contents);
        return jsonData.map((m) => MatchModel.fromJson(m)).toList();
      } catch (e) { log("Cache hiba: $e"); }
    }

    log("Friss, dinamikus dátum alapú adatgyűjtés indul...");
    
    // PONTOS MAI ÉS KÖVETKEZŐ NAPOK GENERÁLÁSA (Ma, Holnap, Holnapután)
    final now = DateTime.now();
    final dates = List.generate(3, (index) {
      final targetDate = now.add(Duration(days: index)); // 0 = Ma, 1 = Holnap, 2 = Holnapután
      return DateFormat('yyyy-MM-dd').format(targetDate);
    });

    log("Lekért dátumok: $dates");

    final results = await Future.wait(dates.map((d) => _api.getMatchesByDate(d)));

    final List<MatchModel> allMatches = [];
    for (var dailyEvents in results) {
      if (dailyEvents.isNotEmpty) {
        final matches = MatchMapper.fromSportsDbList(dailyEvents);
        
        for (var m in matches) {
          final lowerLeague = m.league.toLowerCase();
          final lowerHome = m.homeTeam.toLowerCase();
          final lowerAway = m.awayTeam.toLowerCase();

          final bool isNotFootball = 
              lowerLeague.contains('baseball') ||
              lowerLeague.contains('mlb') ||
              lowerLeague.contains('afl') ||
              lowerLeague.contains('rugby') ||
              lowerLeague.contains('cricket') ||
              lowerLeague.contains('the hundred') ||
              lowerLeague.contains('basketball') ||
              lowerLeague.contains('nba') ||
              lowerLeague.contains('wnba') ||
              lowerLeague.contains('tennis') ||
              lowerLeague.contains('hockey') ||
              lowerLeague.contains('esports') ||
              lowerLeague.contains('béisbol') ||
              lowerLeague.contains('international') ||
              lowerHome.contains('stripers') || lowerAway.contains('stripers') ||
              lowerHome.contains('bisons') || lowerAway.contains('bisons') ||
              lowerHome.contains('red sox') || lowerAway.contains('red sox') ||
              lowerHome.contains('knights') || lowerAway.contains('knights') ||
              lowerHome.contains('mud hens') || lowerAway.contains('mud hens');

          if (m.homeTeam.isNotEmpty && 
              m.homeTeam != 'VS' && 
              m.homeTeam != 'TBD' && 
              !isNotFootball) {
            
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
