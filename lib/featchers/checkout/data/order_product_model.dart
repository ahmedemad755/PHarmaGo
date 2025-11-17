import 'package:e_commerce/core/enteties/cart_item_entety.dart';

class OrderProductModel {
  final String name;
  final String code;
  final String imageUrl;
  final double price;
  final int quantity;

  OrderProductModel({
    required this.name,
    required this.code,
    required this.imageUrl,
    required this.price,
    required this.quantity,
  });

  factory OrderProductModel.fromEntity({
    required CartItemEntity cartItemEntity,
  }) {
    return OrderProductModel(
      name: cartItemEntity.productIntety.name,
      code: cartItemEntity.productIntety.code,
      imageUrl: cartItemEntity.productIntety.imageurl!,
      price: cartItemEntity.productIntety.price.toDouble(),
      quantity: cartItemEntity.quantty,
    );
  }

  toJson() {
    return {
      'name': name,
      'code': code,
      'imageUrl': imageUrl,
      'price': price,
      'quantity': quantity,
    };
  }
}
