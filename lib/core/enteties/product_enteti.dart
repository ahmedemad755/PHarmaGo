import 'package:e_commerce/core/enteties/review_entite.dart';
import 'package:equatable/equatable.dart';

class AddProductIntety extends Equatable {
  final String name;
  final num price;
  final String code;
  final String description;
  final String? imageurl;
  final DateTime expirationDate;
  final int unitAmount;
  final num averageRating;
  final int ratingcount;
  final num sellingcount;
  final List<ReviewEntite> reviews;
  final String category;
  final String categoryId;
  final num discountPercentage;
  final String pharmacyId; // تم إضافة الحقل هنا

  bool get hasDiscount => discountPercentage > 0;

  const AddProductIntety( {
    required this.name,
    required this.price,
    required this.code,
    required this.description,
    this.imageurl,
    required this.expirationDate,
    required this.unitAmount,
    this.averageRating = 0,
    this.ratingcount = 0,
    required this.sellingcount,
    required this.reviews,
    this.discountPercentage = 0,
    this.category = 'الأدوية',
    this.categoryId = '',
    required this.pharmacyId, // تم إضافته هنا
  });

  @override
  List<Object?> get props => [
    code,
    name,
    price,
    description,
    expirationDate,
    unitAmount,
    discountPercentage,
    category,
    categoryId,
    pharmacyId, // تم إضافته هنا
  ];

  // تم الحفاظ على الـ operator == والـ hashCode كما هي مع إضافة الحقل الجديد
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AddProductIntety &&
        other.code == code &&
        other.name == name &&
        other.price == price &&
        other.description == description &&
        other.expirationDate == expirationDate &&
        other.unitAmount == unitAmount &&
        other.discountPercentage == discountPercentage &&
        other.category == category &&
other.categoryId == categoryId && 
      other.pharmacyId == pharmacyId;
  }

  @override
  int get hashCode => Object.hash(
    code,
    name,
    price,
    description,
    expirationDate,
    unitAmount,
    discountPercentage,
    category,
    pharmacyId,
  );
}
