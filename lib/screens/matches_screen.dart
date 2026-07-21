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
  List<String> _hiddenLeagues = [];
  bool _loading = true;
  String? _selectedDate;
  MatchFilter _selectedFilter = MatchFilter.all;
  
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  @override
  void initState() {
    super.initState();
    _loadData();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadData({bool force = false}) async {
    setState(() => _loading = true);
    final matches = await _service.loadMatches(forceRefresh: force);
    final hidden = await _service.getHiddenLeagues();
    if (!mounted) return;
    
    final dates = matches.map((m) => DateFormat('yyyy-MM-dd').format(m.kickoff.toLocal())).toSet().toList()..sort();
    
    setState(() {
      _matches = matches;
      _hiddenLeagues = hidden;
      _selectedDate = dates.isNotEmpty ? dates.first : null;
      _loading = false;
    });
  }

  Future<void> _hideLeague(String leagueName) async {
    await _service.hideLeague(leagueName);
    final hidden = await _service.getHiddenLeagues();
    setState(() {
      _hiddenLeagues = hidden;
    });
  }

  bool _isFootball(String leagueName) {
    final lower = leagueName.toLowerCase();
    if (lower.contains('wnba') || 
        lower.contains('basketball') || 
        lower.contains('baseball') || 
        lower.contains('béisbol') || 
        lower.contains('tennis') || 
        lower.contains('hockey') || 
        lower.contains('esports') ||
        lower.contains('cricket') ||
        lower.contains('the hundred') ||
        lower.contains('nba')) {
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    // Csak a foci meccsek és a nem elrejtett ligák szűrése
    final footballMatches = _matches.where((m) => _isFootball(m.league) && !_hiddenLeagues.contains(m.league)).toList();

    final availableDates = footballMatches.map((m) => DateFormat('yyyy-MM-dd').format(m.kickoff.toLocal())).toSet().toList()..sort();
    
    final filtered = footballMatches.where((m) {
      final dateMatch = DateFormat('yyyy-MM-dd').format(m.kickoff.toLocal()) == _selectedDate;
      final isNotFinished = m.status != MatchStatus.finished;
      
      bool filterMatch = true;
      if (_selectedFilter == MatchFilter.aiTop) filterMatch = m.aiScore >= 90;
      if (_selectedFilter == MatchFilter.valueBet) filterMatch = m.valueBet;
      if (_selectedFilter == MatchFilter.live) filterMatch = m.status == MatchStatus.live;

      bool searchMatch = true;
      if (_searchQuery.isNotEmpty) {
        final home = m.homeTeam.toLowerCase();
        final away = m.awayTeam.toLowerCase();
        final league = m.league.toLowerCase();
        searchMatch = home.contains(_searchQuery) || away.contains(_searchQuery) || league.contains(_searchQuery);
      }

      return dateMatch && isNotFinished && filterMatch && searchMatch;
    }).toList();

    final Map<String, List<MatchModel>> grouped = {};
    for (var m in filtered) {
      grouped.putIfAbsent(m.league, () => []).add(m);
    }

    return Scaffold(
      backgroundColor: const Color(0xFF0E1117),
      appBar: AppBar(title: const Text("Mérkőzések"), backgroundColor: const Color(0xFF0E1117)),
      body: _loading 
        ? const Center(child: CircularProgressIndicator()) 
        : Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: TextField(
                  controller: _searchController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: "Keresés csapat vagy bajnokság szerint...",
                    hintStyle: const TextStyle(color: Colors.white54),
                    prefixIcon: const Icon(Icons.search, color: Colors.white54),
                    filled: true,
                    fillColor: Colors.white.withValues(alpha: 0.05),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                ),
              ),

              _buildDateSelector(availableDates),
              _buildFilters(),

              Expanded(
                child: grouped.isEmpty 
                  ? const Center(child: Text("Nincs találat a megadott feltételekkel", style: TextStyle(color: Colors.white54)))
                  : ListView(
                      children: grouped.entries.map((entry) {
                        final sortedMatches = entry.value..sort((a, b) => b.status.index.compareTo(a.status.index));
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start, 
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      entry.key, 
                                      style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 14)
                                    ),
                                  ),
                                  // ELREJTÉS GOMB A LIGA MELLETT
                                  GestureDetector(
                                    onTap: () => _hideLeague(entry.key),
                                    child: const Row(
                                      children: [
                                        Icon(Icons.visibility_off_rounded, size: 16, color: Colors.grey),
                                        SizedBox(width: 4),
                                        Text("Elrejtés", style: TextStyle(color: Colors.grey, fontSize: 12)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            ...sortedMatches.map((m) => MatchCard(
                              homeTeam: m.homeTeam,
                              awayTeam: m.awayTeam,
                              kickoff: m.kickoff,
                              aiScore: m.aiScore,
                              status: m.status,
                              isValueBet: m.valueBet,
                              league: entry.key,
                            )),
                          ],
                        );
                      }).toList(),
                    ),
              ),
            ],
          ),
    );
  }

  Widget _buildDateSelector(List<String> dates) => SizedBox(
        height: 60, 
        child: ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 16), 
          scrollDirection: Axis.horizontal, 
          itemCount: dates.length,
          separatorBuilder: (_, __) => const SizedBox(width: 10),
          itemBuilder: (context, i) => GestureDetector(
            onTap: () => setState(() => _selectedDate = dates[i]), 
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20), 
              decoration: BoxDecoration(
                color: _selectedDate == dates[i] ? Colors.blue : Colors.white10, 
                borderRadius: BorderRadius.circular(15)
              ), 
              alignment: Alignment.center, 
              child: Text(dates[i], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ),
        ),
      );

  Widget _buildFilters() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), 
        child: Row(
          children: [
            _chip("Összes", MatchFilter.all), const SizedBox(width: 10),
            _chip("AI TOP", MatchFilter.aiTop), const SizedBox(width: 10),
            _chip("Élő", MatchFilter.live),
          ],
        ),
      );

  Widget _chip(String text, MatchFilter filter) => GestureDetector(
        onTap: () => setState(() => _selectedFilter = filter),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), 
          decoration: BoxDecoration(
            color: _selectedFilter == filter ? Colors.blue : Colors.white10, 
            borderRadius: BorderRadius.circular(15)
          ), 
          child: Text(text, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ),
      );
}
