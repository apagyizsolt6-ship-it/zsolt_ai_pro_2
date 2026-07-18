/*
===========================================
ZSOLT AI PRO
Version: v1.4.0
Build #040
File: ai_engine_service.dart
===========================================
*/

import '../models/ai_analysis_result.dart';
import '../models/match_model.dart';

class AiEngineService {
  const AiEngineService();

  AiAnalysisResult analyzeMatch(
    MatchModel match,
  ) {
    int score = match.aiScore;

    int confidence = 50;

    bool valueBet = match.valueBet;

    final List<String> reasons = [];

    //==========================================
    // AI SCORE
    //==========================================

    if (score >= 90) {
      confidence += 35;

      reasons.add(
        "Nagyon magas AI pontszám",
      );
    } else if (score >= 80) {
      confidence += 25;

      reasons.add(
        "Erős AI elemzés",
      );
    } else if (score >= 70) {
      confidence += 15;

      reasons.add(
        "Jó AI értékelés",
      );
    } else {
      confidence += 5;

      reasons.add(
        "Közepes AI értékelés",
      );
    }

    //==========================================
    // VALUE BET
    //==========================================

    if (valueBet) {
      confidence += 10;

      reasons.add(
        "Value Bet lehetőség",
      );
    }

    //==========================================
    // ÉLŐ MÉRKŐZÉS
    //==========================================

    if (match.isLive) {
      confidence -= 5;

      reasons.add(
        "Élő mérkőzés (kockázat változhat)",
      );
    }

    //==========================================
    // BIZALMI SZINT
    //==========================================

    confidence = confidence.clamp(
      0,
      100,
    );

    final String recommendation;

    if (score >= 90) {
      recommendation =
          "Hazai győzelem";
    } else if (score >= 80) {
      recommendation =
          "Hazai vagy Döntetlen";
    } else if (score >= 70) {
      recommendation =
          "Óvatos fogadás";
    } else {
      recommendation =
          "Nem ajánlott";
    }    //==========================================
    // AI AJÁNLÁS INDOKLÁSA
    //==========================================

    if (score >= 90) {
      reasons.add(
        "A mérkőzés kiemelkedő AI besorolást kapott.",
      );
    }

    if (score >= 85 && valueBet) {
      reasons.add(
        "Az AI és a Value Bet egyszerre kedvező.",
      );
    }

    if (match.homeOdd != null &&
        match.homeOdd! <= 2.00) {
      reasons.add(
        "A hazai győzelem szorzója kedvező.",
      );
    }

    if (match.drawOdd != null &&
        match.drawOdd! >= 3.50) {
      reasons.add(
        "Magas döntetlen szorzó.",
      );
    }

    if (match.awayOdd != null &&
        match.awayOdd! >= 4.00) {
      reasons.add(
        "A vendég győzelem esélye alacsony.",
      );
    }

    //==========================================
    // BIZALMI SZINT FINOMHANGOLÁSA
    //==========================================

    if (match.hasOdds) {
      confidence += 5;
    } else {
      reasons.add(
        "Hiányzó odds adatok.",
      );
    }

    confidence = confidence.clamp(
      0,
      100,
    );    //==========================================
    // AJÁNLÁS FINOMÍTÁSA
    //==========================================

    if (confidence >= 90 &&
        valueBet) {
      reasons.add(
        "Kiemelten ajánlott fogadási lehetőség.",
      );
    } else if (confidence >= 80) {
      reasons.add(
        "Magas bizalmi szint.",
      );
    } else if (confidence >= 70) {
      reasons.add(
        "Megfelelő választás lehet.",
      );
    } else {
      reasons.add(
        "Fokozott óvatosság javasolt.",
      );
    }

    return AiAnalysisResult(
      score: score,
      confidence: confidence,
      recommendation:
          recommendation,
      isValueBet: valueBet,
      reasons: reasons,
    );
  }

  //==========================================
  // GYORS AI PONTSZÁM
  //==========================================

  int calculateScore(
    MatchModel match,
  ) {
    return analyzeMatch(match).score;
  }

  //==========================================
  // GYORS AJÁNLÁS
  //==========================================

  String recommendation(
    MatchModel match,
  ) {
    return analyzeMatch(match)
        .recommendation;
  }  //==========================================
  // GYORS BIZALMI SZINT
  //==========================================

  int confidence(
    MatchModel match,
  ) {
    return analyzeMatch(match)
        .confidence;
  }

  //==========================================
  // VALUE BET
  //==========================================

  bool isValueBet(
    MatchModel match,
  ) {
    return analyzeMatch(match)
        .isValueBet;
  }

  //==========================================
  // INDOKLÁS
  //==========================================

  List<String> reasons(
    MatchModel match,
  ) {
    return analyzeMatch(match)
        .reasons;
  }
}
