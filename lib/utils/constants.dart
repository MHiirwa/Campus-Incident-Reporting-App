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
}

class AllowedEmailDomains {
  // Change these if your school uses different domains
  static const all = ['alustudent.com', 'alueducation.com'];
}