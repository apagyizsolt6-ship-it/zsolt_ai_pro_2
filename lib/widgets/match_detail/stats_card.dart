import 'package:flutter/material.dart';

/// ===========================================
/// ZSOLT AI PRO
/// Version: v1.0.0
/// File: stats_card.dart
/// ===========================================

class StatsCard extends StatelessWidget {
  final int homeForm;
  final int awayForm;
  final double over25;
  final double btts;

  const StatsCard({
    super.key,
    required this.homeForm,
    required this.awayForm,
    required this.over25,
    required this.btts,
  });

  Widget _buildStatRow(
    IconData icon,
    String title,
    String value,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(
            icon,
            color: Colors.blue,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormRow(
    String title,
    int value,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          LinearProgressIndicator(
            value: value / 100,
            minHeight: 8,
            borderRadius: BorderRadius.circular(20),
          ),
          const SizedBox(height: 4),
          Align(
            alignment: Alignment.centerRight,
            child: Text("$value%"),
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
                  Icons.bar_chart_rounded,
                  color: Colors.deepPurple,
                ),
                SizedBox(width: 8),
                Text(
                  "Statisztikák",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            _buildFormRow(
              "Hazai forma",
              homeForm,
            ),

            _buildFormRow(
              "Vendég forma",
              awayForm,
            ),

            const Divider(height: 28),

            _buildStatRow(
              Icons.sports_soccer,
              "Over 2.5",
              "${over25.toStringAsFixed(0)}%",
            ),

            _buildStatRow(
              Icons.compare_arrows_rounded,
              "Mindkét csapat gólt szerez",
              "${btts.toStringAsFixed(0)}%",
            ),
          ],
        ),
      ),
    );
  }
}
