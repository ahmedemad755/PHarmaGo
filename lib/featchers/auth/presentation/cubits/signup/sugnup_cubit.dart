import 'package:bloc/bloc.dart';
import 'package:e_commerce/core/services/shared_prefs_singelton.dart';
import 'package:e_commerce/featchers/AUTH/data/repos/auth_repo.dart';
import 'package:e_commerce/featchers/AUTH/domain/entites/user_entity.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'sugnup_state.dart';

class SugnupCubit extends Cubit<SugnupState> {
  final AuthRepo authRepo;

  SugnupCubit(this.authRepo) : super(SugnupInitial());

  Future<void> createUserWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
    // required String role,
  }) async {
    emit(SugnupLoading());

    try {
      // ✅ تحقق أولاً إن كان الإيميل مستخدم مسبقًا
      final existingMethods = await FirebaseAuth.instance
          .fetchSignInMethodsForEmail(email);
      if (existingMethods.isNotEmpty) {
        emit(SugnupFailure("الإيميل مستخدم بالفعل."));
        return;
      }

      // ✅ استكمال التسجيل من خلال الريبو
      final result = await authRepo.createUserWithEmailAndPassword(
        email: email,
        password: password,
        name: name,
        // role: role,
      );

      result.fold((failure) => emit(SugnupFailure(failure.message)), (
        userEntity,
      ) async {
        // ✅ حفظ حالة الدخول وكلمة المرور
        await Prefs.setBool("isLoggedIn", true);
        await Prefs.setString("userPassword", password);

        emit(SugnupSuccess(userEntity: userEntity));
      });
    } catch (e) {
      emit(SugnupFailure("حدث خطأ أثناء التحقق من البريد: ${e.toString()}"));
    }
  }
}
