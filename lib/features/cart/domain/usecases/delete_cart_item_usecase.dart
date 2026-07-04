import 'package:e_commerce/Features/cart/domain/enteties/cart_entety.dart';
import 'package:e_commerce/Features/cart/domain/enteties/cart_item_entety.dart';
import 'package:e_commerce/Features/products/domain/entityes/product_enteti.dart';

/// عملية حسابية بحتة: بتاخد السلة الحالية وترجع نسخة جديدة منها بدون
/// العنصر المطلوب حذفه. مفيهاش أي اتصال بالـ Repository أو التخزين.
class DeleteCartItemUseCase {
  const DeleteCartItemUseCase();

  CartEntity call(
    CartEntity currentCart,
    AddProductIntety product, {
    String? pharmacyId,
  }) {
    final items = List<CartItemEntity>.from(currentCart.cartItems)
      ..removeWhere(
        (item) =>
            item.productIntety.code == product.code &&
            item.pharmacyId == pharmacyId,
      );

    return CartEntity(items);
  }
}
