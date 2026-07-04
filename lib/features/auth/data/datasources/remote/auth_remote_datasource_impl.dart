import 'dart:developer' as developer;

import 'package:e_commerce/core/errors/exceptions.dart';
import 'package:e_commerce/core/services/auth/account_service.dart';
import 'package:e_commerce/core/services/auth/google_auth_service.dart';
import 'package:e_commerce/core/services/auth/phone_auth_service.dart';
import 'package:e_commerce/Features/auth/data/datasources/remote/auth_remote_datasource.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  AuthRemoteDataSourceImpl({
    required GoogleAuthService googleAuthService,
    required PhoneAuthService phoneAuthService,
    required AccountService accountService,
  }) : _googleAuthService = googleAuthService,
       _phoneAuthService = phoneAuthService,
       _accountService = accountService;

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleAuthService _googleAuthService;
  final PhoneAuthService _phoneAuthService;
  final AccountService _accountService;

  @override
  Future<User> createUser({
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

  @override
  Future<User> login({required String email, required String password}) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential.user!;
    } on FirebaseAuthException catch (e) {
      developer.log("[login] FirebaseAuthException: ${e.code} - ${e.message}");
      throw CustomException(message: '${e.message}');
    } catch (e) {
      developer.log("[login] Unknown error: $e");
      throw CustomException(message: 'فشل تسجيل الدخول. حاول مرة أخرى لاحقًا.');
    }
  }

  @override
  Future<UserCredential> signInWithGoogle() async {
    return await _googleAuthService.signInWithGoogle();
  }

  @override
  Future<void> logout() async {
    await _accountService.logout();
  }

  @override
  Future<void> deleteCurrentUser() async {
    await _accountService.deleteUser();
  }

  @override
  Future<void> deleteCurrentUserWithReauthentication({
    String? storedPassword,
  }) async {
    await _accountService.deleteUserWithReauthentication(
      storedPassword: storedPassword,
    );
  }

  @override
  Future<void> sendPasswordResetEmail({required String email}) async {
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

  @override
  Future<void> sendEmailVerification() async {
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

  @override
  Future<bool> isLoggedIn() async {
    return _accountService.isLoggedIn();
  }

  @override
  User? get currentUser => _firebaseAuth.currentUser;

  @override
  Future<void> verifyPhoneNumber({
    required String phoneNumber,
    required void Function(String verificationId) onCodeSent,
    required void Function(FirebaseAuthException error) onVerificationFailed,
    required void Function(PhoneAuthCredential credential)
    onVerificationCompleted,
    required void Function(String verificationId) onAutoRetrievalTimeout,
  }) async {
    await _phoneAuthService.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      onCodeSent: onCodeSent,
      onVerificationFailed: onVerificationFailed,
      onVerificationCompleted: onVerificationCompleted,
      onAutoRetrievalTimeout: onAutoRetrievalTimeout,
    );
  }

  @override
  Future<UserCredential> verifySmsCode({
    required String verificationId,
    required String smsCode,
  }) async {
    return await _phoneAuthService.verifySmsCode(
      verificationId: verificationId,
      smsCode: smsCode,
    );
  }
}
