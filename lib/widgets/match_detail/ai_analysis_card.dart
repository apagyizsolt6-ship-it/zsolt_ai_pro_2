import 'package:flutter/material.dart';

/// ===========================================
/// ZSOLT AI PRO
/// Version: v1.0.0
/// File: ai_analysis_card.dart
/// ===========================================

class AiAnalysisCard extends StatelessWidget {
  final int aiScore;
  final String recommendation;
  final int confidence;
  final bool isValueBet;

  const AiAnalysisCard({
    super.key,
    required this.aiScore,
    required this.recommendation,
    required this.confidence,
    required this.isValueBet,
  });

  Color get _scoreColor {
    if (aiScore >= 90) {
      return Colors.green;
    }

    if (aiScore >= 80) {
      return Colors.orange;
    }

    if (aiScore >= 70) {
      return Colors.blue;
    }

    return Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(
                  Icons.psychology_alt_rounded,
                  color: Colors.deepPurple,
                ),
                SizedBox(width: 8),
                Text(
                  "AI Elemzés",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            Center(
              child: CircleAvatar(
                radius: 42,
                backgroundColor: _scoreColor,
                child: Text(
                  "$aiScore%",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            ListTile(
              leading: const Icon(Icons.lightbulb_outline),
              title: const Text("AI ajánlás"),
              subtitle: Text(recommendation),
            ),

            ListTile(
              leading: const Icon(Icons.verified),
              title: const Text("Bizalmi szint"),
              subtitle: Text("$confidence%"),
            ),

            if (isValueBet)
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(top: 12),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.green.shade100,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.diamond,
                      color: Colors.green,
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        "VALUE BET lehetőség",
                        style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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
