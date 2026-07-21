/*
===========================================
ZSOLT AI PRO - VÉGLEGES MECCSKÁRTYA (MINIMALISTA)
File: lib/widgets/matches/match_card.dart
===========================================
*/

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/match_model.dart';
import '../../screens/match_detail_screen.dart';

class MatchCard extends StatelessWidget {
  final String homeTeam;
  final String awayTeam;
  final DateTime kickoff;
  final int aiScore;
  final bool isValueBet;
  final MatchStatus status;
  final String league;

  const MatchCard({
    super.key,
    required this.homeTeam,
    required this.awayTeam,
    required this.kickoff,
    required this.aiScore,
    required this.status,
    required this.league,
    this.isValueBet = false,
  });

  @override
  Widget build(BuildContext context) {
    final bool isLive = status == MatchStatus.live;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.white10)),
      ),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => MatchDetailScreen(
                league: league,
                homeTeam: homeTeam,
                awayTeam: awayTeam,
                kickoff: kickoff,
                aiScore: aiScore,
                isValueBet: isValueBet,
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            children: [
              SizedBox(
                width: 50,
                child: Text(
                  isLive ? "ÉLŐ" : DateFormat('HH:mm').format(kickoff),
                  style: TextStyle(
                    color: isLive ? Colors.red : Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        homeTeam,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Text("-", style: TextStyle(color: Colors.white30)),
                    ),
                    Expanded(
                      child: Text(
                        awayTeam,
                        textAlign: TextAlign.right,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Text(
                "AI $aiScore%",
                style: TextStyle(
                  color: aiScore >= 90 ? Colors.green : Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
