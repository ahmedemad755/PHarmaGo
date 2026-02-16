import 'package:e_commerce/core/enteties/cart_item_entety.dart';

class OrderProductModel {
  final String name;
  final String code;
  final String imageUrl;
  final double price;
  final int quantity;
  final String? pharmacyName;

  OrderProductModel({
    required this.name,
    required this.code,
    required this.imageUrl,
    required this.price,
    required this.quantity,
    this.pharmacyName,
  });

  factory OrderProductModel.fromJson(Map<String, dynamic> json) {
    return OrderProductModel(
      name: json['name']?.toString() ?? '',
      code: json['code']?.toString() ?? '',
      imageUrl: json['imageUrl']?.toString() ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      quantity: (json['quantity'] as num?)?.toInt() ?? 0,
      pharmacyName: json['pharmacyName']?.toString() ?? 'صيدلية عامة',
    );
  }

  factory OrderProductModel.fromEntity({
    required CartItemEntity cartItemEntity,
  }) {
    return OrderProductModel(
      name: cartItemEntity.productIntety.name,
      code: cartItemEntity.productIntety.code,
      imageUrl: cartItemEntity.productIntety.imageurl!,
      price: cartItemEntity.productIntety.price.toDouble(),
      quantity: cartItemEntity.quantty,
      pharmacyName: cartItemEntity.pharmacyName,
    );
  }

  toJson() {
    return {
      'name': name,
      'code': code,
      'imageUrl': imageUrl,
      'price': price,
      'quantity': quantity,
      'pharmacyName': pharmacyName,
    };
  }
}
