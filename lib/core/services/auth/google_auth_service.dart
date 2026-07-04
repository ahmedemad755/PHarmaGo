// ignore_for_file: public_member_api_docs

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:e_commerce/core/errors/exceptions.dart';

class GoogleAuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<AuthCredential> _getGoogleCredential() async {
    final googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) {
      throw CustomException(message: 'تم إلغاء تسجيل الدخول بواسطة جوجل.');
    }
    final googleAuth = await googleUser.authentication;

    return GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
  }

  Future<UserCredential> signInWithGoogle() async {
    final credential = await _getGoogleCredential();

    return await _firebaseAuth.signInWithCredential(credential);
  }

  Future<void> reauthenticateCurrentUser(User user) async {
    final credential = await _getGoogleCredential();

    await user.reauthenticateWithCredential(credential);
  }

  Future<void> signOut() async {
    await GoogleSignIn().signOut();
  }
}
