import 'package:e_commerce/Features/auth/domain/repositories/auth_repo.dart';
import 'package:firebase_auth/firebase_auth.dart';

class VerifyPhoneUseCase {
  VerifyPhoneUseCase(this._authRepo);

  final AuthRepo _authRepo;

  Future<void> call({
    required String phoneNumber,
    required void Function(String verificationId) onCodeSent,
    required void Function(FirebaseAuthException error) onVerificationFailed,
    required void Function(PhoneAuthCredential credential)
    onVerificationCompleted,
    required void Function(String verificationId) onAutoRetrievalTimeout,
  }) {
    return _authRepo.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      onCodeSent: onCodeSent,
      onVerificationFailed: onVerificationFailed,
      onVerificationCompleted: onVerificationCompleted,
      onAutoRetrievalTimeout: onAutoRetrievalTimeout,
    );
  }
}
