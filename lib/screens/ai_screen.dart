/*
===========================================
ZSOLT AI PRO
Version: v1.0.0
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
        centerTitle: true,
        title: const Text('AI Elemző'),
      ),
      body: const Center(
        child: Text(
          'AI elemző fejlesztés alatt...',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
      ),
    );
  }
}
