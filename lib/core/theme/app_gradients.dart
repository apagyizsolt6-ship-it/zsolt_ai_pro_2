/*
===========================================
ZSOLT AI PRO
Version: v1.0.0
File: app_gradients.dart
===========================================
*/

import 'package:flutter/material.dart';

class AppGradients {
  AppGradients._();

  static const LinearGradient primary = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF1565FF),
      Color(0xFF42A5F5),
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
      Color(0xFF1B1F2A),
      Color(0xFF11151E),
    ],
  );
}
