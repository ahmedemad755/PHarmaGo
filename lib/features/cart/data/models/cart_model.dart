import 'dart:convert';

import 'package:e_commerce/Features/cart/data/models/cart_item_model.dart';
import 'package:e_commerce/Features/cart/domain/enteties/cart_entety.dart';

class CartModel {
  CartModel(this.items);

  final List<CartItemModel> items;

  factory CartModel.fromJson(String cartJson) {
    final decoded = jsonDecode(cartJson) as List<dynamic>;
    return CartModel(
      decoded
          .map((item) => CartItemModel.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  factory CartModel.fromEntity(CartEntity entity) {
    return CartModel(
      entity.cartItems.map(CartItemModel.fromEntity).toList(),
    );
  }

  CartEntity toEntity() {
    return CartEntity(items.map((item) => item.toEntity()).toList());
  }

  String toJson() {
    return jsonEncode(items.map((item) => item.toJson()).toList());
  }
}
