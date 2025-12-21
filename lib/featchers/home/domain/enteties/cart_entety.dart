import 'dart:convert' show jsonEncode;
import 'dart:core';

import 'package:e_commerce/constants.dart';
import 'package:e_commerce/core/enteties/cart_item_entety.dart';
import 'package:e_commerce/core/enteties/product_enteti.dart';
import 'package:e_commerce/core/services/shared_prefs_singelton.dart';

///CartEntity
///يمثل السلة ككل
class CartEntity {
  ///cartItems — لائحة List<CartItemEntity>.
  final List<CartItemEntity> cartItems;
  CartEntity(this.cartItems);

  ///addCartItem التي تضيف عنصر إلى هذه اللائحة.
  addCartItem(CartItemEntity cartItemEntity) async {
    cartItems.add(cartItemEntity);
    await Prefs.setString(kCartData, jsonEncode(cartItems));
  }

  /// تحديث السلة في SharedPreferences
  Future<void> updateCartInStorage() async {
    await Prefs.setString(kCartData, jsonEncode(cartItems));
  }

  removeCarItem(CartItemEntity carItem) {
    cartItems.remove(carItem);
  }

  double getTotalPrice() {
    double totalPrice = 0;
    for (var element in cartItems) {
      totalPrice += element.calculateTotalPrice();
    }
    return totalPrice;
  }

  double getTotalWeight() {
    double totalWeight = 0;
    for (var element in cartItems) {
      totalWeight += element.calculateTotalWeight();
    }
    return totalWeight;
  }

  bool isexist(AddProductIntety product) {
    for (var element in cartItems) {
      if (element.productIntety == product) {
        return true;
      }
    }
    return false;
  }

  CartItemEntity getCartItemByProduct(AddProductIntety product) {
    for (var element in cartItems) {
      if (element.productIntety == product) {
        return element;
      }
    }
    return CartItemEntity(productIntety: product, quantty: 1);
  }
}
