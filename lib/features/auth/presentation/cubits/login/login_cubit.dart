import 'package:e_commerce/core/services/preferences/shared_prefs_service.dart';
import 'package:e_commerce/Features/auth/domain/usecases/google_login_usecase.dart';
import 'package:e_commerce/Features/auth/domain/usecases/login_usecase.dart';
import 'package:e_commerce/Features/auth/domain/usecases/logout_usecase.dart';
import 'package:e_commerce/Features/auth/presentation/cubits/login/login_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit({
    required LoginUseCase loginUseCase,
    required GoogleLoginUseCase googleLoginUseCase,
    required LogoutUseCase logoutUseCase,
  }) : _loginUseCase = loginUseCase,
       _googleLoginUseCase = googleLoginUseCase,
       _logoutUseCase = logoutUseCase,
       super(LoginInitial());

  final LoginUseCase _loginUseCase;
  final GoogleLoginUseCase _googleLoginUseCase;
  final LogoutUseCase _logoutUseCase;

  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    emit(LoginLoading());

    // 1️⃣ تسجيل الدخول أولاً باستخدام Auth Service
    final result = await _loginUseCase(email: email, password: password);

    await result.fold(
      (failure) {
        emit(LoginFailure(failure.message));
      },
      (userEntity) async {
        try {
          // // 2️⃣ تحقق من وجود بيانات المستخدم في Firestore بعد تسجيل الدخول
          // final firestoreUser = await FirebaseFirestore.instance
          //     .collection('users')
          //     .doc(userEntity.uId)
          //     .get();

          // if (!firestoreUser.exists) {
          //   emit(LoginFailure("بيانات المستخدم غير موجودة في قاعدة البيانات"));
          //   return;
          // }

          // 3️⃣ إذا كل شيء تمام
          Prefs.setBool("isLoggedIn", true);
          await Prefs.setString("userPassword", password);
          emit(LoginSuccess(userEntity: userEntity));
        } catch (e) {
          emit(LoginFailure("خطأ في الوصول إلى قاعدة البيانات"));
        }
      },
    );
  }

  Future<void> signInWithGoogle() async {
    emit(LoginLoading());
    final result = await _googleLoginUseCase();

    result.fold((failure) => emit(LoginFailure(failure.message)), (userEntity) {
      Prefs.setBool("isLoggedIn", true);
      emit(LoginSuccess(userEntity: userEntity));
    });
  }

  // داخل كلاس LoginCubit
  Future<void> logout() async {
    print("Log: تم بدء عملية تسجيل الخروج..."); // تتبع الاستدعاء
    emit(LogoutLoading());

    try {
      final result = await _logoutUseCase();

      result.fold(
        (failure) {
          print("Log: فشل تسجيل الخروج: ${failure.message}"); // تتبع الفشل
          emit(LogoutFailure(failure.message));
        },
        (success) {
          print("Log: تم تسجيل الخروج بنجاح"); // تتبع النجاح
          emit(LogoutSuccess());
        },
      );
    } catch (e) {
      print("Log: حدث خطأ غير متوقع: $e");
      emit(LogoutFailure("حدث خطأ غير متوقع: $e"));
    }
  }
}
