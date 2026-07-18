/*
===========================================
ZSOLT AI PRO
Version: v1.2.0
Build #034
File: match_formatter.dart
===========================================
*/

import 'package:flutter/material.dart';

import '../models/match_model.dart';

class MatchFormatter {
  const MatchFormatter._();

  static String formatTime(DateTime dateTime) {
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');

    return '$hour:$minute';
  }

  static String formatDate(DateTime dateTime) {
    final day = dateTime.day.toString().padLeft(2, '0');
    final month = dateTime.month.toString().padLeft(2, '0');
    final year = dateTime.year;

    return '$year.$month.$day';
  }

  static String formatDateTime(DateTime dateTime) {
    return '${formatDate(dateTime)} ${formatTime(dateTime)}';
  }

  static Color aiColor(int aiScore) {
    if (aiScore >= 90) {
      return Colors.green;
    }

    if (aiScore >= 80) {
      return Colors.orange;
    }

    if (aiScore >= 70) {
      return Colors.blue;
    }

    return Colors.grey;
  }

  static String statusText(MatchStatus status) {
    switch (status) {
      case MatchStatus.upcoming:
        return 'Közelgő';

      case MatchStatus.live:
        return 'Élő';

      case MatchStatus.finished:
        return 'Befejezett';
    }
  }

  static Color statusColor(MatchStatus status) {
    switch (status) {
      case MatchStatus.upcoming:
        return Colors.blue;

      case MatchStatus.live:
        return Colors.red;

      case MatchStatus.finished:
        return Colors.grey;
    }
  }

  static String odds(double? value) {
    if (value == null) {
      return '-';
    }

    return value.toStringAsFixed(2);
  }
}
