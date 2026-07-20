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
  String? _selectedDate;
  MatchFilter _selectedFilter = MatchFilter.all;

  // OKOS AUTOMATA: A bajnokság neveit itt tisztítjuk meg
  String _formatLeagueName(String name) {
    String clean = name
        .replaceAll("Division", "Osztály")
        .replaceAll("League", "Liga")
        .replaceAll("Friendlies", "Barátságos mérkőzések")
        .replaceAll("Premier", "Premier")
        .replaceAll("National", "Nemzeti")
        .trim();
    return clean.toUpperCase();
  }

  @override
  void initState() {
    super.initState();
    _loadMatches();
  }

  Future<void> _loadMatches({bool force = false}) async {
    setState(() => _loading = true);
    final matches = await _service.loadMatches(forceRefresh: force);
    if (!mounted) return;
    
    final dates = matches.map((m) => DateFormat('yyyy-MM-dd').format(m.kickoff.toLocal())).toSet().toList()..sort();
    
    setState(() {
      _matches = matches;
      _selectedDate = dates.isNotEmpty ? dates.first : null;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final availableDates = _matches.map((m) => DateFormat('yyyy-MM-dd').format(m.kickoff.toLocal())).toSet().toList()..sort();
    
    final filtered = _matches.where((m) {
      final dateMatch = DateFormat('yyyy-MM-dd').format(m.kickoff.toLocal()) == _selectedDate;
      final isNotFinished = m.status != MatchStatus.finished;
      bool filterMatch = true;
      if (_selectedFilter == MatchFilter.aiTop) filterMatch = m.aiScore >= 90;
      if (_selectedFilter == MatchFilter.valueBet) filterMatch = m.valueBet;
      if (_selectedFilter == MatchFilter.live) filterMatch = m.status == MatchStatus.live;
      return dateMatch && isNotFinished && filterMatch;
    }).toList();

    final Map<String, List<MatchModel>> grouped = {};
    for (var m in filtered) {
      // Itt hívjuk meg az automatikus formázót:
      final formattedName = _formatLeagueName(m.league);
      grouped.putIfAbsent(formattedName, () => []).add(m);
    }

    return Scaffold(
      backgroundColor: const Color(0xFF0E1117),
      appBar: AppBar(title: const Text("Mérkőzések"), backgroundColor: const Color(0xFF0E1117)),
      body: _loading ? const Center(child: CircularProgressIndicator()) : Column(
        children: [
          _buildDateSelector(availableDates),
          _buildFilters(),
          Expanded(child: ListView(
            children: grouped.entries.map((entry) {
              final sortedMatches = entry.value..sort((a, b) => b.status.index.compareTo(a.status.index));
              return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Padding(padding: const EdgeInsets.all(16), child: Text(entry.key, style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 14))),
                ...sortedMatches.map((m) => MatchCard(homeTeam: m.homeTeam, awayTeam: m.awayTeam, kickoff: m.kickoff, aiScore: m.aiScore, status: m.status, isValueBet: m.valueBet)),
              ]);
            }).toList(),
          )),
        ],
      ),
    );
  }

  Widget _buildDateSelector(List<String> dates) => SizedBox(height: 70, child: ListView.separated(
    padding: const EdgeInsets.symmetric(horizontal: 16), scrollDirection: Axis.horizontal, itemCount: dates.length,
    separatorBuilder: (_, __) => const SizedBox(width: 10),
    itemBuilder: (context, i) => GestureDetector(onTap: () => setState(() => _selectedDate = dates[i]), child: Container(padding: const EdgeInsets.symmetric(horizontal: 20), decoration: BoxDecoration(color: _selectedDate == dates[i] ? Colors.blue : Colors.white10, borderRadius: BorderRadius.circular(15)), alignment: Alignment.center, child: Text(dates[i], style: const TextStyle(color: Colors.white)))),
  ));

  Widget _buildFilters() => Padding(padding: const EdgeInsets.all(16), child: Row(children: [
    _chip("Összes", MatchFilter.all), const SizedBox(width: 10),
    _chip("AI TOP", MatchFilter.aiTop), const SizedBox(width: 10),
    _chip("Élő", MatchFilter.live),
  ]));

  Widget _chip(String text, MatchFilter filter) => GestureDetector(
    onTap: () => setState(() => _selectedFilter = filter),
    child: Container(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), decoration: BoxDecoration(color: _selectedFilter == filter ? Colors.blue : Colors.white10, borderRadius: BorderRadius.circular(15)), child: Text(text, style: const TextStyle(color: Colors.white))),
  );
}
