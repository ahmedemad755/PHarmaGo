import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthRemoteDataSource {
  Future<User> createUser({
    required String email,
    required String password,
  });

  Future<User> login({
    required String email,
    required String password,
  });

  Future<UserCredential> signInWithGoogle();

  Future<void> logout();

  Future<void> deleteCurrentUser();

  Future<void> deleteCurrentUserWithReauthentication({String? storedPassword});

  Future<void> sendPasswordResetEmail({
    required String email,
  });

  Future<void> sendEmailVerification();

  Future<bool> isLoggedIn();

  User? get currentUser;

  Future<void> verifyPhoneNumber({
    required String phoneNumber,
    required void Function(String verificationId) onCodeSent,
    required void Function(FirebaseAuthException error) onVerificationFailed,
    required void Function(PhoneAuthCredential credential)
    onVerificationCompleted,
    required void Function(String verificationId) onAutoRetrievalTimeout,
  });

  Future<UserCredential> verifySmsCode({
    required String verificationId,
    required String smsCode,
  });
}
