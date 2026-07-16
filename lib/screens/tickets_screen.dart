/*
===========================================
ZSOLT AI PRO
Version: v1.0.0
File: tickets_screen.dart
===========================================
*/

import 'package:flutter/material.dart';

class TicketsScreen extends StatelessWidget {
  const TicketsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E1117),
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Szelvényeim'),
      ),
      body: const Center(
        child: Text(
          'A mentett szelvények hamarosan...',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
      ),
    );
  }
}
