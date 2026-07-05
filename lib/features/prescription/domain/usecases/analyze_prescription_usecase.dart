import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:e_commerce/Features/prescription/domain/entities/medicine_entity.dart';
import 'package:e_commerce/Features/prescription/domain/repositories/prescription_repo.dart';

class AnalyzePrescriptionUseCase {
  const AnalyzePrescriptionUseCase(this._prescriptionRepo);

  final PrescriptionRepo _prescriptionRepo;

  Future<Either<String, List<MedicineEntity>>> call(File image) {
    return _prescriptionRepo.analyzePrescription(image);
  }
}
