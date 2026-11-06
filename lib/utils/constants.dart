import 'package:flutter/material.dart';

class UserRole {
  static const student = 'student';
  static const staff = 'staff';
}

class IncidentStatus {
  static const submitted = 'Submitted';
  static const inReview = 'In Review';
  static const inProgress = 'In Progress';
  static const resolved = 'Resolved';

  static const all = [submitted, inReview, inProgress, resolved];
}

class IncidentCategory {
  static const all = [
    'Water',
    'Electricity',
    'Furniture',
    'Sanitation',
    'Safety',
    'Facilities',
  ];

  static IconData iconFor(String category) {
    switch (category) {
      case 'Water':
        return Icons.water_drop_rounded;
      case 'Electricity':
        return Icons.bolt_rounded;
      case 'Furniture':
        return Icons.chair_rounded;
      case 'Sanitation':
        return Icons.cleaning_services_rounded;
      case 'Safety':
        return Icons.shield_rounded;
      default:
        return Icons.apartment_rounded;
    }
  }

  static Color colorFor(String category) {
    switch (category) {
      case 'Water':
        return const Color(0xFF159BD7);
      case 'Electricity':
        return const Color(0xFFF59E0B);
      case 'Furniture':
        return const Color(0xFFB7791F);
      case 'Sanitation':
        return const Color(0xFF10A981);
      case 'Safety':
        return const Color(0xFFEF4B55);
      default:
        return const Color(0xFF6D63E8);
    }
  }
}

class AllowedEmailDomains {
  // Change these if your school uses different domains
  static const all = ['alustudent.com', 'alueducation.com', 'alu.edu'];
}