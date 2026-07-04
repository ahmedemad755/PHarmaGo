import 'package:bloc/bloc.dart';
import 'package:e_commerce/Features/auth/domain/usecases/verify_otp_usecase.dart';
import 'package:e_commerce/Features/auth/domain/usecases/verify_phone_usecase.dart';
import 'package:e_commerce/Features/auth/presentation/cubits/vereficationotp/vereficationotp_state.dart';
import 'package:firebase_auth/firebase_auth.dart';

class OTPCubit extends Cubit<OTPState> {
  OTPCubit({
    required VerifyPhoneUseCase verifyPhoneUseCase,
    required VerifyOtpUseCase verifyOtpUseCase,
  }) : _verifyPhoneUseCase = verifyPhoneUseCase,
       _verifyOtpUseCase = verifyOtpUseCase,
       super(OTPInitial());

  final VerifyPhoneUseCase _verifyPhoneUseCase;
  final VerifyOtpUseCase _verifyOtpUseCase;

  String? currentPhoneNumber;
  String? verificationId;
  String? lastSmsCode;
  String? newPassword;

  /// إرسال كود التحقق
  Future<void> sendOTP(String phoneNumber) async {
    print('رقم الهاتف اللي وصل لـ Cubit: "$phoneNumber"');
    if (phoneNumber.isEmpty) {
      emit(OTPError('الرقم لا يمكن أن يكون فارغًا'));
      return;
    }
    currentPhoneNumber = phoneNumber;
    emit(OTPLoading());

    await _verifyPhoneUseCase(
      phoneNumber: phoneNumber,
      onVerificationCompleted: (PhoneAuthCredential credential) async {
        try {
          final userCredential = await FirebaseAuth.instance
              .signInWithCredential(credential);
          final user = userCredential.user;

          if (user != null) {
            emit(OTPVerified(user));
          } else {
            emit(OTPError('فشل التحقق التلقائي'));
          }
        } catch (e) {
          emit(OTPError('فشل التحقق التلقائي'));
        }
      },

      onVerificationFailed: (FirebaseAuthException e) {
        emit(OTPError(e.message ?? 'حدث خطأ أثناء إرسال الكود'));
      },
      onCodeSent: (String verId) {
        verificationId = verId;
        emit(OTPCodeSent(verId));
      },
      onAutoRetrievalTimeout: (String verId) {
        verificationId = verId;
        emit(OTPCodeSent(verId)); // ممكن نعيد نفس الحالة
      },
    );
  }

  /// تأكيد الكود المُدخل من المستخدم
  Future<void> verifyCode(String smsCode) async {
    if (verificationId == null) {
      emit(OTPError('حدث خطأ: لا يوجد verificationId'));
      return;
    }

    emit(OTPLoading());

    final result = await _verifyOtpUseCase(
      verificationId: verificationId!,
      smsCode: smsCode,
    );

    result.fold((failure) => emit(OTPError(failure.message)), (userCredential) {
      final user = userCredential.user;
      if (user != null && user.phoneNumber != null) {
        emit(OTPVerified(user));
      } else {
        emit(OTPError("فشل التحقق من الكود"));
      }
    });
  }
}
