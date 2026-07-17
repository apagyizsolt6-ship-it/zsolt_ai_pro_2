import 'package:flutter/material.dart';

/// ===========================================
/// ZSOLT AI PRO
/// Version: v1.0.1
/// File: ai_top_card.dart
/// ===========================================

class AiTopCard extends StatelessWidget {
  const AiTopCard({super.key});

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
                  Icons.auto_awesome,
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

            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 5,
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

            const SizedBox(height: 18),

            const Text(
              'Liverpool',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const Padding(
              padding: EdgeInsets.symmetric(vertical: 4),
              child: Text(
                'vs',
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
            ),

            const Text(
              'Arsenal',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: const LinearProgressIndicator(
                value: 0.94,
                minHeight: 10,
              ),
            ),

            const SizedBox(height: 10),

            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'AI Score',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '94%',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF7B3FFF),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 18),

            Row(
              children: List.generate(
                5,
                (index) => const Padding(
                  padding: EdgeInsets.only(right: 4),
                  child: Icon(
                    Icons.star,
                    color: Colors.amber,
                    size: 20,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.analytics_outlined),
                label: const Text('Elemzés megnyitása'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
