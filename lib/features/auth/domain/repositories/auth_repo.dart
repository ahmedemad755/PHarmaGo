import 'package:dartz/dartz.dart';
import 'package:e_commerce/core/errors/faliur.dart';
import 'package:e_commerce/Features/auth/domain/entites/user_entity.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthRepo {
  // Phase 2
  Future<Either<Faliur, UserEntity>> login({
    required String email,
    required String password,
  });

  Future<Either<Faliur, UserEntity>> signup({
    required String email,
    required String password,
    required String name,
    required String address,
    required double lat,
    required double lng,
  });

  Future<Either<Faliur, UserEntity>> googleLogin();

  // Phase 3
  Future<Either<Faliur, void>> logout();

  Future<Either<Faliur, void>> deleteAccount({String? storedPassword});

  Future<Either<Faliur, void>> resetPassword({required String email});

  // Phase 4
  Future<void> verifyPhoneNumber({
    required String phoneNumber,
    required void Function(String verificationId) onCodeSent,
    required void Function(FirebaseAuthException error) onVerificationFailed,
    required void Function(PhoneAuthCredential credential)
    onVerificationCompleted,
    required void Function(String verificationId) onAutoRetrievalTimeout,
  });

  Future<Either<Faliur, UserCredential>> verifyOtp({
    required String verificationId,
    required String smsCode,
  });

  Future<Either<Faliur, void>> sendEmailVerification();

  Future<Either<Faliur, UserEntity?>> getCurrentUser();

  Future<Either<Faliur, bool>> checkEmailExists({required String email});
}
