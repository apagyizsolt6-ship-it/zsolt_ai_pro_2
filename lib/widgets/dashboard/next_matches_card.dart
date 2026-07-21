import 'package:flutter/material.dart';
import '../../models/match_model.dart';
import '../../screens/match_detail_screen.dart';

/// ===========================================
/// ZSOLT AI PRO
/// Version: v1.3.0
/// File: next_matches_card.dart (Valós adatokkal)
/// ===========================================

class NextMatchesCard extends StatelessWidget {
  final List<MatchModel> matches;
  final VoidCallback? onViewAllPressed;

  const NextMatchesCard({
    super.key,
    required this.matches,
    this.onViewAllPressed,
  });

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
    // Legfeljebb 3 következő meccs megjelenítése
    final displayMatches = matches.take(3).toList();

    return Card(
      elevation: 10,
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
                  Icons.sports_soccer_rounded,
                  color: Color(0xFF1565FF),
                  size: 28,
                ),
                SizedBox(width: 10),
                Text(
                  'KÖVETKEZŐ MÉRKŐZÉSEK',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.6,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

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
                      final timeStr = '${m.kickoff.toLocal().hour.toString().padLeft(2, '0')}:${m.kickoff.toLocal().minute.toString().padLeft(2, '0')}';
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 14),
                        child: _matchTile(
                          context,
                          match: m,
                          league: m.league,
                          home: m.homeTeam,
                          away: m.awayTeam,
                          time: timeStr,
                          aiScore: m.aiScore,
                          valueBet: m.valueBet,
                        ),
                      );
                    }).toList(),
                  ),

            const SizedBox(height: 10),

            Align(
              alignment: Alignment.centerRight,
              child: FilledButton.icon(
                onPressed: onViewAllPressed,
                icon: const Icon(Icons.arrow_forward),
                label: const Text('Összes meccs'),
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
    required String league,
    required String home,
    required String away,
    required String time,
    required int aiScore,
    required bool valueBet,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () => _openMatch(context, match),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: Colors.grey.withValues(alpha: 0.05),
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: const Color(0xFF1565FF).withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.sports_soccer,
                color: Color(0xFF1565FF),
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
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 4),

                  Text(
                    '$home vs $away',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 8),

                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1565FF).withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          'AI $aiScore',
                          style: const TextStyle(
                            color: Color(0xFF1565FF),
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                          ),
                        ),
                      ),

                      if (valueBet) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Text(
                            'VALUE',
                            style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(width: 12),

            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 10,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFF1565FF).withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                time,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1565FF),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
