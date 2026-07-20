/*
===========================================
ZSOLT AI PRO - 100% FOCI MOTOR (BUILD #060)
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
  // A fájl miatt 15 percre emeltük a cooldown-t a stabilitás kedvéért
  static const Duration _cooldown = Duration(minutes: 15); 

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/matches_cache.json');
  }

  final List<int> leagueIdsToFetch = [
    4328, 4335, 4331, 4332, 4334, 4480, 4481, 4337, 4339, 4330, 4333, 4336, 4340, 4351, 4418, 4380,
    4370, 4371, 4346, 4416, 4391, 4387, 4396, 4392, 4424, 4434, 4426, 4437, 4451, 4440, 4441, 4366, 
    4443, 4465, 4466, 4464, 4438, 4456
  ];

  Future<List<MatchModel>> loadMatches({bool forceRefresh = false}) async {
    final file = await _localFile;

    // 1. Megpróbáljuk fájlból betölteni
    if (!forceRefresh && await file.exists()) {
      try {
        final contents = await file.readAsString();
        final List<dynamic> jsonData = json.decode(contents);
        _cachedMatches = jsonData.map((m) => MatchModel.fromJson(m)).toList();
        _lastFetchTime = DateTime.now();
        log("Adatok betöltve a fájlból (Cache hit).");
        return _cachedMatches;
      } catch (e) {
        log("Hiba a fájl olvasásakor: $e");
      }
    }

    // 2. Ha forceRefresh van vagy nincs fájl, jön az API hívás
    log("Adatok letöltése az API-ból...");
    final futures = leagueIdsToFetch.map((id) => _api.getNextLeagueMatches(id));
    final results = await Future.wait(futures);

    final List<MatchModel> allMatches = [];
    for (var events in results) {
      if (events.isNotEmpty) {
        final matches = MatchMapper.fromSportsDbList(events);
        final validMatches = matches.where((m) => 
          m.homeTeam.isNotEmpty && m.homeTeam != 'VS' && m.homeTeam != 'TBD'
        ).toList();
        allMatches.addAll(validMatches);
      }
    }

    final Map<int, MatchModel> uniqueMatches = {};
    for (final match in allMatches) uniqueMatches[match.id] = match;
    _cachedMatches = uniqueMatches.values.toList()..sort((a, b) => a.kickoff.compareTo(b.kickoff));
    
    // 3. Mentés fájlba
    await file.writeAsString(json.encode(_cachedMatches.map((m) => m.toJson()).toList()));
    _lastFetchTime = DateTime.now();

    return _cachedMatches;
  }
}
