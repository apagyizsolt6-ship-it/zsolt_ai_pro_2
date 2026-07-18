import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

/// ===========================================
/// ZSOLT AI PRO
/// Version: v3.0.0
/// File: api_service.dart
///
/// TheSportsDB Premium V2 API
/// ===========================================

class ApiService {
  ApiService({
    required this.apiKey,
  });

  final String apiKey;

  static const String _baseUrl =
      'https://www.thesportsdb.com/api/v2/json';

  static const Duration _timeout =
      Duration(seconds: 20);

  Map<String, String> get _headers => {
        'X-API-KEY': apiKey,
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      };

  /// ==========================================================
  /// Generic GET
  /// ==========================================================

  Future<Map<String, dynamic>> _get(
    String endpoint,
  ) async {
    final uri = Uri.parse(
      '$_baseUrl$endpoint',
    );

    try {
      final response = await http
          .get(
            uri,
            headers: _headers,
          )
          .timeout(_timeout);

      if (response.statusCode != 200) {
        throw ApiException(
          'HTTP ${response.statusCode}\n${response.body}',
        );
      }

      return jsonDecode(
        response.body,
      ) as Map<String, dynamic>;
    } on TimeoutException {
      throw const ApiException(
        'Időtúllépés.',
      );
    } on http.ClientException catch (e) {
      throw ApiException(
        e.message,
      );
    } catch (e) {
      throw ApiException(
        e.toString(),
      );
    }
  }

  /// ==========================================================
  /// LIVE SCORE
  /// ==========================================================

  Future<List<dynamic>> getLiveSoccer() async {
    final json = await _get(
      '/livescore/soccer',
    );

    return List<dynamic>.from(
      json['event'] ?? [],
    );
  }

  Future<List<dynamic>> getLeagueLive(
    int leagueId,
  ) async {
    final json = await _get(
      '/livescore/$leagueId',
    );

    return List<dynamic>.from(
      json['event'] ?? [],
    );
  }

  /// ==========================================================
  /// NEXT MATCHES
  /// ==========================================================

  Future<List<dynamic>> getNextLeagueMatches(
    int leagueId,
  ) async {
    final json = await _get(
      '/schedule/next/league/$leagueId',
    );

    return List<dynamic>.from(
      json['events'] ?? [],
    );
  }

  Future<List<dynamic>> getPreviousLeagueMatches(
    int leagueId,
  ) async {
    final json = await _get(
      '/schedule/previous/league/$leagueId',
    );

    return List<dynamic>.from(
      json['events'] ?? [],
    );
  }

  Future<List<dynamic>> getNextTeamMatches(
    int teamId,
  ) async {
    final json = await _get(
      '/schedule/next/team/$teamId',
    );

    return List<dynamic>.from(
      json['events'] ?? [],
    );
  }

  Future<List<dynamic>> getPreviousTeamMatches(
    int teamId,
  ) async {
    final json = await _get(
      '/schedule/previous/team/$teamId',
    );

    return List<dynamic>.from(
      json['events'] ?? [],
    );
  }  /// ==========================================================
  /// EVENT DETAILS
  /// ==========================================================

  Future<Map<String, dynamic>?> getEvent(
    int eventId,
  ) async {
    final json = await _get(
      '/lookup/event/$eventId',
    );

    final events = List<dynamic>.from(
      json['event'] ?? [],
    );

    if (events.isEmpty) return null;

    return events.first as Map<String, dynamic>;
  }

  /// ==========================================================
  /// EVENT STATS
  /// ==========================================================

  Future<List<dynamic>> getEventStats(
    int eventId,
  ) async {
    final json = await _get(
      '/lookup/event_stats/$eventId',
    );

    return List<dynamic>.from(
      json['statistics'] ?? [],
    );
  }

  /// ==========================================================
  /// EVENT TIMELINE
  /// ==========================================================

  Future<List<dynamic>> getEventTimeline(
    int eventId,
  ) async {
    final json = await _get(
      '/lookup/event_timeline/$eventId',
    );

    return List<dynamic>.from(
      json['timeline'] ?? [],
    );
  }

  /// ==========================================================
  /// EVENT LINEUP
  /// ==========================================================

  Future<List<dynamic>> getEventLineup(
    int eventId,
  ) async {
    final json = await _get(
      '/lookup/event_lineup/$eventId',
    );

    return List<dynamic>.from(
      json['lineup'] ?? [],
    );
  }

  /// ==========================================================
  /// EVENT RESULTS
  /// ==========================================================

  Future<List<dynamic>> getEventResults(
    int eventId,
  ) async {
    final json = await _get(
      '/lookup/event_results/$eventId',
    );

    return List<dynamic>.from(
      json['results'] ?? [],
    );
  }

  /// ==========================================================
  /// TV
  /// ==========================================================

  Future<List<dynamic>> getEventTv(
    int eventId,
  ) async {
    final json = await _get(
      '/lookup/event_tv/$eventId',
    );

    return List<dynamic>.from(
      json['tv'] ?? [],
    );
  }

  /// ==========================================================
  /// YOUTUBE HIGHLIGHTS
  /// ==========================================================

  Future<List<dynamic>> getEventHighlights(
    int eventId,
  ) async {
    final json = await _get(
      '/lookup/event_highlights/$eventId',
    );

    return List<dynamic>.from(
      json['highlights'] ?? [],
    );
  }

  /// ==========================================================
  /// VENUE
  /// ==========================================================

  Future<Map<String, dynamic>?> getVenue(
    int venueId,
  ) async {
    final json = await _get(
      '/lookup/venue/$venueId',
    );

    final venues = List<dynamic>.from(
      json['venues'] ?? [],
    );

    if (venues.isEmpty) return null;

    return venues.first as Map<String, dynamic>;
  }  /// ==========================================================
  /// LEAGUE DETAILS
  /// ==========================================================

  Future<Map<String, dynamic>?> getLeague(
    int leagueId,
  ) async {
    final json = await _get(
      '/lookup/league/$leagueId',
    );

    final leagues = List<dynamic>.from(
      json['leagues'] ?? [],
    );

    if (leagues.isEmpty) return null;

    return leagues.first as Map<String, dynamic>;
  }

  /// ==========================================================
  /// LEAGUE TEAMS
  /// ==========================================================

  Future<List<dynamic>> getLeagueTeams(
    int leagueId,
  ) async {
    final json = await _get(
      '/list/teams/$leagueId',
    );

    return List<dynamic>.from(
      json['teams'] ?? [],
    );
  }

  /// ==========================================================
  /// LEAGUE SEASONS
  /// ==========================================================

  Future<List<dynamic>> getLeagueSeasons(
    int leagueId,
  ) async {
    final json = await _get(
      '/list/seasons/$leagueId',
    );

    return List<dynamic>.from(
      json['seasons'] ?? [],
    );
  }

  /// ==========================================================
  /// LEAGUE TABLE
  /// ==========================================================

  Future<List<dynamic>> getLeagueTable(
    int leagueId,
    String season,
  ) async {
    final json = await _get(
      '/lookuptable/$leagueId/$season',
    );

    return List<dynamic>.from(
      json['table'] ?? [],
    );
  }

  /// ==========================================================
  /// TEAM DETAILS
  /// ==========================================================

  Future<Map<String, dynamic>?> getTeam(
    int teamId,
  ) async {
    final json = await _get(
      '/lookup/team/$teamId',
    );

    final teams = List<dynamic>.from(
      json['teams'] ?? [],
    );

    if (teams.isEmpty) return null;

    return teams.first as Map<String, dynamic>;
  }

  /// ==========================================================
  /// TEAM PLAYERS
  /// ==========================================================

  Future<List<dynamic>> getPlayers(
    int teamId,
  ) async {
    final json = await _get(
      '/list/players/$teamId',
    );

    return List<dynamic>.from(
      json['player'] ?? [],
    );
  }

  /// ==========================================================
  /// FULL LEAGUE SCHEDULE
  /// ==========================================================

  Future<List<dynamic>> getLeagueSchedule(
    int leagueId,
    String season,
  ) async {
    final json = await _get(
      '/schedule/league/$leagueId/$season',
    );

    return List<dynamic>.from(
      json['events'] ?? [],
    );
  }

  /// ==========================================================
  /// FULL TEAM SCHEDULE
  /// ==========================================================

  Future<List<dynamic>> getTeamSchedule(
    int teamId,
  ) async {
    final json = await _get(
      '/schedule/full/team/$teamId',
    );

    return List<dynamic>.from(
      json['events'] ?? [],
    );
  }  /// ==========================================================
  /// SEARCH TEAM
  /// ==========================================================

  Future<List<dynamic>> searchTeam(
    String teamName,
  ) async {
    final json = await _get(
      '/search/team/$teamName',
    );

    return List<dynamic>.from(
      json['teams'] ?? [],
    );
  }

  /// ==========================================================
  /// SEARCH LEAGUE
  /// ==========================================================

  Future<List<dynamic>> searchLeague(
    String leagueName,
  ) async {
    final json = await _get(
      '/search/league/$leagueName',
    );

    return List<dynamic>.from(
      json['countries'] ?? [],
    );
  }

  /// ==========================================================
  /// SEARCH PLAYER
  /// ==========================================================

  Future<List<dynamic>> searchPlayer(
    String playerName,
  ) async {
    final json = await _get(
      '/search/player/$playerName',
    );

    return List<dynamic>.from(
      json['player'] ?? [],
    );
  }

  /// ==========================================================
  /// SPORTS
  /// ==========================================================

  Future<List<dynamic>> getSports() async {
    final json = await _get(
      '/all_sports.php',
    );

    return List<dynamic>.from(
      json['sports'] ?? [],
    );
  }

  /// ==========================================================
  /// COUNTRIES
  /// ==========================================================

  Future<List<dynamic>> getCountries() async {
    final json = await _get(
      '/all_countries.php',
    );

    return List<dynamic>.from(
      json['countries'] ?? [],
    );
  }

  /// ==========================================================
  /// DEBUG
  /// ==========================================================

  Future<void> testConnection() async {
    try {
      await getLiveSoccer();
      print('✅ TheSportsDB kapcsolat sikeres.');
    } catch (e) {
      print('❌ TheSportsDB hiba: $e');
    }
  }

  /// ==========================================================
  /// HELPERS
  /// ==========================================================

  String? asString(
    dynamic value,
  ) {
    if (value == null) return null;
    return value.toString();
  }

  int? asInt(
    dynamic value,
  ) {
    if (value == null) return null;

    if (value is int) return value;

    return int.tryParse(
      value.toString(),
    );
  }

  double? asDouble(
    dynamic value,
  ) {
    if (value == null) return null;

    if (value is double) return value;

    if (value is int) return value.toDouble();

    return double.tryParse(
      value.toString(),
    );
  }

  bool asBool(
    dynamic value,
  ) {
    if (value == null) return false;

    if (value is bool) return value;

    final text = value
        .toString()
        .toLowerCase();

    return text == '1' ||
        text == 'true' ||
        text == 'yes';
  }}

/// ===========================================
/// API EXCEPTION
/// ===========================================

class ApiException implements Exception {
  final String message;

  const ApiException(this.message);

  @override
  String toString() => 'ApiException: $message';
}
