import 'package:e_commerce/Features/cart/domain/enteties/cart_item_entety.dart';
import 'package:e_commerce/Features/products/domain/entityes/product_enteti.dart';

///CartEntity
///يمثل السلة ككل
class CartEntity {
  ///cartItems — لائحة List<CartItemEntity>.
  final List<CartItemEntity> cartItems;
  const CartEntity(this.cartItems);

  CartEntity copyWith({List<CartItemEntity>? cartItems}) {
    return CartEntity(cartItems ?? this.cartItems);
  }

  ///addCartItem التي تضيف عنصر إلى هذه اللائحة.
  CartEntity addCartItem(CartItemEntity cartItemEntity) {
    final newCartItems = List<CartItemEntity>.from(cartItems);
    newCartItems.add(cartItemEntity);
    return CartEntity(newCartItems);
  }

  CartEntity removeCarItem(CartItemEntity carItem) {
    final newCartItems = List<CartItemEntity>.from(cartItems);
    newCartItems.removeWhere(
      (item) => item.productIntety == carItem.productIntety,
    );
    return CartEntity(newCartItems);
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

  CartItemEntity? getCartItemByProduct(AddProductIntety product) {
    for (var element in cartItems) {
      if (element.productIntety == product) {
        return element;
      }
    }
    return null;
  }
}
