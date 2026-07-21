/*
===========================================
ZSOLT AI PRO - MATCH MAPPER (DEBUG VERSION)
File: lib/services/match_mapper.dart
===========================================
*/

import 'dart:developer';
import '../models/match_model.dart';

class MatchMapper {
  // A service ezt hívja: MatchMapper.fromSportsDbList
  static List<MatchModel> fromSportsDbList(List<dynamic> events) {
    return events.map((json) {
      final date = json['dateEvent']?.toString() ?? '';
      final time = json['strTime']?.toString() ?? '00:00:00';

      log('=================================================');
      log('EVENT: ${json['strHomeTeam']} - ${json['strAwayTeam']}');
      log('idEvent      : ${json['idEvent']}');
      log('dateEvent    : ${json['dateEvent']}');
      log('strTime      : ${json['strTime']}');
      log('strTimestamp : ${json['strTimestamp']}');
      log('strStatus    : ${json['strStatus']}');
      log('=================================================');

      DateTime kickoff;

      try {
        kickoff = DateTime.parse('${date}T${time}Z').toLocal();

        log('Parsed kickoff : $kickoff');
        log('Local kickoff  : ${kickoff.toLocal()}');
        log('UTC kickoff    : ${kickoff.toUtc()}');
      } catch (e) {
        log("Dátum formázási hiba: $e");
        kickoff = DateTime.now();
      }

      return MatchModel(
        id: int.tryParse(json['idEvent']?.toString() ?? '0') ?? 0,
        league: json['strLeague']?.toString() ?? 'Unknown',
        homeTeam: json['strHomeTeam']?.toString() ?? '',
        awayTeam: json['strAwayTeam']?.toString() ?? '',
        kickoff: kickoff,
        aiScore: 0,
        valueBet: false,
        status: _parseStatus(json['strStatus']?.toString()),
      );
    }).toList();
  }

  static MatchStatus _parseStatus(String? statusText) {
    final s = (statusText ?? '').toLowerCase();

    if (s.contains('live') || s == 'tt') {
      return MatchStatus.live;
    }

    if (s.contains('finished') || s == 'ft') {
      return MatchStatus.finished;
    }

    return MatchStatus.upcoming;
  }
}
