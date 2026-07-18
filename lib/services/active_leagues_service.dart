/*
===========================================
ZSOLT AI PRO
Version: v5.0.0
File: active_leagues_service.dart
Build: #050
===========================================
*/

import '../models/match_model.dart';
import 'api_service.dart';
import 'match_mapper.dart';

class ActiveLeaguesService {
  ActiveLeaguesService();

  final ApiService _api = ApiService();

  static const List<String> supportedLeagues = [
    'Premier League',
    'La Liga',
    'Serie A',
    'Bundesliga',
    'Ligue 1',
    'Eredivisie',
    'Primeira Liga',
    'Scottish Premiership',
    'Super Lig',
    'Belgian Pro League',
    'Super League Greece',
    'Swiss Super League',
    'Eliteserien',
    'Allsvenskan',
    'Veikkausliiga',
    'Ekstraklasa',
    'Superliga',
    'Chance Liga',
    'Liga I',
    'Parva Liga',
    'NB I',
    'Premier Division',
  ];

  Future<List<MatchModel>> loadMatches() async {
    final List<MatchModel> matches = [];

    final leagues = await _api.getAllLeagues();

    for (final league in leagues) {
      final leagueName =
          (league['strLeague'] ?? '')
              .toString()
              .trim();

      if (!supportedLeagues.contains(leagueName)) {
        continue;
      }

      final leagueId = int.tryParse(
        league['idLeague']?.toString() ?? '',
      );

      if (leagueId == null) {
        continue;
      }

      try {
        final events =
            await _api.getNextLeagueMatches(
          leagueId,
        );

        if (events.isEmpty) {
          continue;
        }

        matches.addAll(
          MatchMapper.fromSportsDbList(
            events,
          ),
        );
      } catch (_) {
        continue;
      }
    }

    matches.sort(
      (a, b) => a.kickoff.compareTo(
        b.kickoff,
      ),
    );

    final Map<int, MatchModel> unique = {};

    for (final match in matches) {
      if (match.id == 0) {
        continue;
      }

      unique[match.id] = match;
    }    return unique.values.toList()
      ..sort(
        (a, b) => a.kickoff.compareTo(
          b.kickoff,
        ),
      );
  }

  Future<List<MatchModel>> loadLiveMatches() async {
    try {
      final events =
          await _api.getLiveSoccer();

      return MatchMapper.fromSportsDbList(
        events,
      );
    } catch (_) {
      return [];
    }
  }

  Future<bool> testConnection() async {
    try {
      return await _api.testConnection();
    } catch (_) {
      return false;
    }
  }
}
