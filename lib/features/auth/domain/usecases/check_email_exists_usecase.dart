import 'package:dartz/dartz.dart';
import 'package:e_commerce/core/errors/faliur.dart';
import 'package:e_commerce/Features/auth/domain/repositories/auth_repo.dart';

class CheckEmailExistsUseCase {
  CheckEmailExistsUseCase(this._authRepo);

  final AuthRepo _authRepo;

  Future<Either<Faliur, bool>> call({required String email}) {
    return _authRepo.checkEmailExists(email: email);
  }
}
