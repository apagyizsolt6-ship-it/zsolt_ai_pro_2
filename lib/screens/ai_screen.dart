/*
===========================================
ZSOLT AI PRO
Version: v1.2.0
File: ai_screen.dart
===========================================
*/

import 'package:flutter/material.dart';

class AiScreen extends StatelessWidget {
  const AiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E1117),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0E1117),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'AI Elemző',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28),
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF1565FF),
                  Color(0xFF7B3CFF),
                ],
              ),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.psychology_rounded,
                      color: Colors.white,
                      size: 42,
                    ),
                    SizedBox(width: 14),
                    Expanded(
                      child: Text(
                        'AI Elemző',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 18),
                Text(
                  'A mesterséges intelligencia kiválasztotta a mai legerősebb ajánlatokat.',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                    height: 1.5,
                  ),
                ),
                SizedBox(height: 22),
                Row(
                  children: [
                    _InfoCard(
                      title: 'TOP',
                      value: '5',
                      icon: Icons.star,
                    ),
                    SizedBox(width: 12),
                    _InfoCard(
                      title: 'VALUE',
                      value: '12',
                      icon: Icons.local_fire_department,
                    ),
                    SizedBox(width: 12),
                    _InfoCard(
                      title: 'AI',
                      value: '96%',
                      icon: Icons.auto_awesome,
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          const Text(
            'Mai AI TOP 5',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),

          const SizedBox(height: 18),

          _topMatch(
            'Liverpool',
            'Arsenal',
            94,
            true,
          ),

          const SizedBox(height: 16),

          _topMatch(
            'Real Madrid',
            'Barcelona',
            91,
            true,
          ),

          const SizedBox(height: 16),

          _topMatch(
            'Inter',
            'Juventus',
            89,
            false,
          ),

          const SizedBox(height: 16),          _topMatch(
            'Manchester City',
            'Chelsea',
            88,
            false,
          ),

          const SizedBox(height: 16),

          _topMatch(
            'Milan',
            'Napoli',
            86,
            false,
          ),

          const SizedBox(height: 30),

          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: const Color(0xFF1C2230),
              borderRadius: BorderRadius.circular(24),
            ),
            child: const Row(
              children: [
                Icon(
                  Icons.auto_awesome_rounded,
                  color: Color(0xFF1565FF),
                  size: 34,
                ),
                SizedBox(width: 14),
                Expanded(
                  child: Text(
                    'Az AI Engine folyamatosan elemzi a mérkőzéseket és frissíti az ajánlásokat.',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 15,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _topMatch(
    String home,
    String away,
    int score,
    bool valueBet,
  ) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF1C2230),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(
                Icons.sports_soccer,
                color: Color(0xFF1565FF),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  '$home  vs  $away',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              if (valueBet)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.18),
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
          ),
          const SizedBox(height: 16),
          LinearProgressIndicator(
            value: score / 100,
            minHeight: 10,
            borderRadius: BorderRadius.circular(20),
            backgroundColor: Colors.white12,
            valueColor: AlwaysStoppedAnimation<Color>(
              score >= 90
                  ? Colors.green
                  : Colors.orange,
            ),
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'AI Score: $score%',
              style: const TextStyle(
                color: Colors.white70,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _InfoCard({
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 16,
        ),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: Colors.white,
            ),
            const SizedBox(height: 10),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
