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
  final String category; // New: Product category field
  final num discountPercentage;
  bool get hasDiscount => discountPercentage > 0;

  AddProductIntety( {
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
    this.discountPercentage=0,
    this.category = 'الأدوية', // Default category
  });

  @override
  List<Object?> get props => [code,discountPercentage];
}
