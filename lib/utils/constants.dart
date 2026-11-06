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
        return Icons.water_drop_outlined;
      case 'Electricity':
        return Icons.bolt;
      case 'Furniture':
        return Icons.chair_outlined;
      case 'Sanitation':
        return Icons.delete_outline;
      case 'Safety':
        return Icons.shield_outlined;
      default:
        return Icons.apartment;
    }
  }
}

class AllowedEmailDomains {
  // Change these if your school uses different domains
  static const all = ['alustudent.com', 'alueducation.com', 'gmail.com'];
}