import 'package:flutter/material.dart';

import '../widgets/match_detail/ai_analysis_card.dart';
import '../widgets/match_detail/stats_card.dart';
import '../widgets/match_detail/form_card.dart';

/// ===========================================
/// ZSOLT AI PRO
/// Version: v2.0.0
/// File: match_detail_screen.dart
/// ===========================================

class MatchDetailScreen extends StatelessWidget {
  final String league;
  final String homeTeam;
  final String awayTeam;
  final String kickoff;
  final int aiScore;
  final bool isValueBet;

  const MatchDetailScreen({
    super.key,
    required this.league,
    required this.homeTeam,
    required this.awayTeam,
    required this.kickoff,
    required this.aiScore,
    required this.isValueBet,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mérkőzés elemzése"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Text(
                      league,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 18),
                    Text(
                      homeTeam,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Text(
                        "VS",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    Text(
                      awayTeam,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      kickoff,
                      style: const TextStyle(
                        color: Colors.blueGrey,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            AiAnalysisCard(
              aiScore: aiScore,
              recommendation: "Hazai győzelem",
              confidence: 88,
              isValueBet: isValueBet,
            ),

            const SizedBox(height: 16),

            const StatsCard(
              homeForm: 84,
              awayForm: 76,
              over25: 68,
              btts: 72,
            ),

            const SizedBox(height: 16),

            const FormCard(
              homeTeam: "Hazai",
              awayTeam: "Vendég",
              homeForm: "WWDWL",
              awayForm: "LWWDW",
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
