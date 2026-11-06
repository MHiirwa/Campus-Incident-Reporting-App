import 'package:flutter/material.dart';
import 'constants.dart';

class AppTheme {
  static const primary = Color(0xFF0D8B87);
  static const accent = Color(0xFFFF8061);
  static const background = Color(0xFFF3F7F8);

  static ThemeData get light => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: primary).copyWith(
          primary: primary,
          secondary: accent,
          surface: Colors.white,
        ),
        scaffoldBackgroundColor: background,
      );

  static Color statusColor(String status) {
    switch (status) {
      case IncidentStatus.inReview:
        return const Color(0xFF0EA5E9);
      case IncidentStatus.inProgress:
        return const Color(0xFF2563EB);
      case IncidentStatus.resolved:
        return const Color(0xFF16A34A);
      default:
        return const Color(0xFFF59E0B);
    }
  }
}