import 'package:flutter/material.dart';

import '../../screens/match_detail_screen.dart';

/// ===========================================
/// ZSOLT AI PRO
/// Version: v1.3.0
/// File: match_card.dart
/// ===========================================

class MatchCard extends StatelessWidget {
  final String league;
  final String homeTeam;
  final String awayTeam;
  final String kickoff;
  final int aiScore;
  final bool isValueBet;
  final VoidCallback? onTap;

  const MatchCard({
    super.key,
    required this.league,
    required this.homeTeam,
    required this.awayTeam,
    required this.kickoff,
    required this.aiScore,
    this.isValueBet = false,
    this.onTap,
  });

  Color get _aiColor {
    if (aiScore >= 90) return Colors.green;
    if (aiScore >= 80) return Colors.orange;
    if (aiScore >= 70) return Colors.blue;
    return Colors.grey;
  }

  double get _progress => aiScore / 100;

  void _openMatch(BuildContext context) {
    if (onTap != null) {
      onTap!();
      return;
    }

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
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: () => _openMatch(context),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            children: [
              Row(
                children: [
                  const CircleAvatar(
                    radius: 22,
                    backgroundColor: Color(0xFF1565FF),
                    child: Icon(
                      Icons.sports_soccer_rounded,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(width: 14),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          league,
                          style: const TextStyle(
                            color: Color(0xFF1565FF),
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          "AI elemzett mérkőzés",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),

                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.star_border_rounded,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 18),

              Row(
                children: [
                  Expanded(
                    child: Text(
                      homeTeam,
                      style: const TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Text(
                    "VS",
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      awayTeam,
                      textAlign: TextAlign.end,
                      style: const TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 18),

              LinearProgressIndicator(
                value: _progress,
                minHeight: 8,
                borderRadius: BorderRadius.circular(20),
                valueColor: AlwaysStoppedAnimation(_aiColor),
                backgroundColor: Colors.grey.shade300,
              ),

              const SizedBox(height: 10),              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      color: _aiColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      "AI $aiScore%",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  if (isValueBet) ...[
                    const SizedBox(width: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.local_fire_department_rounded,
                            color: Colors.green,
                            size: 16,
                          ),
                          SizedBox(width: 6),
                          Text(
                            "VALUE BET",
                            style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  const Spacer(),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white10,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.schedule_rounded,
                          size: 16,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          kickoff,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 10),

                  const Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 16,
                    color: Colors.grey,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
