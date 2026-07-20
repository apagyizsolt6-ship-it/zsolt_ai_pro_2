import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/match_model.dart';
import '../services/active_leagues_service.dart';
import '../widgets/matches/match_card.dart';

class MatchesScreen extends StatefulWidget {
  const MatchesScreen({super.key});

  @override
  State<MatchesScreen> createState() => _MatchesScreenState();
}

class _MatchesScreenState extends State<MatchesScreen> {
  final ActiveLeaguesService _service = ActiveLeaguesService();
  List<MatchModel> _matches = [];
  bool _loading = true;
  String? _selectedDate;

  @override
  void initState() {
    super.initState();
    _loadMatches();
  }

  Future<void> _loadMatches({bool force = false}) async {
    setState(() => _loading = true);
    final matches = await _service.loadMatches(forceRefresh: force);
    if (!mounted) return;
    setState(() {
      _matches = matches;
      _selectedDate = matches.isNotEmpty ? DateFormat('yyyy-MM-dd').format(matches.first.kickoff.toLocal()) : null;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // 1. Szűrés: Dátum + Befejezettek elrejtése
    final filtered = _matches.where((m) => 
      DateFormat('yyyy-MM-dd').format(m.kickoff.toLocal()) == _selectedDate &&
      m.status != MatchStatus.finished
    ).toList();

    // 2. Csoportosítás bajnokság szerint
    final Map<String, List<MatchModel>> grouped = {};
    for (var m in filtered) {
      grouped.putIfAbsent(m.league, () => []).add(m);
    }

    return Scaffold(
      backgroundColor: const Color(0xFF0E1117),
      appBar: AppBar(title: const Text("Mérkőzések"), backgroundColor: const Color(0xFF0E1117)),
      body: _loading ? const Center(child: CircularProgressIndicator()) : ListView(
        children: grouped.entries.map((entry) {
          // Élő meccsek előre rendezése
          final sortedMatches = entry.value..sort((a, b) => b.status.index.compareTo(a.status.index));
          
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(entry.key.toUpperCase(), style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 14)),
              ),
              ...sortedMatches.map((m) => MatchCard(
                homeTeam: m.homeTeam,
                awayTeam: m.awayTeam,
                kickoff: m.kickoff,
                aiScore: m.aiScore,
                status: m.status,
              )),
            ],
          );
        }).toList(),
      ),
    );
  }
}
