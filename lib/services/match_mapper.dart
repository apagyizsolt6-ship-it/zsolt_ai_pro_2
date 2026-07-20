/*
===========================================
ZSOLT AI PRO - JAVÍTOTT IDŐZÓNA KONVERZIÓ
File: lib/services/match_mapper.dart
===========================================
*/

import '../models/match_model.dart';
import 'dart:developer';

class MatchMapper {
  const MatchMapper._();

  static MatchModel fromSportsDb(Map<String, dynamic> json) {
    final String date = json['dateEvent']?.toString() ?? '';
    final String time = json['strTime']?.toString() ?? '00:00:00';
    
    DateTime kickoff;
    try {
      // Itt a javítás: UTC-ként értelmezzük a bejövő stringet
      // A "Z" hozzáadásával a Dart biztosan UTC-nek tekinti, így a .toLocal() pontosan fog számolni
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
      status: _parseStatus(json['strStatus']?.toString()),
      homeOdd: null,
      drawOdd: null,
      awayOdd: null,
    );
  }
  
  // ... (A _parseStatus és fromSportsDbList változatlan)
}
