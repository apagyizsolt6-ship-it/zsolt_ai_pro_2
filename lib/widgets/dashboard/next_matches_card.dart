import 'package:flutter/material.dart';
import '../../models/match_model.dart';
import '../../services/ai_engine_service.dart';
import '../../screens/match_detail_screen.dart';

/// ===========================================
/// ZSOLT AI PRO
/// Version: v2.0.0
/// File: next_matches_card.dart (Aktív AI Motor integrációval)
/// ===========================================

class NextMatchesCard extends StatelessWidget {
  final List<MatchModel> matches;
  final VoidCallback? onViewAllPressed;

  const NextMatchesCard({
    super.key,
    required this.matches,
    this.onViewAllPressed,
  });

  void _openMatch(BuildContext context, MatchModel m, int score, bool valueBet) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MatchDetailScreen(
          league: m.league,
          homeTeam: m.homeTeam,
          awayTeam: m.awayTeam,
          kickoff: '${m.kickoff.toLocal().hour.toString().padLeft(2, '0')}:${m.kickoff.toLocal().minute.toString().padLeft(2, '0')}',
          aiScore: score,
          isValueBet: valueBet,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const aiEngine = AiEngineService();
    final displayMatches = matches.take(3).toList();

    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      color: const Color(0xFF161B22),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Icon(
                      Icons.sports_soccer_rounded,
                      color: Color(0xFF3B82F6),
                      size: 24,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'KÖVETKEZŐ MÉRKŐZÉSEK',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.6,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                Text(
                  '${matches.length} meccs',
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),

            const SizedBox(height: 16),

            displayMatches.isEmpty
                ? const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Center(
                      child: Text(
                        'Nincsenek elérhető mérkőzések',
                        style: TextStyle(color: Colors.white54),
                      ),
                    ),
                  )
                : Column(
                    children: displayMatches.map((m) {
                      final aiScore = aiEngine.calculateScore(m);
                      final isValue = aiEngine.isValueBet(m);
                      final timeStr = '${m.kickoff.toLocal().hour.toString().padLeft(2, '0')}:${m.kickoff.toLocal().minute.toString().padLeft(2, '0')}';

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _matchTile(
                          context,
                          match: m,
                          score: aiScore,
                          valueBet: isValue,
                          league: m.league,
                          home: m.homeTeam,
                          away: m.awayTeam,
                          time: timeStr,
                          aiScore: aiScore,
                        ),
                      );
                    }).toList(),
                  ),

            const SizedBox(height: 8),

            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                style: TextButton.styleFrom(
                  foregroundColor: const Color(0xFF3B82F6),
                ),
                onPressed: onViewAllPressed,
                icon: const Icon(Icons.arrow_forward_rounded, size: 16),
                label: const Text(
                  'Összes meccs',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _matchTile(
    BuildContext context, {
    required MatchModel match,
    required int score,
    required bool valueBet,
    required String league,
    required String home,
    required String away,
    required String time,
    required int aiScore,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () => _openMatch(context, match, score, valueBet),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white.withValues(alpha: 0.03),
          border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
        ),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: const Color(0xFF3B82F6).withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.sports_soccer,
                color: Color(0xFF3B82F6),
                size: 22,
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    league,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 3),

                  Text(
                    '$home vs $away',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Colors.white,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 6),

                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 7,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF3B82F6).withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'AI $aiScore%',
                          style: const TextStyle(
                            color: Color(0xFF60A5FA),
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                          ),
                        ),
                      ),

                      if (valueBet) ...[
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 7,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            'VALUE',
                            style: TextStyle(
                              color: Colors.greenAccent,
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFF3B82F6).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                time,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF60A5FA),
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
