import 'package:flutter/material.dart';
import '../../models/match_model.dart';
import '../../screens/match_detail_screen.dart';

/// ===========================================
/// ZSOLT AI PRO
/// Version: v1.3.0
/// File: ai_top_card.dart (Valós adatokkal)
/// ===========================================

class AiTopCard extends StatelessWidget {
  final MatchModel? match;
  const AiTopCard({super.key, this.match});

  void _openMatch(BuildContext context, MatchModel m) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MatchDetailScreen(
          league: m.league,
          homeTeam: m.homeTeam,
          awayTeam: m.awayTeam,
          kickoff: '${m.kickoff.toLocal().hour.toString().padLeft(2, '0')}:${m.kickoff.toLocal().minute.toString().padLeft(2, '0')}',
          aiScore: m.aiScore,
          isValueBet: m.valueBet,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (match == null) {
      return Card(
        elevation: 10,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: const Padding(
          padding: EdgeInsets.all(20),
          child: Center(child: Text("Nincs elérhető AI TOP ajánlat", style: TextStyle(color: Colors.white54))),
        ),
      );
    }

    final m = match!;

    return Card(
      elevation: 10,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: () => _openMatch(context, m),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(
                    Icons.auto_awesome_rounded,
                    color: Color(0xFF7B3FFF),
                    size: 28,
                  ),
                  SizedBox(width: 10),
                  Text(
                    'AI TOP AJÁNLAT',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.6,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.deepPurple.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      '⭐ TOP PICK',
                      style: TextStyle(
                        color: Color(0xFF7B3FFF),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  if (m.valueBet) ...[
                    const SizedBox(width: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'VALUE BET',
                        style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ],
              ),

              const SizedBox(height: 24),

              Center(
                child: Text(
                  m.homeTeam,
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              const Padding(
                padding: EdgeInsets.symmetric(vertical: 6),
                child: Center(
                  child: Text(
                    'VS',
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              Center(
                child: Text(
                  m.awayTeam,
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(height: 24),

              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.deepPurple.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              const Text(
                                'AI SCORE',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                '${m.aiScore}%',
                                style: const TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF7B3FFF),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              const Text(
                                'CONFIDENCE',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                m.aiScore >= 90 ? 'HIGH' : 'MEDIUM',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 18),

                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: LinearProgressIndicator(
                        value: m.aiScore / 100.0,
                        minHeight: 10,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 22),

              Row(
                children: List.generate(
                  5,
                  (index) => const Padding(
                    padding: EdgeInsets.only(right: 4),
                    child: Icon(
                      Icons.star_rounded,
                      color: Colors.amber,
                      size: 22,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 22),

              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () => _openMatch(context, m),
                  icon: const Icon(Icons.analytics_outlined),
                  label: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 4),
                    child: Text(
                      'AI elemzés megnyitása',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
