/*
===========================================
ZSOLT AI PRO - DÁTUM ÉS IDŐPONT JAVÍTÁS
File: lib/services/match_mapper.dart
===========================================
*/

import '../models/match_model.dart';
import 'dart:developer';

class MatchMapper {
  const MatchMapper._();

  static MatchModel fromSportsDb(Map<String, dynamic> json) {
    // 1. Dátum és idő kinyerése
    final String date = json['dateEvent']?.toString() ?? '';
    final String time = json['strTime']?.toString() ?? '00:00:00';
    
    DateTime kickoff;
    try {
      // A TheSportsDB dátum formátuma "yyyy-mm-dd", az időé "HH:MM:SS"
      // Kombináljuk őket: "yyyy-mm-dd HH:MM:SS"
      kickoff = DateTime.parse('$date $time');
    } catch (e) {
      log("Dátum formázási hiba: $e");
      kickoff = DateTime.now();
    }

    return MatchModel(
      id: int.tryParse(json['idEvent']?.toString() ?? '') ?? 0,
      league: (json['strLeague'] ?? '').toString(),
      homeTeam: (json['strHomeTeam'] ?? '').toString(),
      awayTeam: (json['strAwayTeam'] ?? '').toString(),
      kickoff: kickoff, // Ez a pontos kezdési időpont
      aiScore: 0,
      valueBet: false,
      status: _parseStatus(json['strStatus']?.toString()),
      homeOdd: null,
      drawOdd: null,
      awayOdd: null,
    );
  }

  static MatchStatus _parseStatus(String? statusText) {
    final s = (statusText ?? '').toLowerCase();
    if (s.contains('live') || s == 'tt') return MatchStatus.live;
    if (s.contains('finished') || s == 'ft') return MatchStatus.finished;
    return MatchStatus.upcoming;
  }

  static List<MatchModel> fromSportsDbList(List<Map<String, dynamic>> events) {
    return events.map(fromSportsDb).toList();
  }
}
