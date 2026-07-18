/*
===========================================
ZSOLT AI PRO
Version: v1.2.0
Build #032
File: demo_matches.dart
===========================================
*/

import '../models/match_model.dart';

class DemoMatches {
  static const List<MatchModel> matches = [
    MatchModel(
      id: 1,
      league: 'Premier League',
      homeTeam: 'Liverpool',
      awayTeam: 'Arsenal',
      kickoff: DateTime(2026, 7, 20, 20, 45),
      aiScore: 94,
      valueBet: true,
      status: MatchStatus.upcoming,
      homeOdd: 1.82,
      drawOdd: 3.70,
      awayOdd: 4.20,
    ),

    MatchModel(
      id: 2,
      league: 'Premier League',
      homeTeam: 'Manchester City',
      awayTeam: 'Chelsea',
      kickoff: DateTime(2026, 7, 20, 18, 30),
      aiScore: 91,
      valueBet: false,
      status: MatchStatus.upcoming,
      homeOdd: 1.65,
      drawOdd: 4.10,
      awayOdd: 5.10,
    ),

    MatchModel(
      id: 3,
      league: 'La Liga',
      homeTeam: 'Barcelona',
      awayTeam: 'Real Madrid',
      kickoff: DateTime(2026, 7, 21, 21, 00),
      aiScore: 96,
      valueBet: true,
      status: MatchStatus.upcoming,
      homeOdd: 2.15,
      drawOdd: 3.45,
      awayOdd: 3.10,
    ),

    MatchModel(
      id: 4,
      league: 'Serie A',
      homeTeam: 'Inter',
      awayTeam: 'Juventus',
      kickoff: DateTime(2026, 7, 22, 20, 45),
      aiScore: 89,
      valueBet: false,
      status: MatchStatus.upcoming,
      homeOdd: 2.05,
      drawOdd: 3.20,
      awayOdd: 3.60,
    ),

    MatchModel(
      id: 5,
      league: 'Bundesliga',
      homeTeam: 'Bayern München',
      awayTeam: 'Borussia Dortmund',
      kickoff: DateTime(2026, 7, 23, 18, 30),
      aiScore: 93,
      valueBet: true,
      status: MatchStatus.upcoming,
      homeOdd: 1.78,
      drawOdd: 3.90,
      awayOdd: 4.40,
    ),

    MatchModel(
      id: 6,
      league: 'NB I',
      homeTeam: 'Ferencváros',
      awayTeam: 'Újpest',
      kickoff: DateTime(2026, 7, 24, 20, 00),
      aiScore: 88,
      valueBet: false,
      status: MatchStatus.upcoming,
      homeOdd: 1.72,
      drawOdd: 3.85,
      awayOdd: 4.80,
    ),
  ];

  static MatchModel? getById(int id) {
    try {
      return matches.firstWhere((match) => match.id == id);
    } catch (_) {
      return null;
    }
  }
}
