import 'package:dartz/dartz.dart';
import 'package:e_commerce/core/errors/faliur.dart';
import 'package:e_commerce/Features/auth/domain/entites/user_entity.dart';
import 'package:e_commerce/Features/auth/domain/repositories/auth_repo.dart';

class GetCurrentUserUseCase {
  GetCurrentUserUseCase(this._authRepo);

  final AuthRepo _authRepo;

  Future<Either<Faliur, UserEntity?>> call() {
    return _authRepo.getCurrentUser();
  }
}
