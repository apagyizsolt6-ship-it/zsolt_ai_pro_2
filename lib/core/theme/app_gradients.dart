/*
===========================================
ZSOLT AI PRO
Version: v1.1.0
File: app_gradients.dart
===========================================
*/

import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppGradients {
  AppGradients._();

  /// Fő ZSOLT AI PRO gradient
  /// (Prémium lila–kék dizájn)
  static const LinearGradient primary = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      AppColors.primary,
      AppColors.secondary,
    ],
  );

  static const LinearGradient success = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF00C853),
      Color(0xFF64DD17),
    ],
  );

  static const LinearGradient danger = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFD50000),
      Color(0xFFFF5252),
    ],
  );

  static const LinearGradient darkCard = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      AppColors.card,
      AppColors.background,
    ],
  );

  /// AI kiemelő gradient
  static const LinearGradient ai = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF7B3FFF),
      Color(0xFF1565FF),
    ],
  );

  /// Value Bet gradient
  static const LinearGradient valueBet = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF00C853),
      Color(0xFF00E676),
    ],
  );

  /// Figyelmeztetés gradient
  static const LinearGradient warning = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFFF9800),
      Color(0xFFFFC107),
    ],
  );
}
