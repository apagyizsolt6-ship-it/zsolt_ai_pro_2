import 'dart:async';
import 'dart:convert';
import 'dart:io';

import '../config/config.dart';

// ===========================================
// ZSOLT AI PRO - TELJESEN JAVÍTOTT VERZIÓ
// File: lib/services/api_service.dart
// ===========================================

class ApiService {
  ApiService({
    String? apiKey,
  }) : apiKey = apiKey ?? AppConfig.sportsDbApiKey;

  final String apiKey;

  static const String _baseUrl = AppConfig.sportsDbBaseUrl;
  static const Duration _timeout = Duration(seconds: 20);

  Future<Map<String, dynamic>> _get(String endpoint) async {
    if (apiKey.isEmpty) {
      throw ApiException('TheSportsDB API kulcs nincs beállítva.');
    }

    final Uri uri = Uri.parse('$_baseUrl$endpoint');
    final HttpClient client = HttpClient();
    client.connectionTimeout = _timeout;

    try {
      final HttpClientRequest request = await client.getUrl(uri).timeout(_timeout);
      request.headers.set(HttpHeaders.acceptHeader, 'application/json');
      request.headers.set('X-API-KEY', apiKey);

      final HttpClientResponse response = await request.close().timeout(_timeout);
      final String body = await response.transform(utf8.decoder).join();

      if (response.statusCode != 200) {
        throw ApiException('HTTP ${response.statusCode}\n$body');
      }

      final decoded = jsonDecode(body);
      if (decoded is! Map<String, dynamic>) {
        throw ApiException('Érvénytelen API válasz.');
      }
      return decoded;
    } on SocketException catch (e) {
      throw ApiException('SocketException: $e');
    } on TimeoutException catch (e) {
      throw ApiException('TimeoutException: $e');
    } finally {
      client.close(force: true);
    }
  }

  // --- JAVÍTOTT METÓDUSOK A V2 SZABVÁNY SZERINT ---

  Future<List<Map<String, dynamic>>> getLiveSoccer() async {
    final json = await _get('/livescore/soccer');
    return (json['events'] as List<dynamic>? ?? []).cast<Map<String, dynamic>>();
  }

  Future<List<Map<String, dynamic>>> getNextLeagueMatches(int leagueId) async {
    final json = await _get('/schedule/next/league/$leagueId');
    return (json['events'] as List<dynamic>? ?? []).cast<Map<String, dynamic>>();
  }

  Future<List<Map<String, dynamic>>> searchTeam(String teamName) async {
    final json = await _get('/search/team/$teamName');
    return (json['teams'] as List<dynamic>? ?? []).cast<Map<String, dynamic>>();
  }

  Future<List<Map<String, dynamic>>> getLeagueTeams(int leagueId) async {
    final json = await _get('/list/teams/$leagueId');
    return (json['teams'] as List<dynamic>? ?? []).cast<Map<String, dynamic>>();
  }

  Future<Map<String, dynamic>?> getEvent(int eventId) async {
    final json = await _get('/lookup/event/$eventId');
    final list = json['events'] as List<dynamic>? ?? [];
    return list.isNotEmpty ? list.first as Map<String, dynamic> : null;
  }

  Future<Map<String, dynamic>?> getTeam(int teamId) async {
    final json = await _get('/lookup/team/$teamId');
    final teams = json['teams'] as List<dynamic>? ?? [];
    return teams.isNotEmpty ? teams.first as Map<String, dynamic> : null;
  }

  Future<Map<String, dynamic>?> getLeague(int leagueId) async {
    final json = await _get('/lookup/league/$leagueId');
    final leagues = json['leagues'] as List<dynamic>? ?? [];
    return leagues.isNotEmpty ? leagues.first as Map<String, dynamic> : null;
  }

  Future<List<Map<String, dynamic>>> getEventStats(int eventId) async {
    final json = await _get('/lookup/event_stats/$eventId');
    return (json['statistics'] as List<dynamic>? ?? []).cast<Map<String, dynamic>>();
  }

  Future<List<Map<String, dynamic>>> getEventLineup(int eventId) async {
    final json = await _get('/lookup/event_lineup/$eventId');
    return (json['lineup'] as List<dynamic>? ?? []).cast<Map<String, dynamic>>();
  }

  Future<List<Map<String, dynamic>>> getEventTimeline(int eventId) async {
    final json = await _get('/lookup/event_timeline/$eventId');
    return (json['timeline'] as List<dynamic>? ?? []).cast<Map<String, dynamic>>();
  }

  Future<List<Map<String, dynamic>>> getAllLeagues() async {
    final json = await _get('/all/leagues');
    return (json['leagues'] as List<dynamic>? ?? []).cast<Map<String, dynamic>>();
  }
}

class ApiException implements Exception {
  ApiException(this.message);
  final String message;
  @override
  String toString() => 'ApiException: $message';
}
