import 'package:e_commerce/core/services/shared_prefs_singelton.dart';
import 'package:e_commerce/featchers/AUTH/data/repos/auth_repo.dart';
import 'package:e_commerce/featchers/AUTH/presentation/cubits/login/login_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit(this.authRepo) : super(LoginInitial());

  final AuthRepo authRepo;
  //  final AuthRepoImpl authRepoImpl;

  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    emit(LoginLoading());

    // 1️⃣ تسجيل الدخول أولاً باستخدام Auth Service
    final result = await authRepo.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

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
          await Prefs.setBool("isLoggedIn", true);
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
    final result = await authRepo.signInWithGoogle();

    result.fold((failure) => emit(LoginFailure(failure.message)), (userEntity) {
      Prefs.setBool("isLoggedIn", true);
      emit(LoginSuccess(userEntity: userEntity));
    });
  }

  // Future<void> signInWithFacebook() async {
  //   emit(LoginLoading());
  //   final result = await authRepo.signInWithFacebook();

  //   result.fold((failure) => emit(LoginFailure(failure.message)), (userEntity) {
  //     Prefs.setBool("isLoggedIn", true); // ✅ أضف هنا كمان
  //     emit(LoginSuccess(userEntity: userEntity));
  //   });
  // }

  // داخل كلاس LoginCubit
  Future<void> logout() async {
    print("Log: تم بدء عملية تسجيل الخروج..."); // تتبع الاستدعاء
    emit(LogoutLoading());

    try {
      final result = await authRepo.logout();

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

  // Future<void> logout() async {
  //     emit(LogoutLoading());
  //     try {
  //       final result = await authRepo.logout;
  //       await result.fold(
  //         (failure) {
  //           emit(LogoutFailure(failure.message));
  //         },
  //         (_) async {
  //           // تنظيف البيانات المحلية (يفضل استخدام remove وليس clear)
  //           await Prefs.clear("isLoggedIn");
  //           await Prefs.clear("userPassword");

  //           emit(LogoutSuccess());
  //         },
  //       );
  //     } catch (e) {
  //       emit(LogoutFailure('حدث خطأ غير متوقع أثناء تسجيل الخروج.'));
  //     }
  //   }
}
