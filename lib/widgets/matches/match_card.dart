/*
===========================================
MeccsIQ Pro
Build: #013.4
Version: v1.1.4
File: match_card.dart
===========================================
*/

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;

import '../../core/cache/cache_service.dart';
import '../../core/config.dart';
import '../../core/theme/app_theme.dart';
import '../../models/match_model.dart';

class MatchCard extends StatelessWidget {
  final MatchModel match;
  final VoidCallback? onTap;

  const MatchCard({
    super.key,
    required this.match,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppTheme.surface,
      elevation: 0,
      margin: const EdgeInsets.symmetric(vertical: 1), // Minimális rés a meccsek között a listában
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero, // Teljesen lapos, letisztult sorok
      ),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 1. IDŐPONT VAGY ÉLŐ STÁTUSZ (Bal oldal)
              SizedBox(
                width: 45,
                child: Text(
                  match.status == MatchStatus.live
                      ? "ÉLŐ"
                      : "${match.kickoff.hour.toString().padLeft(2, '0')}:${match.kickoff.minute.toString().padLeft(2, '0')}",
                  style: TextStyle(
                    color: match.status == MatchStatus.live ? Colors.red : AppTheme.textSecondary,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              // 2. CSAPATOK ÉS LOGÓK (Középső rész)
              Expanded(
                child: Column(
                  children: [
                    _buildTeamRow(
                      match.homeTeam,
                      match.isUpcoming ? "-" : "${match.homeScore ?? 0}",
                    ),
                    const SizedBox(height: 6),
                    _buildTeamRow(
                      match.awayTeam,
                      match.isUpcoming ? "-" : "${match.awayScore ?? 0}",
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 12),

              // 3. AI JELZÉS ÉS ODDS (Jobb oldal)
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _buildAiScore(),
                  if (match.homeOdds != null &&
                      match.drawOdds != null &&
                      match.awayOdds != null) ...[
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        _buildOdd("1", match.homeOdds!),
                        const SizedBox(width: 4),
                        _buildOdd("X", match.drawOdds!),
                        const SizedBox(width: 4),
                        _buildOdd("2", match.awayOdds!),
                      ],
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTeamRow(String team, String score) {
    return Row(
      children: [
        _TeamLogo(teamName: team),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            team,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          score,
          style: TextStyle(
            color: score == "-" ? AppTheme.textSecondary : Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildAiScore() {
    Color color;
    if (match.aiScore >= 85) {
      color = Colors.green;
    } else if (match.aiScore >= 70) {
      color = Colors.orange;
    } else {
      color = Colors.redAccent;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        "AI ${match.aiScore}",
        style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildOdd(String title, double odd) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: AppTheme.background,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        children: [
          Text(
            "$title ",
            style: const TextStyle(color: AppTheme.textSecondary, fontSize: 9),
          ),
          Text(
            odd.toStringAsFixed(2),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
