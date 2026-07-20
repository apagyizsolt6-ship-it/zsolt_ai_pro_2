/*
===========================================
ZSOLT AI PRO - DÁTUM-SZŰRŐS NAPTÁR NÉZET
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
  final ActiveLeaguesService _service = ActiveLeaguesService();
  List<MatchModel> _matches = [];
  bool _loading = true;
  String? _error;
  
  // Dátum és szűrő állapotok
  String? _selectedDate; 
  MatchFilter _selectedFilter = MatchFilter.all;

  @override
  void initState() {
    super.initState();
    _loadMatches();
  }

  Future<void> _loadMatches({bool force = false}) async {
    setState(() => _loading = true);
    try {
      final matches = await _service.loadMatches(forceRefresh: force);
      if (!mounted) return;
      
      // Alapértelmezett dátum kiválasztása (az első elérhető dátum)
      String? firstDate;
      if (matches.isNotEmpty) {
        firstDate = DateFormat('yyyy-MM-dd').format(matches.first.kickoff.toLocal());
      }

      setState(() {
        _matches = matches;
        _selectedDate = firstDate;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _loading = false);
    }
  }

  List<MatchModel> get _filteredMatches {
    return _matches.where((m) {
      final dateMatch = _selectedDate == null || DateFormat('yyyy-MM-dd').format(m.kickoff.toLocal()) == _selectedDate;
      bool filterMatch = true;
      switch (_selectedFilter) {
        case MatchFilter.all: break;
        case MatchFilter.aiTop: filterMatch = m.aiScore >= 90; break;
        case MatchFilter.valueBet: filterMatch = m.valueBet; break;
        case MatchFilter.live: filterMatch = m.status == MatchStatus.live; break;
      }
      return dateMatch && filterMatch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    // Összes elérhető dátum kigyűjtése a sávhoz
    final availableDates = _matches.map((m) => DateFormat('yyyy-MM-dd').format(m.kickoff.toLocal())).toSet().toList()..sort();

    return Scaffold(
      backgroundColor: const Color(0xFF0E1117),
      appBar: AppBar(backgroundColor: const Color(0xFF0E1117), title: const Text("Mérkőzések")),
      body: _loading 
        ? const Center(child: CircularProgressIndicator()) 
        : RefreshIndicator(
            onRefresh: () => _loadMatches(force: true),
            child: Column(
              children: [
                // 1. Dátum sáv
                SizedBox(height: 70, child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  scrollDirection: Axis.horizontal,
                  itemCount: availableDates.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 10),
                  itemBuilder: (context, i) {
                    final date = availableDates[i];
                    final isSelected = _selectedDate == date;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedDate = date),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(color: isSelected ? const Color(0xFF1565FF) : Colors.white10, borderRadius: BorderRadius.circular(15)),
                        alignment: Alignment.center,
                        child: Text(date, style: TextStyle(color: isSelected ? Colors.white : Colors.white70)),
                      ),
                    );
                  },
                )),
                // 2. Szűrők
                Padding(padding: const EdgeInsets.all(16), child: SizedBox(height: 40, child: ListView(scrollDirection: Axis.horizontal, children: [
                  _chip("Összes", MatchFilter.all), const SizedBox(width: 10),
                  _chip("AI TOP", MatchFilter.aiTop), const SizedBox(width: 10),
                  _chip("VALUE", MatchFilter.valueBet), const SizedBox(width: 10),
                  _chip("Élő", MatchFilter.live),
                ]))),
                // 3. Meccsek listája
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: _filteredMatches.map((match) => MatchCard(
                      league: match.league, 
                      homeTeam: match.homeTeam, 
                      awayTeam: match.awayTeam, 
                      kickoff: match.kickoff.toLocal(), 
                      aiScore: match.aiScore, 
                      isValueBet: match.valueBet
                    )).toList(),
                  ),
                ),
              ],
            ),
          ),
    );
  }

  Widget _chip(String text, MatchFilter filter) {
    final selected = _selectedFilter == filter;
    return GestureDetector(
      onTap: () => setState(() => _selectedFilter = filter),
      child: Container(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), decoration: BoxDecoration(color: selected ? const Color(0xFF1565FF) : Colors.white10, borderRadius: BorderRadius.circular(15)), child: Text(text, style: TextStyle(color: selected ? Colors.white : Colors.white70))),
    );
  }
}
