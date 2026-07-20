/*
===========================================
ZSOLT AI PRO - TELJES FÁJL (BUILD #053)
File: lib/screens/matches_screen.dart
===========================================
*/

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/match_model.dart';
import '../services/active_leagues_service.dart';
import '../widgets/matches/match_card.dart';

enum MatchFilter { all, aiTop, valueBet, live }

class MatchesScreen extends StatefulWidget {
  const MatchesScreen({super.key});

  @override
  State<MatchesScreen> createState() => _MatchesScreenState();
}

class _MatchesScreenState extends State<MatchesScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ActiveLeaguesService _service = ActiveLeaguesService();

  List<MatchModel> _matches = [];
  bool _loading = true;
  String? _error;
  String _searchText = '';
  MatchFilter _selectedFilter = MatchFilter.all;

  @override
  void initState() {
    super.initState();
    _loadMatches();
  }

  Future<void> _loadMatches() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final matches = await _service.loadMatches();
      if (!mounted) return;
      setState(() {
        _matches = matches;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = e.toString();
      });
    }
  }

  List<MatchModel> get _filteredMatches {
    List<MatchModel> matches = List.from(_matches);
    if (_searchText.isNotEmpty) {
      final query = _searchText.toLowerCase();
      matches = matches.where((m) => m.homeTeam.toLowerCase().contains(query) || m.awayTeam.toLowerCase().contains(query) || m.league.toLowerCase().contains(query)).toList();
    }
    switch (_selectedFilter) {
      case MatchFilter.all: break;
      case MatchFilter.aiTop: matches = matches.where((m) => m.aiScore >= 90).toList(); break;
      case MatchFilter.valueBet: matches = matches.where((m) => m.valueBet).toList(); break;
      case MatchFilter.live: matches = matches.where((m) => m.status == MatchStatus.live).toList(); break;
    }
    return matches;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final matches = _filteredMatches;
    final Map<String, List<MatchModel>> groupedMatches = {};

    for (final match in matches) {
      final localDate = match.kickoff.toLocal();
      final dateKey = DateFormat('yyyy-MM-dd').format(localDate);
      groupedMatches.putIfAbsent(dateKey, () => []).add(match);
    }
    final sortedKeys = groupedMatches.keys.toList()..sort();

    return Scaffold(
      backgroundColor: const Color(0xFF0E1117),
      appBar: AppBar(elevation: 0, backgroundColor: const Color(0xFF0E1117), centerTitle: true, title: const Text("Mérkőzések", style: TextStyle(fontWeight: FontWeight.bold))),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : (_error != null
              ? Center(child: Padding(padding: const EdgeInsets.all(24), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [const Icon(Icons.cloud_off, color: Colors.red, size: 70), const SizedBox(height: 20), const Text("Hiba történt.", style: TextStyle(color: Colors.white)), const SizedBox(height: 20), ElevatedButton(onPressed: _loadMatches, child: const Text("Újra"))])))
              : RefreshIndicator(
                  onRefresh: _loadMatches,
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      const Text("Mérkőzések", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 20),
                      TextField(controller: _searchController, onChanged: (value) => setState(() => _searchText = value), decoration: InputDecoration(hintText: "Keresés...", prefixIcon: const Icon(Icons.search), filled: true, fillColor: Colors.white10, border: OutlineInputBorder(borderRadius: BorderRadius.circular(18), borderSide: BorderSide.none))),
                      const SizedBox(height: 18),
                      SizedBox(height: 44, child: ListView(scrollDirection: Axis.horizontal, children: [_chip("Összes", MatchFilter.all), const SizedBox(width: 10), _chip("AI TOP", MatchFilter.aiTop), const SizedBox(width: 10), _chip("VALUE BET", MatchFilter.valueBet), const SizedBox(width: 10), _chip("Élő", MatchFilter.live)])),
                      const SizedBox(height: 22),
                      if (matches.isEmpty) const Center(child: Padding(padding: EdgeInsets.all(30), child: Text("Nincs találat", style: TextStyle(color: Colors.white54))))
                      else ...sortedKeys.map((date) {
                        final dailyMatches = groupedMatches[date]!;
                        return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Padding(padding: const EdgeInsets.symmetric(vertical: 16), child: Text(date, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold))),
                          ...dailyMatches.map((match) => MatchCard(league: match.league, homeTeam: match.homeTeam, awayTeam: match.awayTeam, kickoff: match.kickoff.toLocal(), aiScore: match.aiScore, isValueBet: match.valueBet)),
                        ]);
                      }),
                    ],
                  ),
                )),
    );
  }

  Widget _chip(String text, MatchFilter filter) {
    final selected = _selectedFilter == filter;
    return GestureDetector(
      onTap: () => setState(() => _selectedFilter = filter),
      child: AnimatedContainer(duration: const Duration(milliseconds: 200), padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10), decoration: BoxDecoration(color: selected ? const Color(0xFF1565FF) : Colors.white10, borderRadius: BorderRadius.circular(22)), child: Text(text, style: TextStyle(color: selected ? Colors.white : Colors.white70, fontWeight: FontWeight.bold))),
    );
  }
}
