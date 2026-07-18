/*
===========================================
ZSOLT AI PRO
Version: v1.3.1
Build #039
File: ai_analysis_result.dart
===========================================
*/

class AiAnalysisResult {
  final int score;

  final int confidence;

  final String recommendation;

  final bool isValueBet;

  final List<String> reasons;

  const AiAnalysisResult({
    required this.score,
    required this.confidence,
    required this.recommendation,
    required this.isValueBet,
    required this.reasons,
  });

  bool get isHighConfidence => confidence >= 80;

  bool get isExcellent => score >= 90;

  bool get isGood => score >= 75;

  bool get isAverage => score >= 60;  bool get needsAttention => score < 60;

  AiAnalysisResult copyWith({
    int? score,
    int? confidence,
    String? recommendation,
    bool? isValueBet,
    List<String>? reasons,
  }) {
    return AiAnalysisResult(
      score: score ?? this.score,
      confidence: confidence ?? this.confidence,
      recommendation:
          recommendation ?? this.recommendation,
      isValueBet:
          isValueBet ?? this.isValueBet,
      reasons: reasons ?? this.reasons,
    );
  }

  @override
  String toString() {
    return '''
AiAnalysisResult(
  score: $score,
  confidence: $confidence,
  recommendation: $recommendation,
  valueBet: $isValueBet,
  reasons: $reasons,
)
''';
  }
}
