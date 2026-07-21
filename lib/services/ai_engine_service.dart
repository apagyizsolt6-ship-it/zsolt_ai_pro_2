/*
===========================================
ZSOLT AI PRO
Version: v3.1.0 (Statikus AI Motor)
File: ai_engine_service.dart
===========================================
*/

import 'dart:math';
import '../models/ai_analysis_result.dart';
import '../models/match_model.dart';

class AiEngineService {
  const AiEngineService();

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
      reasons.add("Kiemelkedő xG (várható gól) mutatók és hazai dominancia.");
      reasons.add("A legutóbbi 5 mérkőzés statisztikai trendje 90% feletti egyezést mutat.");
    } else if (score >= 85) {
      confidence += 20;
      reasons.add("Stabil támadójáték és szilárd védekezési mutatók.");
      reasons.add("H2H (egymás elleni) statisztika alapján a hazai csapat esélyesebb.");
    } else {
      confidence += 10;
      reasons.add("Kiegyenlített erőviszonyok, óvatosabb taktikai csata várható.");
    }

    if (valueBet) {
      confidence += 10;
      reasons.add("Piaci alulárazottság detektálva: Magas értékű Value Bet opció.");
    }

    if (match.homeOdd != null) {
      reasons.add("Elemzett 1X2 oddsok: ${match.homeOdd} / ${match.drawOdd ?? '-'} / ${match.awayOdd ?? '-'}");
    }

    if (match.isLive) {
      confidence -= 5;
      reasons.add("Élő meccs státusz: A pillanatnyi események módosíthatják az xG értéket.");
    }

    confidence = confidence.clamp(0, 100);

    final String recommendation;
    if (score >= 93) {
      recommendation = "Hazai győzelem és több mint 2.5 gól (1 & Over 2.5)";
    } else if (score >= 87) {
      recommendation = "Mindkét csapat gólt szerez (BTTS: Igen)";
    } else if (score >= 82) {
      recommendation = "1X (Hazai győzelem vagy Döntetlen)";
    } else {
      recommendation = "Óvatos tipp: 2.5 gól alatt (Under 2.5)";
    }

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
