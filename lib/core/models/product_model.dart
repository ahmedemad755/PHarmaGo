import 'package:e_commerce/core/enteties/product_enteti.dart';
import 'package:e_commerce/core/functions_helper/get_Avg_Rating.dart';
import 'package:e_commerce/core/models/review_model.dart';

class AddProductModel {
  final String name;
  final num price;
  final String code;
  final String description;
  String? imageurl;
  final num averageRating;
  final int ratingcount = 0;
  final DateTime expirationDate;
  final num sellingcount;
  final int unitAmount;
  final List<ReviewModel> reviews;
  final num discountPercentage;
  final String category; // New: Product category field
  AddProductModel({
    required this.name,
    required this.price,
    required this.code,
    required this.description,
    this.imageurl,
    this.averageRating = 0,
    required this.expirationDate,
    required this.unitAmount,
    required this.reviews,
    this.sellingcount = 0,
    this.discountPercentage = 0,
    this.category = 'الأدوية', // Default category
  });

factory AddProductModel.fromJson(Map<String, dynamic> json) {
  // استخدام وظيفة مساعدة لتحويل التاريخ من صيغة YYYYMMDD الرقمية
  DateTime parseDateFromInt(int dateInt) {
    String dateString = dateInt.toString();
    if (dateString.length == 8) {
      // 20291218 -> 2029-12-18
      final year = dateString.substring(0, 4);
      final month = dateString.substring(4, 6);
      final day = dateString.substring(6, 8);
      return DateTime.parse('$year-$month-$day');
    }
    // Fallback: يمكنك تعديل هذا حسب سياسة التعامل مع التاريخ غير الصالح
    return DateTime.now();
  }

  // معالجة قائمة المراجعات بطريقة آمنة
  final List<ReviewModel> reviewsList = (json['reviews'] as List<dynamic>?)
      ?.map((e) => ReviewModel.fromJson(e as Map<String, dynamic>))
      .toList() ?? [];

  return AddProductModel(
    // 1. ⚠️ التصحيح الرئيسي: تحويل الرقم إلى DateTime
    expirationDate: parseDateFromInt(json['expirationDate'] as int),

    // 2. استخدام القائمة المُعالجة لحساب المتوسط
    averageRating: getAvgRating(reviewsList),

    // 3. التأكد من التعامل الآمن مع الأرقام غير الضرورية
    discountPercentage: (json['discountPercentage'] as num?) ?? 0,
    sellingcount: (json['sellingcount'] as num?) ?? 0,
    unitAmount: (json['unitAmount'] as int?) ?? 0,

    // 4. الحقول النصية (Keys match, types match)
    name: json['name'] as String,
    price: json['price'] as num,
    code: json['code'] as String,
    description: json['description'] as String,
    imageurl: json['imageurl'] as String?,
    
    // 5. استخدام القائمة المُعالجة مرة أخرى
    reviews: reviewsList,
    
    // 6. التعامل مع الحقول التي قد تكون مفقودة
    category: json['category'] as String? ?? 'الأدوية',
  );
}

  factory AddProductModel.fromentity(AddProductIntety addProductIntety) {
    return AddProductModel(
      name: addProductIntety.name,
      price: addProductIntety.price,
      code: addProductIntety.code,
      description: addProductIntety.description,
      imageurl: addProductIntety.imageurl,
      averageRating: addProductIntety.averageRating,
      expirationDate: addProductIntety.expirationDate,
      unitAmount: addProductIntety.unitAmount,
      reviews: addProductIntety.reviews
          .map((e) => ReviewModel.fromentity(e))
          .toList(),
          discountPercentage: addProductIntety.discountPercentage,
      category: addProductIntety.category, // Include category
    );
  }

  AddProductIntety toEntity() {
    return AddProductIntety(
      name: name,
      code: code,
      description: description,
      price: price,
      reviews: reviews.map((e) => e.toEntity()).toList(),
      expirationDate: expirationDate,
      unitAmount: unitAmount,
      imageurl: imageurl,
      sellingcount: sellingcount,
      discountPercentage: discountPercentage,
      category: category, // Include category in entity conversion
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'price': price,
      'code': code,
      'description': description,
      'imageurl': imageurl,
      'averageRating': averageRating,
      'ratingcount': ratingcount,
      'expirationDate': expirationDate,
      'unitAmount': unitAmount,
      'reviews': reviews.map((e) => e.toJson()).toList(),
      'discountPercentage': discountPercentage,
      'category': category, // Include category in JSON
    };
  }
}


