import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

/// ===========================================
/// ZSOLT AI PRO
/// Version: v4.0.0
/// File: api_service.dart
///
/// TheSportsDB Premium API
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
      };

  Future<Map<String, dynamic>> _get(
    String endpoint,
  ) async {
    final uri = Uri.parse(
      '$_baseUrl$endpoint',
    );

    final response = await http
        .get(
          uri,
          headers: _headers,
        )
        .timeout(_timeout);

    if (response.statusCode != 200) {
      throw ApiException(
        'HTTP ${response.statusCode}',
      );
    }

    return jsonDecode(
      response.body,
    ) as Map<String, dynamic>;
  }

  /// =====================================================
  /// NEXT MATCHES BY LEAGUE
  /// =====================================================

  Future<List<Map<String, dynamic>>> getNextLeagueMatches(
    int leagueId,
  ) async {
    final json = await _get(
      '/schedule/next/league/$leagueId',
    );

    final events =
        json['events'] as List<dynamic>? ?? [];

    return events
        .cast<Map<String, dynamic>>();
  }

  /// =====================================================
  /// EVENT DETAILS
  /// =====================================================

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
  }  /// =====================================================
  /// LIVE SOCCER
  /// =====================================================

  Future<List<Map<String, dynamic>>> getLiveSoccer() async {
    final json = await _get(
      '/livescore/soccer',
    );

    final events =
        json['event'] as List<dynamic>? ?? [];

    return events
        .cast<Map<String, dynamic>>();
  }

  /// =====================================================
  /// LEAGUE TEAMS
  /// =====================================================

  Future<List<Map<String, dynamic>>> getLeagueTeams(
    int leagueId,
  ) async {
    final json = await _get(
      '/list/teams/$leagueId',
    );

    final teams =
        json['teams'] as List<dynamic>? ?? [];

    return teams
        .cast<Map<String, dynamic>>();
  }

  /// =====================================================
  /// TEAM DETAILS
  /// =====================================================

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

  /// =====================================================
  /// SEARCH TEAM
  /// =====================================================

  Future<List<Map<String, dynamic>>> searchTeam(
    String teamName,
  ) async {
    final json = await _get(
      '/search/team/$teamName',
    );

    final teams =
        json['teams'] as List<dynamic>? ?? [];

    return teams
        .cast<Map<String, dynamic>>();
  }

  /// =====================================================
  /// TEST CONNECTION
  /// =====================================================

  Future<bool> testConnection() async {
    try {
      await getLiveSoccer();
      return true;
    } catch (_) {
      return false;
    }
  }}

class ApiException implements Exception {
  ApiException(this.message);

  final String message;

  @override
  String toString() => 'ApiException: $message';
}
