/*
===========================================
ZSOLT AI PRO
File: ai_engine_service.dart
===========================================
*/

import 'dart:math';
import '../models/ai_analysis_result.dart';
import '../models/match_model.dart';

class AiEngineService {
  const AiEngineService();

  // STATIKUS metódusok, hogy a kártyákból közvetlenül hívhatók legyenek
  static int calculateScore(MatchModel match) {
    if (match.aiScore > 0) return match.aiScore;

    final seedSum = match.homeTeam.codeUnits.fold(0, (a, b) => a + b) +
                    match.awayTeam.codeUnits.fold(0, (a, b) => a + b) +
                    match.league.codeUnits.fold(0, (a, b) => a + b);
    final random = Random(seedSum.toInt());

    int baseScore = 75;
    if (match.homeOdd != null && match.homeOdd! < 2.0) {
      baseScore += 8;
    } else {
      baseScore += random.nextInt(15);
    }

    return baseScore.clamp(75, 98);
  }

  static bool isValueBet(MatchModel match) {
    int score = calculateScore(match);
    if (match.valueBet) return true;
    
    if (match.homeOdd != null && match.homeOdd! >= 2.10 && score >= 85) {
      return true;
    }
    if (match.awayOdd != null && match.awayOdd! >= 3.50 && score >= 88) {
      return true;
    }

    final seed = match.homeTeam.length + match.awayTeam.length + score;
    return seed % 4 == 0 || score >= 92;
  }

  static AiAnalysisResult analyzeMatch(MatchModel match) {
    int score = calculateScore(match);
    bool valueBet = isValueBet(match);

    int confidence = 60;
    final List<String> reasons = [];

    if (score >= 92) {
      confidence += 30;
      reasons.add("Kiemelkedő xG mutatók és hazai dominancia.");
    } else if (score >= 85) {
      confidence += 20;
      reasons.add("Stabil támadójáték és szilárd védekezés.");
    } else {
      confidence += 10;
      reasons.add("Kiegyenlített erőviszonyok.");
    }

    if (valueBet) {
      confidence += 10;
      reasons.add("Magas értékű Value Bet opció.");
    }

    confidence = confidence.clamp(0, 100);

    final String recommendation = score >= 93
        ? "Hazai győzelem & Over 2.5"
        : score >= 87
            ? "BTTS: Igen"
            : "1X (Hazai vagy X)";

    return AiAnalysisResult(
      score: score,
      confidence: confidence,
      recommendation: recommendation,
      isValueBet: valueBet,
      reasons: reasons,
    );
  }

  static String recommendation(MatchModel match) => analyzeMatch(match).recommendation;
  static int confidence(MatchModel match) => analyzeMatch(match).confidence;
  static List<String> reasons(MatchModel match) => analyzeMatch(match).reasons;
}
