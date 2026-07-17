import 'package:flutter/material.dart';

/// ===========================================
/// ZSOLT AI PRO
/// Version: v1.0.0
/// File: h2h_card.dart
/// ===========================================

class H2HCard extends StatelessWidget {
  final int homeWins;
  final int draws;
  final int awayWins;

  const H2HCard({
    super.key,
    required this.homeWins,
    required this.draws,
    required this.awayWins,
  });

  Widget _buildItem(
    String title,
    int value,
    Color color,
  ) {
    return Expanded(
      child: Column(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: color,
            child: Text(
              value.toString(),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
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
                  Icons.history,
                  color: Colors.indigo,
                ),
                SizedBox(width: 8),
                Text(
                  "Egymás elleni mérleg",
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
                _buildItem(
                  "Hazai",
                  homeWins,
                  Colors.green,
                ),
                _buildItem(
                  "Döntetlen",
                  draws,
                  Colors.orange,
                ),
                _buildItem(
                  "Vendég",
                  awayWins,
                  Colors.red,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
