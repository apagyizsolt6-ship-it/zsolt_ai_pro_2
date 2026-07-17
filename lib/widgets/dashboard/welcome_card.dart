import 'package:flutter/material.dart';

/// ===========================================
/// ZSOLT AI PRO
/// Version: v1.0.1
/// File: welcome_card.dart
/// ===========================================

class WelcomeCard extends StatelessWidget {
  const WelcomeCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF1565FF),
            Color(0xFF7B3FFF),
          ],
        ),
        boxShadow: const [
          BoxShadow(
            blurRadius: 18,
            offset: Offset(0, 8),
            color: Color(0x331565FF),
          ),
        ],
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.psychology_alt_rounded,
                color: Colors.white,
                size: 26,
              ),
              SizedBox(width: 10),
              Text(
                'Üdvözöl a',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 18,
                ),
              ),
            ],
          ),

          SizedBox(height: 12),

          Text(
            'ZSOLT AI PRO',
            style: TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),

          SizedBox(height: 18),

          Text(
            '⚽ A mesterséges intelligencia készen áll a mai mérkőzések elemzésére.',
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
              height: 1.5,
            ),
          ),

          SizedBox(height: 18),

          Divider(
            color: Colors.white24,
          ),

          SizedBox(height: 10),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _InfoItem(
                icon: Icons.sports_soccer,
                label: 'Meccsek',
              ),
              _InfoItem(
                icon: Icons.auto_awesome,
                label: 'AI',
              ),
              _InfoItem(
                icon: Icons.receipt_long,
                label: 'Szelvény',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoItem({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          icon,
          color: Colors.white,
          size: 22,
        ),
        SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(
            color: Colors.white70,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
