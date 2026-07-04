import 'package:dartz/dartz.dart';
import 'package:e_commerce/core/errors/faliur.dart';
import 'package:e_commerce/Features/auth/domain/repositories/auth_repo.dart';

class DeleteAccountUseCase {
  DeleteAccountUseCase(this._authRepo);

  final AuthRepo _authRepo;

  Future<Either<Faliur, void>> call({String? storedPassword}) {
    return _authRepo.deleteAccount(storedPassword: storedPassword);
  }
}
