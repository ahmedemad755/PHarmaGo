import 'package:bloc/bloc.dart';
import 'package:e_commerce/core/services/preferences/shared_prefs_service.dart';
import 'package:e_commerce/Features/auth/domain/entites/user_entity.dart';
import 'package:e_commerce/Features/auth/domain/usecases/check_email_exists_usecase.dart';
import 'package:e_commerce/Features/auth/domain/usecases/signup_usecase.dart';
import 'package:equatable/equatable.dart';

part 'sugnup_state.dart';

class SugnupCubit extends Cubit<SugnupState> {
  SugnupCubit({
    required SignupUseCase signupUseCase,
    required CheckEmailExistsUseCase checkEmailExistsUseCase,
  }) : _signupUseCase = signupUseCase,
       _checkEmailExistsUseCase = checkEmailExistsUseCase,
       super(SugnupInitial());

  final SignupUseCase _signupUseCase;
  final CheckEmailExistsUseCase _checkEmailExistsUseCase;

  Future<void> createUserWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
    required String address,
    required double lat,
    required double lng,
    // required String role,
  }) async {
    emit(SugnupLoading());

    // ✅ تحقق أولاً إن كان الإيميل مستخدم مسبقًا
    final checkResult = await _checkEmailExistsUseCase(email: email);

    bool emailExists = false;
    final checkFailureMessage = checkResult.fold((failure) => failure.message, (
      exists,
    ) {
      emailExists = exists;
      return null;
    });

    if (checkFailureMessage != null) {
      emit(SugnupFailure(checkFailureMessage));
      return;
    }
    if (emailExists) {
      emit(SugnupFailure("الإيميل مستخدم بالفعل."));
      return;
    }

    // ✅ استكمال التسجيل من خلال الريبو
    final result = await _signupUseCase(
      email: email,
      password: password,
      name: name,
      address: address,
      lat: lat,
      lng: lng,
      // role: role,
    );

    await result.fold((failure) async => emit(SugnupFailure(failure.message)), (
      userEntity,
    ) async {
      // ✅ حفظ حالة الدخول وكلمة المرور
      await Prefs.setBool("isLoggedIn", true);
      await Prefs.setString("userPassword", password);

      emit(SugnupSuccess(userEntity: userEntity));
    });
  }
}
