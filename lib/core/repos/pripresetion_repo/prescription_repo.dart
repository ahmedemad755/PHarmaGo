import 'package:dartz/dartz.dart';
import 'package:e_commerce/core/errors/faliur.dart';
import 'package:e_commerce/core/models/prescription_match_result.dart';

abstract class PrescriptionRepo {
  Future<Either<Faliur, PrescriptionMatchResult>> matchPrescription(
    String ocrText,
  );
}
