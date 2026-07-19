import 'dart:async';
import 'dart:convert';
import 'dart:io';

import '../config/config.dart';

// ===========================================
// ZSOLT AI PRO
// Version: v4.2.0
// File: lib/services/api_service.dart
//
// TheSportsDB Premium API
// HttpClient verzió
// ===========================================

class ApiService {
  ApiService({
    String? apiKey,
  }) : apiKey = apiKey ?? AppConfig.sportsDbApiKey;

  final String apiKey;

  static const String _baseUrl =
      AppConfig.sportsDbBaseUrl;

  static const Duration _timeout =
      Duration(seconds: 20);

  Future<Map<String, dynamic>> _get(
    String endpoint,
  ) async {
    if (apiKey.isEmpty) {
      throw ApiException(
        'TheSportsDB API kulcs nincs beállítva.',
      );
    }

    final Uri uri = Uri.parse(
      '$_baseUrl$endpoint',
    );

    final HttpClient client = HttpClient();
    client.connectionTimeout = _timeout;

    try {
      final HttpClientRequest request =
          await client
              .getUrl(uri)
              .timeout(_timeout);

      request.headers.set(
        HttpHeaders.acceptHeader,
        'application/json',
      );

      request.headers.set(
        'X-API-KEY',
        apiKey,
      );

      final HttpClientResponse response =
          await request
              .close()
              .timeout(_timeout);

      final String body =
          await response
              .transform(utf8.decoder)
              .join();

      if (response.statusCode != 200) {
        throw ApiException(
          'HTTP ${response.statusCode}\n$body',
        );
      }

      final decoded = jsonDecode(body);

      if (decoded is! Map<String, dynamic>) {
        throw ApiException(
          'Érvénytelen API válasz.',
        );
      }

      return decoded;
    } on SocketException catch (e) {
      throw ApiException(
        'SocketException: $e',
      );
    } on HandshakeException catch (e) {
      throw ApiException(
        'HandshakeException: $e',
      );
    } on TimeoutException catch (e) {
      throw ApiException(
        'TimeoutException: $e',
      );
    } on HttpException catch (e) {
      throw ApiException(
        'HttpException: $e',
      );
    } finally {
      client.close(force: true);
    }
  }

  // =====================================================
  // NEXT MATCHES BY LEAGUE
  // =====================================================

  Future<List<Map<String, dynamic>>> getNextLeagueMatches(
    int leagueId,
  ) async {
    final json = await _get(
      '/schedule/next/league/$leagueId',
    );

    final events =
        json['events'] as List<dynamic>? ?? [];

    return events.cast<Map<String, dynamic>>();
  }

  // =====================================================
  // EVENT DETAILS
  // =====================================================

  Future<Map<String, dynamic>?> getEvent(
    int eventId,
  ) async {
    final json = await _get(
      '/lookup/event/$eventId',
    );

    final list =
        json['event'] as List<dynamic>? ?? [];

    if (list.isEmpty) {
      return null;
    }

    return list.first
        as Map<String, dynamic>;
  }  // =====================================================
  // LIVE SOCCER
  // =====================================================

  Future<List<Map<String, dynamic>>> getLiveSoccer() async {
    final json = await _get(
      '/livescore/soccer',
    );

    final events =
        json['event'] as List<dynamic>? ?? [];

    return events.cast<Map<String, dynamic>>();
  }

  // =====================================================
  // LEAGUE TEAMS
  // =====================================================

  Future<List<Map<String, dynamic>>> getLeagueTeams(
    int leagueId,
  ) async {
    final json = await _get(
      '/list/teams/$leagueId',
    );

    final teams =
        json['teams'] as List<dynamic>? ?? [];

    return teams.cast<Map<String, dynamic>>();
  }

  // =====================================================
  // TEAM DETAILS
  // =====================================================

  Future<Map<String, dynamic>?> getTeam(
    int teamId,
  ) async {
    final json = await _get(
      '/lookup/team/$teamId',
    );

    final teams =
        json['teams'] as List<dynamic>? ?? [];

    if (teams.isEmpty) {
      return null;
    }

    return teams.first
        as Map<String, dynamic>;
  }

  // =====================================================
  // LEAGUE DETAILS
  // =====================================================

  Future<Map<String, dynamic>?> getLeague(
    int leagueId,
  ) async {
    final json = await _get(
      '/lookup/league/$leagueId',
    );

    final leagues =
        json['leagues'] as List<dynamic>? ?? [];

    if (leagues.isEmpty) {
      return null;
    }

    return leagues.first
        as Map<String, dynamic>;
  }

  // =====================================================
  // EVENT STATS
  // =====================================================

  Future<List<Map<String, dynamic>>> getEventStats(
    int eventId,
  ) async {
    final json = await _get(
      '/lookup/event_stats/$eventId',
    );

    final stats =
        json['statistics'] as List<dynamic>? ?? [];

    return stats.cast<Map<String, dynamic>>();
  }  // =====================================================
  // EVENT LINEUP
  // =====================================================

  Future<List<Map<String, dynamic>>> getEventLineup(
    int eventId,
  ) async {
    final json = await _get(
      '/lookup/event_lineup/$eventId',
    );

    final lineup =
        json['lineup'] as List<dynamic>? ?? [];

    return lineup.cast<Map<String, dynamic>>();
  }

  // =====================================================
  // EVENT TIMELINE
  // =====================================================

  Future<List<Map<String, dynamic>>> getEventTimeline(
    int eventId,
  ) async {
    final json = await _get(
      '/lookup/event_timeline/$eventId',
    );

    final timeline =
        json['timeline'] as List<dynamic>? ?? [];

    return timeline.cast<Map<String, dynamic>>();
  }

  // =====================================================
  // SEARCH TEAM
  // =====================================================

  Future<List<Map<String, dynamic>>> searchTeam(
    String teamName,
  ) async {
    final json = await _get(
      '/search/team/$teamName',
    );

    final teams =
        json['teams'] as List<dynamic>? ?? [];

    return teams.cast<Map<String, dynamic>>();
  }

  // =====================================================
  // ALL LEAGUES
  // =====================================================

  Future<List<Map<String, dynamic>>> getAllLeagues() async {
    final json = await _get(
      '/all/leagues',
    );

    final leagues =
        json['leagues'] as List<dynamic>? ?? [];

    return leagues.cast<Map<String, dynamic>>();
  }

  // =====================================================
  // TEST CONNECTION
  // =====================================================

  Future<bool> testConnection() async {
    try {
      await getLiveSoccer();
      return true;
    } catch (_) {
      return false;
    }
  }
}

class ApiException implements Exception {
  ApiException(this.message);

  final String message;

  @override
  String toString() {
    return 'ApiException: $message';
  }
}
