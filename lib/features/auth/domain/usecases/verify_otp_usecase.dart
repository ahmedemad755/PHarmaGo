import 'package:dartz/dartz.dart';
import 'package:e_commerce/core/errors/faliur.dart';
import 'package:e_commerce/Features/auth/domain/repositories/auth_repo.dart';
import 'package:firebase_auth/firebase_auth.dart';

class VerifyOtpUseCase {
  VerifyOtpUseCase(this._authRepo);

  final AuthRepo _authRepo;

  Future<Either<Faliur, UserCredential>> call({
    required String verificationId,
    required String smsCode,
  }) {
    return _authRepo.verifyOtp(
      verificationId: verificationId,
      smsCode: smsCode,
    );
  }
}
