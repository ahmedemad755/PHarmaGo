import 'package:dartz/dartz.dart';
import 'package:e_commerce/core/errors/faliur.dart';
import 'package:e_commerce/Features/auth/domain/entites/user_entity.dart';
import 'package:e_commerce/Features/auth/domain/repositories/auth_repo.dart';

class SignupUseCase {
  SignupUseCase(this._authRepo);

  final AuthRepo _authRepo;

  Future<Either<Faliur, UserEntity>> call({
    required String email,
    required String password,
    required String name,
    required String address,
    required double lat,
    required double lng,
  }) {
    return _authRepo.signup(
      email: email,
      password: password,
      name: name,
      address: address,
      lat: lat,
      lng: lng,
    );
  }
}
