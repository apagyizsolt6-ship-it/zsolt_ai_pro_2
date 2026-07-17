import 'package:flutter/material.dart';

/// ===========================================
/// ZSOLT AI PRO
/// Version: v1.0.0
/// File: form_card.dart
/// ===========================================

class FormCard extends StatelessWidget {
  final String homeTeam;
  final String awayTeam;
  final String homeForm;
  final String awayForm;

  const FormCard({
    super.key,
    required this.homeTeam,
    required this.awayTeam,
    required this.homeForm,
    required this.awayForm,
  });

  Color _resultColor(String result) {
    switch (result.toUpperCase()) {
      case 'W':
        return Colors.green;
      case 'D':
        return Colors.orange;
      case 'L':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Widget _buildFormRow(String team, String form) {
    final results = form.split('');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          team,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: results.map((result) {
            return Container(
              width: 34,
              height: 34,
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                color: _resultColor(result),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  result.toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
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
                  Icons.local_fire_department,
                  color: Colors.deepOrange,
                ),
                SizedBox(width: 8),
                Text(
                  'Csapatforma',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildFormRow(homeTeam, homeForm),
            const SizedBox(height: 24),
            _buildFormRow(awayTeam, awayForm),
          ],
        ),
      ),
    );
  }
}
