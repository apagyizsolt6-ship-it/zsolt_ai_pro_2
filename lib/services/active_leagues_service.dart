/*
===========================================
ZSOLT AI PRO - TELJES FOCI BŐVÍTÉS (BUILD #063)
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
  List<MatchModel> _cachedMatches = [];
  DateTime? _lastFetchTime;
  static const Duration _cooldown = Duration(minutes: 15); 

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/matches_cache.json');
  }

  // BŐVÍTETT FOCI ID LISTA - Minden fontosabb fociligát tartalmaz
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
        _cachedMatches = jsonData.map((m) => MatchModel.fromJson(m)).toList();
        return _cachedMatches;
      } catch (e) {
        log("Hiba a cache olvasásakor: $e");
      }
    }

    log("Adatok frissítése az API-ból...");
    final futures = leagueIdsToFetch.map((id) => _api.getNextLeagueMatches(id));
    final results = await Future.wait(futures);

    final List<MatchModel> allMatches = [];
    for (var events in results) {
      if (events != null && events.isNotEmpty) {
        final matches = MatchMapper.fromSportsDbList(events);
        
        // Eredeti logika + Bővített szűrés
        final validMatches = matches.where((m) => 
          m.homeTeam.isNotEmpty && 
          m.homeTeam != 'VS' && 
          m.homeTeam != 'TBD' &&
          // KIZÁRÓLAG A NEM FOCIS SPORTÁGAK KIZÁRÁSA
          !m.league.toLowerCase().contains('baseball') &&
          !m.league.toLowerCase().contains('mlb') &&
          !m.league.toLowerCase().contains('afl') &&
          !m.league.toLowerCase().contains('rugby') &&
          !m.league.toLowerCase().contains('cricket') &&
          !m.league.toLowerCase().contains('basketball')
        ).toList();
        
        allMatches.addAll(validMatches);
      }
    }

    final Map<int, MatchModel> uniqueMatches = {};
    for (final match in allMatches) uniqueMatches[match.id] = match;
    _cachedMatches = uniqueMatches.values.toList()..sort((a, b) => a.kickoff.compareTo(b.kickoff));
    
    await file.writeAsString(json.encode(_cachedMatches.map((m) => m.toJson()).toList()));
    _lastFetchTime = DateTime.now();

    return _cachedMatches;
  }
}
