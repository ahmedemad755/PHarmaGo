import 'package:dartz/dartz.dart';
import 'package:e_commerce/core/errors/faliur.dart';
import 'package:e_commerce/Features/auth/domain/repositories/auth_repo.dart';

class LogoutUseCase {
  LogoutUseCase(this._authRepo);

  final AuthRepo _authRepo;

  Future<Either<Faliur, void>> call() {
    return _authRepo.logout();
  }
}
