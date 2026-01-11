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
  final num discountPercentage;
  bool get hasDiscount => discountPercentage > 0;

  const AddProductIntety({
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
  ];

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
        other.category == category;
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
  );
}
