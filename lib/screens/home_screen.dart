import 'package:flutter/material.dart';
import '../models/match_model.dart';
import '../services/active_leagues_service.dart';
import '../widgets/dashboard/ai_top_card.dart';
import '../widgets/dashboard/camera_card.dart';
import '../widgets/dashboard/dashboard_app_bar.dart';
import '../widgets/dashboard/next_matches_card.dart';
import '../widgets/dashboard/ticket_card.dart';
import '../widgets/dashboard/welcome_card.dart';

/// ===========================================
/// ZSOLT AI PRO
/// Version: v1.3.0
/// File: home_screen.dart (Valós adatokkal betöltve)
/// ===========================================

class HomeScreen extends StatefulWidget {
  final Function(int)? onNavigateTab;
  
  const HomeScreen({super.key, this.onNavigateTab});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ActiveLeaguesService _service = ActiveLeaguesService();
  List<MatchModel> _matches = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadHomeData();
  }

  Future<void> _loadHomeData() async {
    setState(() => _loading = true);
    final matches = await _service.loadMatches();
    final hiddenLeagues = await _service.getHiddenLeagues();

    final filtered = matches.where((m) {
      if (hiddenLeagues.contains(m.league)) return false;
      final lower = m.league.toLowerCase();
      if (lower.contains('wnba') || 
          lower.contains('basketball') || 
          lower.contains('baseball') || 
          lower.contains('béisbol') || 
          lower.contains('tennis') || 
          lower.contains('hockey') || 
          lower.contains('esports') ||
          lower.contains('cricket') ||
          lower.contains('the hundred') ||
          lower.contains('nba')) {
        return false;
      }
      return m.status != MatchStatus.finished;
    }).toList();

    if (!mounted) return;
    setState(() {
      _matches = filtered;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    MatchModel? topMatch;
    if (_matches.isNotEmpty) {
      final sortedByAi = List<MatchModel>.from(_matches)
        ..sort((a, b) => b.aiScore.compareTo(a.aiScore));
      topMatch = sortedByAi.first;
    }

    return Scaffold(
      backgroundColor: const Color(0xFF0E1117),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _loadHomeData,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const DashboardAppBar(),
                const SizedBox(height: 24),
                const WelcomeCard(),
                const SizedBox(height: 16),
                
                // AI TOP AJÁNLAT VALÓS ADATTAL
                _loading
                    ? const Center(
                        child: Padding(
                          padding: EdgeInsets.all(30),
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : AiTopCard(match: topMatch),

                const SizedBox(height: 16),

                // KÖVETKEZŐ MÉRKŐZÉSEK VALÓS ADATOKKAL (Javítva: átadjuk a _matches listát)
                NextMatchesCard(
                  matches: _matches,
                  onViewAllPressed: () {
                    if (widget.onNavigateTab != null) {
                      widget.onNavigateTab!(1);
                    }
                  },
                ),

                const SizedBox(height: 16),
                const CameraCard(),
                const SizedBox(height: 16),
                const TicketCard(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
