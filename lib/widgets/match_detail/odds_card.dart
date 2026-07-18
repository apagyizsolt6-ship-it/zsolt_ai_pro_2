import 'package:flutter/material.dart';

/// ===========================================
/// ZSOLT AI PRO
/// Version: v1.0.0
/// File: odds_card.dart
/// ===========================================

class OddsCard extends StatelessWidget {
  final double homeWinOdd;
  final double drawOdd;
  final double awayWinOdd;

  const OddsCard({
    super.key,
    required this.homeWinOdd,
    required this.drawOdd,
    required this.awayWinOdd,
  });

  Widget _buildOddTile({
    required String label,
    required double odd,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: color,
            width: 1.5,
          ),
        ),
        child: Column(
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              odd.toStringAsFixed(2),
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
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
                  Icons.paid_rounded,
                  color: Colors.teal,
                ),
                SizedBox(width: 8),
                Text(
                  "Fogadási szorzók",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            Row(
              children: [
                _buildOddTile(
                  label: "1",
                  odd: homeWinOdd,
                  color: Colors.green,
                ),
                _buildOddTile(
                  label: "X",
                  odd: drawOdd,
                  color: Colors.orange,
                ),
                _buildOddTile(
                  label: "2",
                  odd: awayWinOdd,
                  color: Colors.red,
                ),
              ],
            ),

            const SizedBox(height: 20),

            const Text(
              "A szorzók később automatikusan frissülnek a kiválasztott fogadóirodák adatai alapján.",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
