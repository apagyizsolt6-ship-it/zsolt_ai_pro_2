/*
===========================================
ZSOLT AI PRO - API SERVICE (TELJES, EREDETI + BŐVÍTETT)
File: lib/services/api_service.dart
===========================================
*/
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import '../config/config.dart';

class ApiService {
  ApiService({String? apiKey}) : apiKey = apiKey ?? AppConfig.sportsDbApiKey;
  final String apiKey;
  static const String _baseUrl = 'https://www.thesportsdb.com/api/v1/json/';
  static const Duration _timeout = Duration(seconds: 20);

  Future<Map<String, dynamic>> _get(String endpoint) async {
    if (apiKey.isEmpty) throw ApiException('TheSportsDB API kulcs nincs beállítva.');
    final Uri uri = Uri.parse('$_baseUrl$apiKey/$endpoint');
    final HttpClient client = HttpClient()..connectionTimeout = _timeout;
    try {
      final HttpClientRequest request = await client.getUrl(uri).timeout(_timeout);
      final HttpClientResponse response = await request.close().timeout(_timeout);
      final String body = await response.transform(utf8.decoder).join();
      if (response.statusCode != 200) throw ApiException('HTTP ${response.statusCode}');
      final decoded = jsonDecode(body);
      if (decoded is! Map<String, dynamic>) throw ApiException('Érvénytelen API válasz.');
      return decoded;
    } on SocketException catch (e) { throw ApiException('SocketException: $e'); }
    on TimeoutException catch (e) { throw ApiException('TimeoutException: $e'); }
    finally { client.close(force: true); }
  }

  // --- AZ ÚJ DÁTUM ALAPÚ METÓDUS ---
  Future<List<dynamic>> getMatchesByDate(String date) async {
    final json = await _get('eventsday.php?d=$date');
    return json['events'] as List<dynamic>? ?? [];
  }

  // --- EREDETI METÓDUSAID (SEMMI SEM MARADT KI) ---
  Future<List<Map<String, dynamic>>> getNextLeagueMatches(int leagueId) async {
    final json = await _get('eventsnextleague.php?id=$leagueId');
    return (json['events'] as List<dynamic>? ?? []).cast<Map<String, dynamic>>();
  }

  Future<List<Map<String, dynamic>>> getLiveSoccer() async {
    final json = await _get('eventslive.php?s=Soccer');
    return (json['events'] as List<dynamic>? ?? []).cast<Map<String, dynamic>>();
  }

  Future<List<Map<String, dynamic>>> searchTeam(String teamName) async {
    final json = await _get('searchteams.php?t=$teamName');
    return (json['teams'] as List<dynamic>? ?? []).cast<Map<String, dynamic>>();
  }

  Future<List<Map<String, dynamic>>> getLeagueTeams(int leagueId) async {
    final json = await _get('lookup_all_teams.php?id=$leagueId');
    return (json['teams'] as List<dynamic>? ?? []).cast<Map<String, dynamic>>();
  }

  Future<Map<String, dynamic>?> getEvent(int eventId) async {
    final json = await _get('lookupevent.php?id=$eventId');
    final list = json['events'] as List<dynamic>? ?? [];
    return list.isNotEmpty ? list.first as Map<String, dynamic> : null;
  }

  Future<Map<String, dynamic>?> getTeam(int teamId) async {
    final json = await _get('lookupteam.php?id=$teamId');
    final teams = json['teams'] as List<dynamic>? ?? [];
    return teams.isNotEmpty ? teams.first as Map<String, dynamic> : null;
  }

  Future<Map<String, dynamic>?> getLeague(int leagueId) async {
    final json = await _get('lookupleague.php?id=$leagueId');
    final leagues = json['leagues'] as List<dynamic>? ?? [];
    return leagues.isNotEmpty ? leagues.first as Map<String, dynamic> : null;
  }

  Future<List<Map<String, dynamic>>> getAllLeagues() async {
    final json = await _get('all_leagues.php');
    return (json['leagues'] as List<dynamic>? ?? []).cast<Map<String, dynamic>>();
  }

  Future<bool> testConnection() async {
    try { await getLiveSoccer(); return true; } catch (_) { return false; }
  }
}

class ApiException implements Exception {
  ApiException(this.message);
  final String message;
  @override
  String toString() => 'ApiException: $message';
}
