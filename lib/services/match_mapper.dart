/*
===========================================
ZSOLT AI PRO - JAVÍTOTT MAPPER (BUILD #054)
File: lib/services/match_mapper.dart
===========================================
*/

import '../models/match_model.dart';
import 'dart:developer';

class MatchMapper {
  // A service ezt hívja: MatchMapper.fromSportsDbList
  static List<MatchModel> fromSportsDbList(List<Map<String, dynamic>> events) {
    return events.map(fromSportsDb).toList();
  }

  // A mapper ezt a belső metódust használja
  static MatchModel fromSportsDb(Map<String, dynamic> json) {
    final String date = json['dateEvent']?.toString() ?? '';
    final String time = json['strTime']?.toString() ?? '00:00:00';
    
    DateTime kickoff;
    try {
      kickoff = DateTime.parse('$date ${time}Z'); 
    } catch (e) {
      log("Dátum formázási hiba: $e");
      kickoff = DateTime.now();
    }

    return MatchModel(
      id: int.tryParse(json['idEvent']?.toString() ?? '') ?? 0,
      league: (json['strLeague'] ?? '').toString(),
      homeTeam: (json['strHomeTeam'] ?? '').toString(),
      awayTeam: (json['strAwayTeam'] ?? '').toString(),
      kickoff: kickoff, 
      aiScore: 0,
      valueBet: false,
      // Javítva: _parseStatus (nagybetűs S-sel)
      status: _parseStatus(json['strStatus']?.toString()),
      homeOdd: null,
      drawOdd: null,
      awayOdd: null,
    );
  }

  // JAVÍTVA: A metódus neve _parseStatus legyen (ahogy az fromSportsDb hívja)
  static MatchStatus _parseStatus(String? statusText) {
    final s = (statusText ?? '').toLowerCase();
    if (s.contains('live') || s == 'tt') return MatchStatus.live;
    if (s.contains('finished') || s == 'ft') return MatchStatus.finished;
    return MatchStatus.upcoming;
  }
}
