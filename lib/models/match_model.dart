/*
===========================================
ZSOLT AI PRO
Version: v1.2.0
Build #031
File: match_model.dart
===========================================
*/

enum MatchStatus {
  upcoming,
  live,
  finished,
}

class MatchModel {
  final int id;

  final String league;

  final String homeTeam;
  final String awayTeam;

  final DateTime kickoff;

  final int aiScore;

  final bool valueBet;

  final MatchStatus status;

  final double? homeOdd;
  final double? drawOdd;
  final double? awayOdd;

  const MatchModel({
    required this.id,
    required this.league,
    required this.homeTeam,
    required this.awayTeam,
    required this.kickoff,
    required this.aiScore,
    required this.valueBet,
    required this.status,
    this.homeOdd,
    this.drawOdd,
    this.awayOdd,
  });

  String get matchTitle => '$homeTeam vs $awayTeam';

  bool get isLive => status == MatchStatus.live;

  bool get isFinished => status == MatchStatus.finished;

  bool get isUpcoming => status == MatchStatus.upcoming;

  bool get hasOdds =>
      homeOdd != null &&
      drawOdd != null &&
      awayOdd != null;

  MatchModel copyWith({
    int? id,
    String? league,
    String? homeTeam,
    String? awayTeam,
    DateTime? kickoff,
    int? aiScore,
    bool? valueBet,
    MatchStatus? status,
    double? homeOdd,
    double? drawOdd,
    double? awayOdd,
  }) {
    return MatchModel(
      id: id ?? this.id,
      league: league ?? this.league,
      homeTeam: homeTeam ?? this.homeTeam,
      awayTeam: awayTeam ?? this.awayTeam,
      kickoff: kickoff ?? this.kickoff,
      aiScore: aiScore ?? this.aiScore,
      valueBet: valueBet ?? this.valueBet,
      status: status ?? this.status,
      homeOdd: homeOdd ?? this.homeOdd,
      drawOdd: drawOdd ?? this.drawOdd,
      awayOdd: awayOdd ?? this.awayOdd,
    );
  }

  @override
  String toString() {
    return 'MatchModel('
        'id: $id, '
        'league: $league, '
        'match: $homeTeam vs $awayTeam, '
        'aiScore: $aiScore, '
        'status: $status'
        ')';
  }
}
