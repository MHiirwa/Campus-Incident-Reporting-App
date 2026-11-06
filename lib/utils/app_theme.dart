import 'package:flutter/material.dart';
import 'constants.dart';

class AppTheme {
  static const primary = Color(0xFF5B3DF5);
  static const background = Color(0xFFF7F6FD);

  static ThemeData get light => ThemeData(
        useMaterial3: true,
        colorScheme:
            ColorScheme.fromSeed(seedColor: primary).copyWith(primary: primary),
        scaffoldBackgroundColor: background,
      );

  static Color statusColor(String status) {
    switch (status) {
      case IncidentStatus.inReview:
        return const Color(0xFF0EA5E9);
      case IncidentStatus.inProgress:
        return primary;
      case IncidentStatus.resolved:
        return const Color(0xFF16A34A);
      default:
        return const Color(0xFFF59E0B);
    }
  }
}