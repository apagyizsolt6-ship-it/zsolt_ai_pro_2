import 'package:flutter/material.dart';

/// ===========================================
/// ZSOLT AI PRO
/// Version: v1.0.0
/// File: next_matches_card.dart
/// ===========================================

class NextMatchesCard extends StatelessWidget {
  const NextMatchesCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Row(
              children: [
                Icon(
                  Icons.sports_soccer,
                  color: Color(0xFF1565FF),
                ),
                SizedBox(width: 8),
                Text(
                  'KÖVETKEZŐ MÉRKŐZÉSEK',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            SizedBox(height: 20),

            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: CircleAvatar(
                child: Icon(Icons.shield),
              ),
              title: Text('Manchester City'),
              subtitle: Text('Real Madrid'),
              trailing: Text(
                '20:45',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            Divider(),

            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: CircleAvatar(
                child: Icon(Icons.shield),
              ),
              title: Text('Barcelona'),
              subtitle: Text('Liverpool'),
              trailing: Text(
                '21:00',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
