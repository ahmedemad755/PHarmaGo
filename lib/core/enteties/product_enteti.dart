import 'package:e_commerce/core/enteties/review_entite.dart';
import 'package:equatable/equatable.dart';

class AddProductIntety extends Equatable {
  final String name;
  final num price;
  final String code;
  final String description;
  final String? imageurl;
  final int expirationDate;
  final int unitAmount;
  final bool isOrganic;
  final num numberOfcalories;
  final num averageRating;
  final int ratingcount;
  final num sellingcount;
  final List<ReviewEntite> reviews;

  AddProductIntety({
    required this.name,
    required this.price,
    required this.code,
    required this.description,
    this.imageurl,
    required this.expirationDate,
    required this.unitAmount,
    this.isOrganic = false,
    required this.numberOfcalories,
    this.averageRating = 0,
    this.ratingcount = 0,
    required this.sellingcount,
    required this.reviews,
  });

  @override
  List<Object?> get props => [code];
}
