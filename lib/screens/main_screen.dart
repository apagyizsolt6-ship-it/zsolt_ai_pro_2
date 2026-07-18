/*
===========================================
ZSOLT AI PRO
Version: v1.1.1
Build #030
File: main_screen.dart
===========================================
*/

import 'package:flutter/material.dart';

import 'ai_screen.dart';
import 'home_screen.dart';
import 'matches_screen.dart';
import 'tickets_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    MatchesScreen(),
    AiScreen(),
    TicketsScreen(),

    Center(
      child: Text(
        'Profil',
        style: TextStyle(
          color: Colors.white70,
          fontSize: 22,
        ),
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],

      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,

        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },

        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_rounded),
            label: 'Home',
          ),

          NavigationDestination(
            icon: Icon(Icons.sports_soccer_rounded),
            label: 'Meccsek',
          ),

          NavigationDestination(
            icon: Icon(Icons.psychology_rounded),
            label: 'AI',
          ),

          NavigationDestination(
            icon: Icon(Icons.receipt_long_rounded),
            label: 'Szelvény',
          ),

          NavigationDestination(
            icon: Icon(Icons.person_rounded),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}
