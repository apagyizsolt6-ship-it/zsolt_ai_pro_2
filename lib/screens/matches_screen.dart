/*
===========================================
ZSOLT AI PRO
Version: v1.0.0
File: matches_screen.dart
===========================================
*/

import 'package:flutter/material.dart';

class MatchesScreen extends StatelessWidget {
  const MatchesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E1117),
      appBar: AppBar(
        title: const Text('Meccsek'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'A mai mérkőzések hamarosan...',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
      ),
    );
  }
}
