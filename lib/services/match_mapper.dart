/*
===========================================
ZSOLT AI PRO
Version: v4.2.2
File: lib/services/match_mapper.dart
===========================================
*/

import '../models/match_model.dart';

class MatchMapper {
  const MatchMapper._();

  static MatchModel fromSportsDb(Map<String, dynamic> json) {
    // 1. Alapadatok kinyerése biztonságosan
    final homeTeam = (json['strHomeTeam'] ?? 'Ismeretlen').toString();
    final awayTeam = (json['strAwayTeam'] ?? 'Ismeretlen').toString();
    final league = (json['strLeague'] ?? 'Ismeretlen liga').toString();

    // 2. Dátum és idő robusztus kezelése
    final date = json['dateEvent']?.toString(); // Várható: "yyyy-mm-dd"
    final time = json['strTime']?.toString();   // Várható: "HH:MM:SS" vagy üres
    
    DateTime kickoff;
    try {
      if (date != null && date.isNotEmpty) {
        // Ha van dátum, próbáljuk meg pars-olni
        final timeString = (time != null && time.length >= 5) ? time.substring(0, 5) : '00:00';
        kickoff = DateTime.parse('$date $timeString:00');
      } else {
        kickoff = DateTime.now().add(const Duration(days: 1)); // Ha nincs dátum, tegyük a jövőbe
      }
    } catch (_) {
      kickoff = DateTime.now().add(const Duration(days: 1));
    }

    // 3. Státusz kezelése
    MatchStatus status = MatchStatus.upcoming;
    final statusText = (json['strStatus'] ?? '').toString().toLowerCase();

    if (statusText.contains('live') || statusText == 'tt') {
      status = MatchStatus.live;
    } else if (statusText.contains('finished') || statusText == 'ft') {
      status = MatchStatus.finished;
    }

    return MatchModel(
      id: int.tryParse(json['idEvent']?.toString() ?? '') ?? 0,
      league: league,
      homeTeam: homeTeam,
      awayTeam: awayTeam,
      kickoff: kickoff,
      aiScore: 0, 
      valueBet: false,
      status: status,
      homeOdd: null,
      drawOdd: null,
      awayOdd: null,
    );
  }

  static List<MatchModel> fromSportsDbList(List<Map<String, dynamic>> events) {
    // Itt szűrjük ki a hibás (id=0) elemeket már a konverzió során
    return events
        .map(fromSportsDb)
        .where((match) => match.id != 0)
        .toList();
  }
}
