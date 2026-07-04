import 'package:e_commerce/Features/cart/domain/enteties/cart_entety.dart';
import 'package:e_commerce/Features/cart/domain/enteties/cart_item_entety.dart';
import 'package:e_commerce/Features/products/domain/entityes/product_enteti.dart';

/// عملية حسابية بحتة: بترجع نسخة جديدة من السلة بعد إضافة منتج، أو دمجه
/// مع عنصر موجود بالفعل لنفس المنتج/الصيدلية عن طريق جمع الكمية. مفيهاش
/// أي اتصال بالـ Repository أو التخزين.
class AddProductToCartUseCase {
  const AddProductToCartUseCase();

  CartEntity call(
    CartEntity currentCart,
    AddProductIntety product, {
    required int quantity,
    String? pharmacyId,
    String? pharmacyName,
    num? priceAtSelection,
  }) {
    final items = List<CartItemEntity>.from(currentCart.cartItems);
    final existingIndex = items.indexWhere(
      (item) =>
          item.productIntety.code == product.code &&
          item.pharmacyId == pharmacyId,
    );

    if (existingIndex != -1) {
      items[existingIndex] = items[existingIndex].copyWith(
        quantty: items[existingIndex].quantty + quantity,
      );
    } else {
      items.add(
        CartItemEntity(
          productIntety: product,
          quantty: quantity,
          pharmacyId: pharmacyId,
          pharmacyName: pharmacyName,
          priceAtSelection: priceAtSelection,
        ),
      );
    }

    return CartEntity(items);
  }
}
