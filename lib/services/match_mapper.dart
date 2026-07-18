// ===========================================
// ZSOLT AI PRO
// Version: v4.2.0
// File: lib/services/match_mapper.dart
// ===========================================

import '../models/match_model.dart';

class MatchMapper {
  const MatchMapper._();

  static MatchModel fromSportsDb(
    Map<String, dynamic> json,
  ) {
    final homeTeam =
        (json['strHomeTeam'] ?? '').toString();

    final awayTeam =
        (json['strAwayTeam'] ?? '').toString();

    final league =
        (json['strLeague'] ?? 'Ismeretlen liga')
            .toString();

    final date =
        json['dateEvent']?.toString();

    final time =
        json['strTime']?.toString();

    DateTime kickoff;

    try {
      kickoff = DateTime.parse(
        '${date ?? ''} ${time ?? '00:00:00'}',
      );
    } catch (_) {
      kickoff = DateTime.now();
    }

    MatchStatus status = MatchStatus.upcoming;

    final statusText =
        (json['strStatus'] ?? '')
            .toString()
            .toLowerCase();

    if (statusText.contains('live')) {
      status = MatchStatus.live;
    } else if (statusText.contains('finished')) {
      status = MatchStatus.finished;
    }

    return MatchModel(
      id: json['idEvent']?.toString() ?? '',
      league: league,
      homeTeam: homeTeam,
      awayTeam: awayTeam,
      kickoff: kickoff,
      status: status,

      // Ezeket később AI számolja
      aiScore: 0,
      valueBet: false,
    );
  }

  static List<MatchModel> fromSportsDbList(
    List<Map<String, dynamic>> events,
  ) {
    return events
        .map(fromSportsDb)
        .toList();
  }
}
