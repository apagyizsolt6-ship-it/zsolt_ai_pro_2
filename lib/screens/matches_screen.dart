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
  
  // Kereső vezérlő
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  @override
  void initState() {
    super.initState();
    _loadMatches();
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

  // --- 1. PROFI AUTOMATA MAGYARÍTÓ & FOCI SZŰRŐ RENDSZER ---
  bool _isFootball(String leagueName) {
    final lower = leagueName.toLowerCase();
    // Kizáró szűrők: ha ezeket tartalmazza, nem foci
    if (lower.contains('wnba') || 
        lower.contains('basketball') || 
        lower.contains('baseball') || 
        lower.contains('béisbol') || 
        lower.contains('tennis') || 
        lower.contains('hockey') || 
        lower.contains('esports') ||
        lower.contains('nba')) {
      return false;
    }
    return true;
  }

  String _formatLeagueName(String name) {
    // Pontos szótári fordítások a leggyakoribb ligákra
    final Map<String, String> dictionary = {
      "Club Friendlies": "Barátságos klubmérkőzések",
      "Argentinian Primera C": "Argentin Primera C",
      "Copa Paulista": "Copa Paulista",
      "Argentinian Primera B Nacional": "Argentin Primera B Nacional",
      "Argentinian Torneo Promocional Amateur": "Argentin Torneo Promocional Amateur",
      "Bulgarian First League": "Bolgár első osztály",
      "Romanian Liga I": "Román Liga I",
      "Lebanon Premier League": "Libanoni Premier League",
      "Bolivian Primera División": "Bolíviai Primera División",
      "Ecuadorian Serie A": "Ecuadori Serie A",
      "Icelandic 1 Deild Karla": "Izlandi 1. Deild Karla",
      "Icelandic Úrvalsdeild Karla": "Izlandi Úrvalsdeild Karla",
      "Uruguayan Primera Division": "Uruguayi Primera Division",
    };

    if (dictionary.containsKey(name)) {
      return dictionary[name]!.toUpperCase();
    }

    // Automata tisztítás és fordítás maradványokra
    String clean = name
        .replaceAll("Division", "Osztály")
        .replaceAll("League", "Liga")
        .replaceAll("Friendlies", "Barátságos mérkőzések")
        .replaceAll("Premier", "Premier")
        .replaceAll("National", "Nemzeti")
        .replaceAll("Supercopa", "Szuperkupa")
        .replaceAll("Cup", "Kupa")
        .trim();
        
    return clean.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    // Csak a foci meccsek szűrése a teljes listából
    final footballMatches = _matches.where((m) => _isFootball(m.league)).toList();

    final availableDates = footballMatches.map((m) => DateFormat('yyyy-MM-dd').format(m.kickoff.toLocal())).toSet().toList()..sort();
    
    // Szűrés dátum, státusz, fül (filter) és a keresőmező alapján
    final filtered = footballMatches.where((m) {
      final dateMatch = DateFormat('yyyy-MM-dd').format(m.kickoff.toLocal()) == _selectedDate;
      final isNotFinished = m.status != MatchStatus.finished;
      
      bool filterMatch = true;
      if (_selectedFilter == MatchFilter.aiTop) filterMatch = m.aiScore >= 90;
      if (_selectedFilter == MatchFilter.valueBet) filterMatch = m.valueBet;
      if (_selectedFilter == MatchFilter.live) filterMatch = m.status == MatchStatus.live;

      // Kereső szűrés (Csapatnevekre vagy bajnokságra)
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
      final formattedName = _formatLeagueName(m.league);
      grouped.putIfAbsent(formattedName, () => []).add(m);
    }

    return Scaffold(
      backgroundColor: const Color(0xFF0E1117),
      appBar: AppBar(title: const Text("Mérkőzések"), backgroundColor: const Color(0xFF0E1117)),
      body: _loading 
        ? const Center(child: CircularProgressIndicator()) 
        : Column(
            children: [
              // 2. KERESŐMEZŐ
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

              // Dátum sáv
              _buildDateSelector(availableDates),
              
              // Szűrők
              _buildFilters(),

              // Meccsek listája
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
                              padding: const EdgeInsets.all(16), 
                              child: Text(
                                entry.key, 
                                style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 14)
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
