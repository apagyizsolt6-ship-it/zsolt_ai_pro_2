/*
===========================================
ZSOLT AI PRO
Version: v1.0.4
File: matches_screen.dart
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
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF1565FF),
                    Color(0xFF7B3FFF),
                  ],
                ),
                borderRadius: BorderRadius.circular(22),
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.sports_soccer,
                    color: Colors.white,
                    size: 42,
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Mai mérkőzések",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          "Válassz napot, majd böngészd az AI által elemzett mérkőzéseket.",
                          style: TextStyle(
                            color: Colors.white70,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            SizedBox(
              height: 46,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: days.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(width: 10),
                itemBuilder: (context, index) {
                  final selected = index == 0;

                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: selected
                          ? const Color(0xFF1565FF)
                          : Colors.white10,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Text(
                      days[index],
                      style: TextStyle(
                        color: selected
                            ? Colors.white
                            : Colors.white70,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 24),

            Expanded(
              child: ListView(
                children: const [
                  MatchCard(
                    league: "Premier League",
                    homeTeam: "Liverpool",
                    awayTeam: "Manchester City",
                    kickoff: "18:30",
                    aiScore: 91,
                    isValueBet: true,
                  ),

                  MatchCard(
                    league: "La Liga",
                    homeTeam: "Real Madrid",
                    awayTeam: "Barcelona",
                    kickoff: "21:00",
                    aiScore: 88,
                  ),

                  MatchCard(
                    league: "Serie A",
                    homeTeam: "Inter",
                    awayTeam: "Juventus",
                    kickoff: "20:45",
                    aiScore: 85,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
