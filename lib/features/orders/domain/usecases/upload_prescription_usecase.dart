import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:e_commerce/Features/orders/domain/repositories/orders_repo.dart';
import 'package:e_commerce/core/errors/faliur.dart';

class UploadPrescriptionUseCase {
  const UploadPrescriptionUseCase(this._ordersRepo);

  final OrdersRepo _ordersRepo;

  Future<Either<Faliur, String>> call(File imageFile) {
    return _ordersRepo.uploadPrescription(imageFile);
  }
}
