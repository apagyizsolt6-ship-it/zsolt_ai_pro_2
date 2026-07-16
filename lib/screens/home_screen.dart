import 'package:flutter/material.dart';

import '../widgets/dashboard/ai_top_card.dart';
import '../widgets/dashboard/camera_card.dart';
import '../widgets/dashboard/next_matches_card.dart';
import '../widgets/dashboard/ticket_card.dart';
import '../widgets/dashboard/welcome_card.dart';

/// ===========================================
/// ZSOLT AI PRO
/// Version: v1.0.0
/// File: home_screen.dart
/// ===========================================

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E1117),

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'ZSOLT AI PRO',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: const [
              WelcomeCard(),

              SizedBox(height: 16),

              AiTopCard(),

              SizedBox(height: 16),

              NextMatchesCard(),

              SizedBox(height: 16),

              CameraCard(),

              SizedBox(height: 16),

              TicketCard(),
            ],
          ),
        ),
      ),
    );
  }
}
