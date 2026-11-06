import 'package:flutter_test/flutter_test.dart';
import 'package:campus_incident_app/utils/validators.dart';

void main() {
  group('Email validator', () {
    test('rejects empty email', () {
      expect(Validators.email(''), isNotNull);
    });

    test('rejects badly formatted email', () {
      expect(Validators.email('notanemail'), isNotNull);
    });

    test('rejects non-ALU email', () {
      expect(Validators.email('someone@gmail.com'), isNotNull);
    });

    test('accepts ALU student email', () {
      expect(Validators.email('maxime@alustudent.com'), isNull);
    });
  });

  group('Password validator', () {
    test('rejects short password', () {
      expect(Validators.password('123'), isNotNull);
    });

    test('accepts valid password', () {
      expect(Validators.password('secret123'), isNull);
    });
  });

  group('Required validator', () {
    test('rejects blank text', () {
      expect(Validators.required('   ', 'Title'), 'Title is required');
    });
  });
}