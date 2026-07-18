/*
===========================================
ZSOLT AI PRO
Version: v1.2.0
File: matches_screen.dart
Build: #029
===========================================
*/

import 'package:flutter/material.dart';

import '../widgets/matches/match_card.dart';

class MatchesScreen extends StatelessWidget {
  const MatchesScreen({super.key});

  static const List<String> days = [
    "Ma",
    "Holnap",
    "Hétfő",
    "Kedd",
    "Szerda",
    "Csütörtök",
    "Péntek",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E1117),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF0E1117),
        centerTitle: true,
        title: const Text(
          "Mai mérkőzések",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [

          // Fejléc
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF1565FF),
                  Color(0xFF7B3FFF),
                ],
              ),
              borderRadius: BorderRadius.circular(24),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 16),

                Text(
                  "184 mérkőzés • 28 liga • AI elemzés elérhető",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          TextField(
            decoration: InputDecoration(
              hintText: "Csapat vagy liga keresése...",
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: Colors.white10,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide.none,
              ),
            ),
          ),

          const SizedBox(height: 18),

          SizedBox(
            height: 44,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _chip("Összes", true),
                const SizedBox(width: 10),
                _chip("AI TOP", false),
                const SizedBox(width: 10),
                _chip("VALUE BET", false),
                const SizedBox(width: 10),
                _chip("Élő", false),
              ],
            ),
          ),

          const SizedBox(height: 22),

          _leagueHeader(
            "Premier League",
            4,
            Colors.orange,
          ),

          const SizedBox(height: 12),

          const MatchCard(
            league: "Premier League",
            homeTeam: "Liverpool",
            awayTeam: "Manchester City",
            kickoff: "18:30",
            aiScore: 94,
            isValueBet: true,
          ),

          const MatchCard(
            league: "Premier League",
            homeTeam: "Arsenal",
            awayTeam: "Chelsea",
            kickoff: "20:45",
            aiScore: 90,
          ),          const MatchCard(
            league: "Premier League",
            homeTeam: "Tottenham",
            awayTeam: "Newcastle",
            kickoff: "21:00",
            aiScore: 87,
          ),

          const MatchCard(
            league: "Premier League",
            homeTeam: "Aston Villa",
            awayTeam: "Brighton",
            kickoff: "21:00",
            aiScore: 82,
          ),

          const SizedBox(height: 24),

          _leagueHeader(
            "La Liga",
            3,
            Colors.red,
          ),

          const SizedBox(height: 12),

          const MatchCard(
            league: "La Liga",
            homeTeam: "Real Madrid",
            awayTeam: "Barcelona",
            kickoff: "21:00",
            aiScore: 91,
            isValueBet: true,
          ),

          const MatchCard(
            league: "La Liga",
            homeTeam: "Atletico Madrid",
            awayTeam: "Sevilla",
            kickoff: "19:30",
            aiScore: 84,
          ),

          const MatchCard(
            league: "La Liga",
            homeTeam: "Villarreal",
            awayTeam: "Real Betis",
            kickoff: "18:00",
            aiScore: 79,
          ),

          const SizedBox(height: 24),

          _leagueHeader(
            "Serie A",
            3,
            Colors.green,
          ),

          const SizedBox(height: 12),

          const MatchCard(
            league: "Serie A",
            homeTeam: "Inter",
            awayTeam: "Juventus",
            kickoff: "20:45",
            aiScore: 89,
          ),

          const MatchCard(
            league: "Serie A",
            homeTeam: "Milan",
            awayTeam: "Napoli",
            kickoff: "18:30",
            aiScore: 86,
          ),

          const MatchCard(
            league: "Serie A",
            homeTeam: "Roma",
            awayTeam: "Lazio",
            kickoff: "21:00",
            aiScore: 83,
          ),
        ],
      ),
    );
  }

  Widget _chip(String text, bool selected) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: selected
            ? const Color(0xFF1565FF)
            : Colors.white10,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: selected ? Colors.white : Colors.white70,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

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
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 6,
          ),
          decoration: BoxDecoration(
            color: Colors.white10,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
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
