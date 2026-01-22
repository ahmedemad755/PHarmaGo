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
  final String category;
  final String pharmacyId; // أضفنا الحقل هنا

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
    this.category = 'الأدوية',
    required this.pharmacyId, // أضفنا الحقل هنا
  });

  factory AddProductModel.fromJson(Map<String, dynamic> json) {
    DateTime parseDateFromInt(int dateInt) {
      String dateString = dateInt.toString();
      if (dateString.length == 8) {
        final year = dateString.substring(0, 4);
        final month = dateString.substring(4, 6);
        final day = dateString.substring(6, 8);
        return DateTime.parse('$year-$month-$day');
      }
      return DateTime.now();
    }

    final List<ReviewModel> reviewsList =
        (json['reviews'] as List<dynamic>?)
            ?.map((e) => ReviewModel.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [];

    return AddProductModel(
      expirationDate: parseDateFromInt(json['expirationDate'] as int),
      averageRating: getAvgRating(reviewsList),
      discountPercentage: (json['discountPercentage'] as num?) ?? 0,
      sellingcount: (json['sellingcount'] as num?) ?? 0,
      unitAmount: (json['unitAmount'] as int?) ?? 0,
      name: json['name'] as String,
      price: json['price'] as num,
      code: json['code'] as String,
      description: json['description'] as String,
      imageurl: json['imageurl'] as String?,
      reviews: reviewsList,
      category: json['category'] as String? ?? 'الأدوية',
      pharmacyId:
          json['pharmacyId'] as String? ?? 'غير معروف', // سحب المعرف هنا
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
      category: addProductIntety.category,
      pharmacyId: addProductIntety.pharmacyId, // تحويل المعرف هنا
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
      category: category,
      pharmacyId: pharmacyId, // تحويل المعرف هنا
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
      'expirationDate': int.parse(
        '${expirationDate.year.toString().padLeft(4, '0')}${expirationDate.month.toString().padLeft(2, '0')}${expirationDate.day.toString().padLeft(2, '0')}',
      ),
      'unitAmount': unitAmount,
      'reviews': reviews.map((e) => e.toJson()).toList(),
      'discountPercentage': discountPercentage,
      'category': category,
      'pharmacyId': pharmacyId, // حفظ المعرف هنا
    };
  }
}
