import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/app_user.dart';
import '../utils/constants.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<User?> get authChanges => _auth.authStateChanges();
  User? get currentUser => _auth.currentUser;

  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final cleanEmail = email.trim().toLowerCase();
    final domain = cleanEmail.split('@').last;
    if (!AllowedEmailDomains.all.contains(domain)) {
      throw FirebaseAuthException(code: 'invalid-domain');
    }

    final cred = await _auth.createUserWithEmailAndPassword(
      email: cleanEmail,
      password: password,
    );
    final user = cred.user!;
    await user.updateDisplayName(name.trim());

    // Everyone registers as a student. Staff role is assigned manually
    // in the Firebase Console, so users cannot promote themselves.
    final appUser = AppUser(
      uid: user.uid,
      email: cleanEmail,
      name: name.trim(),
      role: UserRole.student,
    );
    await _db.collection('users').doc(user.uid).set(appUser.toMap());

    await user.sendEmailVerification();
  }

  Future<void> login(String email, String password) async {
    await _auth.signInWithEmailAndPassword(
      email: email.trim().toLowerCase(),
      password: password,
    );
  }

  Future<void> sendVerificationEmail() async {
    await _auth.currentUser?.sendEmailVerification();
  }

  Future<void> reloadUser() async {
    await _auth.currentUser?.reload();
    // Refresh the token so the security rules see email_verified = true.
    await _auth.currentUser?.getIdToken(true);
  }

  Future<void> logout() => _auth.signOut();

  Future<AppUser?> fetchAppUser(String uid) async {
    final doc = await _db.collection('users').doc(uid).get();
    if (!doc.exists) return null;
    return AppUser.fromMap(uid, doc.data()!);
  }
}