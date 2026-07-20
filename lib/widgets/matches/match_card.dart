import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../screens/match_detail_screen.dart';
import '../../models/match_model.dart';

class MatchCard extends StatelessWidget {
  final String homeTeam;
  final String awayTeam;
  final DateTime kickoff;
  final int aiScore;
  final bool isValueBet;
  final MatchStatus status; // Fontos: státusz lekérése

  const MatchCard({
    super.key,
    required this.homeTeam,
    required this.awayTeam,
    required this.kickoff,
    required this.aiScore,
    this.isValueBet = false,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final bool isLive = status == MatchStatus.live;

    return Card(
      elevation: 0,
      color: Colors.transparent,
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: InkWell(
        onTap: () { /* Navigáció logikád ide */ },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              // Időpont vagy Élő jelző
              SizedBox(
                width: 60,
                child: isLive 
                  ? const Text("ÉLŐ", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold))
                  : Text(DateFormat('HH:mm').format(kickoff), style: const TextStyle(fontWeight: FontWeight.bold)),
              ),
              // Csapatnevek
              Expanded(
                child: Row(
                  children: [
                    Expanded(child: Text(homeTeam, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
                    const Padding(padding: EdgeInsets.symmetric(horizontal: 8), child: Text("—", style: TextStyle(color: Colors.grey))),
                    Expanded(child: Text(awayTeam, textAlign: TextAlign.right, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              // AI Százalék
              Text("AI $aiScore%", style: TextStyle(color: aiScore > 80 ? Colors.green : Colors.grey, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }
}
