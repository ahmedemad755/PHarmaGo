// import 'package:dartz/dartz.dart';
// import 'package:e_commerce/core/errors/faliur.dart';
// import 'package:e_commerce/core/models/prescription_match_result.dart';

// abstract class PrescriptionRepo {
//   Future<Either<Faliur, PrescriptionMatchResult>> matchPrescription(
//     String ocrText,
//   );
// }

import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:e_commerce/featchers/home/domain/enteties/medicine_entity.dart';

abstract class PrescriptionRepo {
  // الميثود دي بتاخد صورة وترجع يا اما خطأ (String) يا اما لستة أدوية
  Future<Either<String, List<MedicineEntity>>> analyzePrescription(File image);
}