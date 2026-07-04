// ignore_for_file: public_member_api_docs

import 'dart:developer' as developer;
import 'package:firebase_auth/firebase_auth.dart';

import 'package:e_commerce/core/errors/exceptions.dart';
import 'package:e_commerce/core/services/auth/google_auth_service.dart';

class AccountService {
  AccountService(this._googleAuthService);

  final GoogleAuthService _googleAuthService;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  bool isLoggedIn() {
    return _firebaseAuth.currentUser != null;
  }

  Future<void> deleteUser() async {
    final user = _firebaseAuth.currentUser;
    if (user == null) throw FirebaseAuthException(code: 'no-current-user');

    await user.delete();
  }

  Future<void> logout() async {
    try {
      final isGoogleUser = _firebaseAuth.currentUser?.providerData.any(
        (provider) => provider.providerId == 'google.com',
      );
      if (isGoogleUser ?? false) {
        await _googleAuthService.signOut(); // تسجيل الخروج من جوجل
      }
      // await FacebookAuth.instance.logOut(); // تسجيل الخروج من فيسبوك
      await _firebaseAuth.signOut(); // تسجيل الخروج من Firebase
    } on FirebaseAuthException catch (e) {
      developer.log("[logout] FirebaseAuthException: ${e.code} - ${e.message}");
      // رمي CustomException ليلتقطها الـ Repo
      throw CustomException(
        message: e.message ?? 'فشل تسجيل الخروج من Firebase',
      );
    } catch (e) {
      developer.log("[logout] Unknown error: $e");
      rethrow;
    }
  }

  Future<void> deleteUserWithReauthentication({String? storedPassword}) async {
    final user = _firebaseAuth.currentUser;
    if (user == null) throw FirebaseAuthException(code: 'no-current-user');

    final providerId = user.providerData.first.providerId;

    if (providerId == 'google.com') {
      await _googleAuthService.reauthenticateCurrentUser(user);
    } else if (providerId == 'password') {
      if (storedPassword == null || user.email == null) {
        throw FirebaseAuthException(code: 'missing-credentials');
      }

      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: storedPassword,
      );

      await user.reauthenticateWithCredential(credential);
    }

    await user.delete();
  }
}
