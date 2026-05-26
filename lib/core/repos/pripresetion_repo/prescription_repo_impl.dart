// import 'dart:io';
// import 'package:dartz/dartz.dart';
// import 'package:e_commerce/core/repos/pripresetion_repo/prescription_repo.dart';
// import 'package:e_commerce/core/services/gemini_service.dart';
// import 'package:e_commerce/featchers/home/domain/enteties/medicine_entity.dart';

// class PrescriptionRepoImpl implements PrescriptionRepo {
//   // final GeminiService _geminiService;

//   PrescriptionRepoImpl(this._geminiService);

//   @override
//   Future<Either<String, List<MedicineEntity>>> analyzePrescription(
//     File image,
//   ) async {
//     try {
//       final result = await _geminiService.analyzeImage(image);
//       if (result.isEmpty) {
//         return left("لم يتم العثور على أدوية واضحة في الصورة");
//       }
//       return right(result);
//     } catch (e) {
//       return left("حدث خطأ أثناء المعالجة: ${e.toString()}");
//     }
//   }
// }
