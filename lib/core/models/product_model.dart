import 'package:e_commerce/core/enteties/product_enteti.dart';
import 'package:e_commerce/core/functions_helper/get_Avg_Rating.dart';
import 'package:e_commerce/core/models/review_model.dart';

class AddProductModel {
  final String name;
  final num price;
  final String code;
  final String description;
  String? imageurl;
  final bool isOrganic;
  final num numberOfcalories;
  final num averageRating;
  final int ratingcount = 0;
  final int expirationDate;
  final num sellingcount;
  final int unitAmount;
  final List<ReviewModel> reviews;
  AddProductModel({
    required this.name,
    required this.price,
    required this.code,
    required this.description,
    this.imageurl,
    this.isOrganic = false,
    this.numberOfcalories = 0,
    this.averageRating = 0,
    required this.expirationDate,
    required this.unitAmount,
    required this.reviews,
    this.sellingcount = 0,
  });

  factory AddProductModel.fromJson(Map<String, dynamic> json) {
    return AddProductModel(
      averageRating: getAvgRating(
        json['reviews'] != null
            ? List<ReviewModel>.from(
                json['reviews'].map((e) => ReviewModel.fromJson(e)),
              )
            : [],
      ),
      name: json['name'],
      price: json['price'],
      code: json['code'],
      description: json['description'],
      sellingcount: json['sellingcount'],
      imageurl: json['imageurl'],
      isOrganic: json['isOrganic'] ?? false,
      numberOfcalories: json['numberOfcalories'],
      expirationDate: json['expirationDate'],
      unitAmount: json['unitAmount'],
      reviews: json['reviews'] != null
          ? List<ReviewModel>.from(
              json['reviews'].map((e) => ReviewModel.fromJson(e)),
            )
          : [],
    );
  }

  factory AddProductModel.fromentity(AddProductIntety addProductIntety) {
    return AddProductModel(
      name: addProductIntety.name,
      price: addProductIntety.price,
      code: addProductIntety.code,
      description: addProductIntety.description,
      imageurl: addProductIntety.imageurl,
      isOrganic: addProductIntety.isOrganic,
      numberOfcalories: addProductIntety.numberOfcalories,
      averageRating: addProductIntety.averageRating,
      expirationDate: addProductIntety.expirationDate,
      unitAmount: addProductIntety.unitAmount,
      reviews: addProductIntety.reviews
          .map((e) => ReviewModel.fromentity(e))
          .toList(),
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
      isOrganic: isOrganic,
      numberOfcalories: numberOfcalories,
      imageurl: imageurl,
       sellingcount: sellingcount
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'price': price,
      'code': code,
      'description': description,
      'imageurl': imageurl,
      'isOrganic': isOrganic,
      'numberOfcalories': numberOfcalories,
      'averageRating': averageRating,
      'ratingcount': ratingcount,
      'expirationDate': expirationDate,
      'unitAmount': unitAmount,
      'reviews': reviews.map((e) => e.toJson()).toList(),
    };
  }
}
