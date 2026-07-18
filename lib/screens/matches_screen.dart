/*
===========================================
ZSOLT AI PRO
Version: v1.2.3
File: matches_screen.dart
Build: #037
===========================================
*/

import 'package:flutter/material.dart';

import '../data/demo_matches.dart';
import '../models/match_model.dart';
import '../utils/match_formatter.dart';
import '../widgets/matches/match_card.dart';

enum MatchFilter {
  all,
  aiTop,
  valueBet,
  live,
}

class MatchesScreen extends StatefulWidget {
  const MatchesScreen({super.key});

  @override
  State<MatchesScreen> createState() => _MatchesScreenState();
}

class _MatchesScreenState extends State<MatchesScreen> {
  final TextEditingController _searchController =
      TextEditingController();

  String _searchText = '';

  MatchFilter _selectedFilter =
      MatchFilter.all;

  List<MatchModel> get _filteredMatches {
    List<MatchModel> matches =
        DemoMatches.matches;

    //==========================================
    // KERESÉS
    //==========================================

    if (_searchText.isNotEmpty) {
      final query =
          _searchText.toLowerCase();

      matches = matches.where((match) {
        return match.homeTeam
                .toLowerCase()
                .contains(query) ||
            match.awayTeam
                .toLowerCase()
                .contains(query) ||
            match.league
                .toLowerCase()
                .contains(query);
      }).toList();
    }

    //==========================================
    // SZŰRŐK
    //==========================================

    switch (_selectedFilter) {
      case MatchFilter.all:
        break;

      case MatchFilter.aiTop:
        matches = matches
            .where(
              (match) =>
                  match.aiScore >= 90,
            )
            .toList();

        break;

      case MatchFilter.valueBet:
        matches = matches
            .where(
              (match) =>
                  match.valueBet,
            )
            .toList();

        break;

      case MatchFilter.live:
        matches = matches
            .where(
              (match) =>
                  match.status ==
                  MatchStatus.live,
            )
            .toList();

        break;
    }

    return matches;
  }

  Color _leagueColor(
    String league,
  ) {
    switch (league) {
      case 'Premier League':
        return Colors.amber;

      case 'La Liga':
        return Colors.redAccent;

      case 'Serie A':
        return Colors.blueAccent;

      case 'Bundesliga':
        return Colors.orange;

      case 'NB I':
        return Colors.green;

      default:
        return Colors.white;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final matches = _filteredMatches;

    final groupedMatches =
        <String, List<MatchModel>>{};

    for (final match in matches) {
      groupedMatches.putIfAbsent(
        match.league,
        () => [],
      );

      groupedMatches[match.league]!
          .add(match);
    }

    return Scaffold(
      backgroundColor:
          const Color(0xFF0E1117),
      appBar: AppBar(
        elevation: 0,
        backgroundColor:
            const Color(0xFF0E1117),
        centerTitle: true,
        title: const Text(
          "Mai mérkőzések",
          style: TextStyle(
            fontWeight:
                FontWeight.bold,
          ),
        ),
      ),
      body: ListView(
        padding:
            const EdgeInsets.all(16),
        children: [          //==========================================
          // FEJLÉC
          //==========================================

          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF1565FF),
                  Color(0xFF7B3FFF),
                ],
              ),
              borderRadius:
                  BorderRadius.circular(24),
            ),
            child: const Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.sports_soccer_rounded,
                      color: Colors.white,
                      size: 42,
                    ),
                    SizedBox(width: 14),
                    Expanded(
                      child: Text(
                        "Mai mérkőzések",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Text(
                  "AI elemzett mérkőzések",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          //==========================================
          // KERESŐ
          //==========================================

          TextField(
            controller: _searchController,
            onChanged: (value) {
              setState(() {
                _searchText = value;
              });
            },
            decoration: InputDecoration(
              hintText:
                  "Csapat vagy liga keresése...",
              prefixIcon:
                  const Icon(Icons.search),
              suffixIcon:
                  _searchText.isEmpty
                      ? null
                      : IconButton(
                          icon: const Icon(
                            Icons.clear,
                          ),
                          onPressed: () {
                            _searchController
                                .clear();

                            setState(() {
                              _searchText =
                                  '';
                            });
                          },
                        ),
              filled: true,
              fillColor: Colors.white10,
              border: OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(
                        18),
                borderSide:
                    BorderSide.none,
              ),
            ),
          ),

          const SizedBox(height: 18),

          //==========================================
          // SZŰRŐK
          //==========================================

          SizedBox(
            height: 44,
            child: ListView(
              scrollDirection:
                  Axis.horizontal,
              children: [
                _chip(
                  "Összes",
                  MatchFilter.all,
                ),

                const SizedBox(width: 10),

                _chip(
                  "AI TOP",
                  MatchFilter.aiTop,
                ),

                const SizedBox(width: 10),

                _chip(
                  "VALUE BET",
                  MatchFilter.valueBet,
                ),

                const SizedBox(width: 10),

                _chip(
                  "Élő",
                  MatchFilter.live,
                ),
              ],
            ),
          ),

          const SizedBox(height: 22),

          if (matches.isEmpty)
            Container(
              padding:
                  const EdgeInsets.all(
                      32),
              alignment:
                  Alignment.center,
              child: const Column(
                children: [
                  Icon(
                    Icons.search_off_rounded,
                    size: 64,
                    color:
                        Colors.white38,
                  ),
                  SizedBox(height: 16),
                  Text(
                    "Nincs találat",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Próbálj másik csapatra vagy ligára keresni.",
                    textAlign:
                        TextAlign.center,
                    style: TextStyle(
                      color:
                          Colors.white60,
                    ),
                  ),
                ],
              ),
            )
          else            ...groupedMatches.entries.expand(
              (entry) {
                final league = entry.key;
                final leagueMatches =
                    entry.value;

                return [
                  _leagueHeader(
                    league,
                    leagueMatches.length,
                    _leagueColor(
                      league,
                    ),
                  ),

                  const SizedBox(
                    height: 12,
                  ),

                  ...leagueMatches.map(
                    (match) => MatchCard(
                      league:
                          match.league,
                      homeTeam:
                          match.homeTeam,
                      awayTeam:
                          match.awayTeam,
                      kickoff:
                          MatchFormatter
                              .formatTime(
                        match.kickoff,
                      ),
                      aiScore:
                          match.aiScore,
                      isValueBet:
                          match.valueBet,
                    ),
                  ),

                  const SizedBox(
                    height: 24,
                  ),
                ];
              },
            ),
        ],
      ),
    );
  }

  //==========================================
  // SZŰRŐ CHIP
  //==========================================

  Widget _chip(
    String text,
    MatchFilter filter,
  ) {
    final selected =
        _selectedFilter == filter;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFilter = filter;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(
          milliseconds: 200,
        ),
        padding:
            const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color: selected
              ? const Color(
                  0xFF1565FF,
                )
              : Colors.white10,
          borderRadius:
              BorderRadius.circular(
            22,
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: selected
                ? Colors.white
                : Colors.white70,
            fontWeight:
                FontWeight.bold,
          ),
        ),
      ),
    );
  }

  //==========================================
  // LIGA FEJLÉC
  //==========================================

  Widget _leagueHeader(
    String league,
    int count,
    Color color,
  ) {
    return Row(
      children: [
        Icon(
          Icons.emoji_events_rounded,
          color: color,
        ),

        const SizedBox(width: 8),

        Expanded(
          child: Text(
            league,
            style:
                const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight:
                  FontWeight.bold,
            ),
          ),
        ),

        Container(
          padding:
              const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 6,
          ),
          decoration: BoxDecoration(
            color: Colors.white10,
            borderRadius:
                BorderRadius.circular(
              20,
            ),
          ),          child: Text(
            "$count meccs",
            style: const TextStyle(
              color: Colors.white70,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
