import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce/Features/products/domain/entityes/product_enteti.dart';
import 'package:e_commerce/core/models/review_model.dart';

class ProductModel {
  final String name;
  final num price;
  final num cost; // تم إضافة الحقل الجديد هنا
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
  final String categoryId; // أضفنا الحقل هنا
  final String pharmacyId; // أضفنا الحقل هنا
  final bool isPrescriptionRequired;
  final String pharmacyName; // اسم الصيدلية
  final double pharmacyLat; // خط العرض
  final double pharmacyLng; // خط الطول

  ProductModel({
    required this.name,
    required this.price,
    required this.cost, // تم إضافة الحقل الجديد هنا
    required this.code,
    required this.description,
    this.imageurl,
    this.averageRating = 0,
    required this.expirationDate,
    required this.unitAmount,
    required this.reviews,
    this.sellingcount = 0,
    this.discountPercentage = 0,
    this.isPrescriptionRequired = false,
    this.category = 'الأدوية',
    this.categoryId = '', // أضفنا الحقل هنا
    required this.pharmacyId,
    required this.pharmacyName, // أضف هذا
    required this.pharmacyLat, // أضف هذا
    required this.pharmacyLng,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    // دالة مساعدة لتحويل أي نوع تاريخ لـ DateTime بأمان
    DateTime parseDate(dynamic date) {
      if (date is Timestamp) return date.toDate();
      if (date is String) return DateTime.tryParse(date) ?? DateTime.now();
      return DateTime.now();
    }

    // معالجة الـ reviews بأمان
    final List<ReviewModel> reviewsList =
        (json['reviews'] as List<dynamic>?)
            ?.map((e) => ReviewModel.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [];

    return ProductModel(
      // الحقول الأساسية مع قيم افتراضية في حال عدم الوجود (Null Safety)
      name: json['name']?.toString() ?? 'بدون اسم',
      price: json['price'] as num? ?? 0,
      cost: json['cost'] as num? ?? 0,
      code: json['code']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      imageurl: json['imageurl']?.toString(),

      // الحقول اللي عاملة المشكلة (التاريخ والـ unitAmount)
      expirationDate: parseDate(json['expirationDate']),
      unitAmount: (json['unitAmount'] as num?)?.toInt() ?? 0,

      // حقول الـ Dashboard (التأكد من وجودها)
      sellingcount: json['sellingcount'] as num? ?? 0,
      discountPercentage: json['discountPercentage'] as num? ?? 0,
      isPrescriptionRequired: json['isPrescriptionRequired'] as bool? ?? false,

      // حل مشكلة الحقول الناقصة في الفايربيز (category)
      category: json['category'] as String? ?? 'الأدوية',
      categoryId: json['categoryId'] as String? ?? '',
      pharmacyId: json['pharmacyId'] as String? ?? 'غير معروف',

      // حماية إضافية للـ reviews والـ rating
      reviews: reviewsList,
      averageRating: (json['averageRating'] as num?) ?? 0,
      pharmacyName: json['pharmacyName'] as String? ?? 'صيدلية مجهولة',
      pharmacyLat: (json['pharmacyLat'] as num?)?.toDouble() ?? 0.0,
      pharmacyLng: (json['pharmacyLng'] as num?)?.toDouble() ?? 0.0,
    );
  }

  factory ProductModel.fromentity(AddProductIntety addProductIntety) {
    return ProductModel(
      name: addProductIntety.name,
      price: addProductIntety.price,
      cost: addProductIntety.cost, // تم إضافة الحقل الجديد هنا
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
      pharmacyName: addProductIntety.pharmacyName, // اسم الصيدلية
      pharmacyLat: addProductIntety.pharmacyLat, // خط العرض
      pharmacyLng: addProductIntety.pharmacyLng, // خط الطول
      isPrescriptionRequired: addProductIntety.isPrescriptionRequired,
    );
  }

  AddProductIntety toEntity() {
    return AddProductIntety(
      name: name,
      code: code,
      description: description,
      price: price,
      cost: cost, // تم إضافة الحقل الجديد هنا
      reviews: reviews.map((e) => e.toEntity()).toList(),
      expirationDate: expirationDate,
      unitAmount: unitAmount,
      imageurl: imageurl,
      sellingcount: sellingcount,
      discountPercentage: discountPercentage,
      category: category,
      pharmacyId: pharmacyId, // تحويل المعرف هنا
      isPrescriptionRequired: isPrescriptionRequired,
      pharmacyName: pharmacyName, // اسم الصيدلية
      pharmacyLat: pharmacyLat, // خط العرض
      pharmacyLng: pharmacyLng, // خط الطول
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'price': price,
      'cost': cost, // تم إضافة الحقل الجديد هنا
      'code': code,
      'description': description,
      'imageurl': imageurl,
      'averageRating': averageRating,
      'ratingcount': ratingcount,
      'expirationDate': Timestamp.fromDate(expirationDate),
      'unitAmount': unitAmount,
      'reviews': reviews.map((e) => e.toJson()).toList(),
      'discountPercentage': discountPercentage,
      'category': category,
      'categoryId': categoryId, // حفظ القسم هنا
      'pharmacyId': pharmacyId, // حفظ المعرف هنا
      'isPrescriptionRequired': isPrescriptionRequired,
      'pharmacyName': pharmacyName, // اسم الصيدلية
      'pharmacyLat': pharmacyLat, // خط العرض
      'pharmacyLng': pharmacyLng, // خط الطول
    };
  }
}