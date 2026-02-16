// import 'package:dartz/dartz.dart';
// import 'package:e_commerce/core/errors/faliur.dart';
// import 'package:e_commerce/core/models/prescription_match_result.dart';
// import 'package:e_commerce/core/models/product_model.dart';
// import 'package:e_commerce/core/services/cloud_fire_store_service.dart';
// import 'package:flutter/material.dart';
// import 'package:string_similarity/string_similarity.dart'; // لا تنسى تضيفها في pubspec.yaml

// import 'prescription_repo.dart';

// class PrescriptionRepoImpl implements PrescriptionRepo {
//   final FireStoreService firestoreService;

//   PrescriptionRepoImpl(this.firestoreService);

//   @override
//   Future<Either<Faliur, PrescriptionMatchResult>> matchPrescription(
//     String ocrText,
//   ) async {
//     try {
//       final normalizedOCR = _normalize(ocrText);
//       debugPrint('OCR normalized: $normalizedOCR');

//       final productsData = await firestoreService.getData(path: 'products');

//       if (productsData.isEmpty) {
//         return right(
//           const PrescriptionMatchResult(type: MatchType.none, score: 0),
//         );
//       }

//       double bestScore = 0;
//       AddProductModel? bestProduct;

//       // 🔹 قسم النص بعد الـ OCR لكلمات
//       List<String> ocrWords = normalizedOCR.split(' ');

//       // 🔹 أولاً فلترة تدريجية (startsWith)
//       List<AddProductModel> potentialMatches = [];

//       for (final word in ocrWords) {
//         if (word.isEmpty) continue;

//         for (final data in productsData) {
//           final product = AddProductModel.fromJson(data);
//           final productNormalized = _normalize(product.name);

//           if (productNormalized.startsWith(word)) {
//             potentialMatches.add(product);
//           }
//         }

//         // لو فيه matches لكلمة دي، نستخدمها مباشرة
//         if (potentialMatches.isNotEmpty) break;
//       }

//       // 🔹 لو مفيش أي كلمة طابقت باستخدام startsWith، استخدم similarity كخطة بديلة
//       if (potentialMatches.isEmpty) {
//         for (final data in productsData) {
//           final product = AddProductModel.fromJson(data);
//           final productNormalized = _normalize(product.name);
//           final score = _similarity(normalizedOCR, productNormalized);

//           debugPrint(
//             'Comparing with product: ${product.name} | normalized: $productNormalized | score: $score',
//           );

//           if (score > bestScore) {
//             bestScore = score;
//             bestProduct = product;
//           }
//         }

//         if (bestProduct != null) {
//           if (bestScore == 100) {
//             return right(
//               PrescriptionMatchResult(
//                 type: MatchType.exact,
//                 product: bestProduct.toEntity(),
//                 score: bestScore,
//               ),
//             );
//           }

//           if (bestScore >= 50) {
//             return right(
//               PrescriptionMatchResult(
//                 type: MatchType.confirm,
//                 product: bestProduct.toEntity(),
//                 score: bestScore,
//               ),
//             );
//           }

//           return right(
//             PrescriptionMatchResult(
//               type: MatchType.aiSuggest,
//               score: bestScore,
//             ),
//           );
//         } else {
//           return right(
//             const PrescriptionMatchResult(type: MatchType.none, score: 0),
//           );
//         }
//       }

//       // 🔹 لو فيه منتجات matched بالـ startsWith
//       // خد أول منتج كأفضل نتيجة
//       final firstMatch = potentialMatches.first;
//       return right(
//         PrescriptionMatchResult(
//           type: MatchType.confirm,
//           product: firstMatch.toEntity(),
//           score: 100,
//         ),
//       );
//     } catch (e) {
//       return left(ServerFaliur(e.toString()));
//     }
//   }

//   // ======================================
//   // Normalize النص: إزالة diacritics + lowercase + إزالة الرموز
//   // ======================================
//   String _normalize(String text) {
//     String normalized = removeDiacritics(text.toLowerCase())
//         .replaceAll(
//           RegExp(r'[^a-z0-9\u0600-\u06FF\s]'),
//           ' ',
//         ) // دعم العربية والإنجليزية
//         .replaceAll(RegExp(r'\s+'), ' ')
//         .trim();
//     return normalized;
//   }

//   // ======================================
//   // احسب similarity بين كلمتين (0 - 100)
//   // ======================================
//   double _similarity(String a, String b) {
//     return a.similarityTo(b) * 100; // من مكتبة string_similarity
//   }

//   // ======================================
//   // إزالة الـ diacritics (حروف التشكيل)
//   // ======================================
//   String removeDiacritics(String str) {
//     const withDiacritics =
//         'ّ|َ|ً|ُ|ٌ|ِ|ٍ|ْ|ٰ|َ|ُ|ِ'; // يمكن إضافة باقي العلامات إذا لزم
//     return str.replaceAll(RegExp(withDiacritics), '');
//   }
// }

import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:e_commerce/core/repos/pripresetion_repo/prescription_repo.dart';
import 'package:e_commerce/core/services/gemini_service.dart';
import 'package:e_commerce/featchers/home/domain/enteties/medicine_entity.dart';

class PrescriptionRepoImpl implements PrescriptionRepo {
  final GeminiService _geminiService;

  PrescriptionRepoImpl(this._geminiService);

  @override
  Future<Either<String, List<MedicineEntity>>> analyzePrescription(File image) async {
    try {
      final result = await _geminiService.analyzeImage(image);
      if (result.isEmpty) {
        return left("لم يتم العثور على أدوية واضحة في الصورة");
      }
      return right(result);
    } catch (e) {
      return left("حدث خطأ أثناء المعالجة: ${e.toString()}");
    }
  }
}