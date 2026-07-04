import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:e_commerce/Features/prescription/domain/enteties/medicine_entity.dart';

abstract class PrescriptionRepo {
  // الميثود دي بتاخد صورة وترجع يا اما خطأ (String) يا اما لستة أدوية
  Future<Either<String, List<MedicineEntity>>> analyzePrescription(File image);
}
