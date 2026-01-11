// ignore_for_file: public_member_api_docs

import 'dart:developer' as developer;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:e_commerce/core/errors/exceptions.dart';

class FirebaseAuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  // final _firestore = FirebaseFirestore.instance;
  String? _verificationId;

  Future<void> deleteUser() async {
    await _firebaseAuth.currentUser!.delete();
  }

  Future<User> creatuserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential.user!;
    } on FirebaseAuthException catch (e) {
      developer.log(
        "[createUser] FirebaseAuthException: ${e.code} - ${e.message}",
      );
      throw CustomException(message: '${e.message}');
    } catch (e) {
      developer.log("[createUser] Unknown error: $e");
      throw CustomException(message: 'فشل إنشاء الحساب. حاول مرة أخرى لاحقًا.');
    }
  }

  Future<User> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential.user!;
    } on FirebaseAuthException catch (e) {
      developer.log("[signIn] FirebaseAuthException: ${e.code} - ${e.message}");
      throw CustomException(message: '${e.message}');
    } catch (e) {
      developer.log("[signIn] Unknown error: $e");
      throw CustomException(message: 'فشل تسجيل الدخول. حاول مرة أخرى لاحقًا.');
    }
  }

  Future<void> sendemailverificationlink() async {
    final user = _firebaseAuth.currentUser!;
    if (!user.emailVerified) {
      await user.sendEmailVerification();
      developer.log("Verification email sent to ${user.email}");
    } else {
      throw CustomException(
        message: 'المستخدم غير مسجل أو البريد الإلكتروني تم التحقق منه بالفعل.',
      );
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      developer.log("Password reset email sent to $email");
    } on FirebaseAuthException catch (e) {
      developer.log(
        "[sendPasswordResetEmail] FirebaseAuthException: ${e.code} - ${e.message}",
      );
      throw CustomException(message: '${e.message}');
    } catch (e) {
      developer.log("[sendPasswordResetEmail] Unknown error: $e");
      throw CustomException(message: 'فشل إرسال رابط إعادة تعيين كلمة المرور.');
    }
  }

  Future<UserCredential> signInWithGoogle() async {
    final googleUser = await GoogleSignIn().signIn();
    final googleAuth = await googleUser?.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    return await _firebaseAuth.signInWithCredential(credential);
  }

  // Future<UserCredential> signInWithFacebook() async {
  //   final result = await FacebookAuth.instance.login();

  //   final credential = FacebookAuthProvider.credential(
  //     result.accessToken!.tokenString,
  //   );

  //   return await _firebaseAuth.signInWithCredential(credential);
  // }

  bool isLoggedIn() {
    return _firebaseAuth.currentUser != null;
  }

Future<void> logout() async {
    try {
      await GoogleSignIn().signOut(); // تسجيل الخروج من جوجل
      // await FacebookAuth.instance.logOut(); // تسجيل الخروج من فيسبوك
      await _firebaseAuth.signOut();  // تسجيل الخروج من Firebase
    } on FirebaseAuthException catch (e) {
      developer.log("[logout] FirebaseAuthException: ${e.code} - ${e.message}");
      // رمي CustomException ليلتقطها الـ Repo
      throw CustomException(message: e.message ?? 'فشل تسجيل الخروج من Firebase');
    } catch (e) {
      developer.log("[logout] Unknown error: $e");
      rethrow;
    }
  }

  Future<void> deleteUserWithReauthentication({String? storedPassword}) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw FirebaseAuthException(code: 'no-current-user');

    final providerId = user.providerData.first.providerId;

    if (providerId == 'google.com') {
      final googleUser = await GoogleSignIn().signIn();
      final googleAuth = await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      await user.reauthenticateWithCredential(credential);
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

  Future<void> verifyPhoneNumber({
    required String phoneNumber,
    required void Function(String verificationId) onCodeSent,
    required void Function(FirebaseAuthException error) onVerificationFailed,
    required void Function(PhoneAuthCredential credential)
    onVerificationCompleted,
    required void Function(String verificationId) onAutoRetrievalTimeout,
  }) async {
    await _firebaseAuth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: onVerificationCompleted,
      verificationFailed: onVerificationFailed,
      codeSent: (id, _) {
        _verificationId = id;
        onCodeSent(id);
      },
      codeAutoRetrievalTimeout: (id) {
        _verificationId = id;
        onAutoRetrievalTimeout(id);
      },
    );
  }

  Future<UserCredential> verifySmsCode(String smsCode) async {
    if (_verificationId == null) {
      throw FirebaseAuthException(
        code: 'no-verification-id',
        message: 'لم يتم العثور على كود التحقق. الرجاء المحاولة مرة أخرى.',
      );
    }

    final credential = PhoneAuthProvider.credential(
      verificationId: _verificationId!,
      smsCode: smsCode,
    );

    return await _firebaseAuth.signInWithCredential(credential);
  }
}
