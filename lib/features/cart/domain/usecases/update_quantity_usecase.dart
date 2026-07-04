import 'package:e_commerce/Features/cart/domain/enteties/cart_entety.dart';
import 'package:e_commerce/Features/cart/domain/enteties/cart_item_entety.dart';
import 'package:e_commerce/Features/cart/domain/usecases/delete_cart_item_usecase.dart';
import 'package:e_commerce/Features/products/domain/entityes/product_enteti.dart';

/// عملية حسابية بحتة برضو: بترجع نسخة جديدة من السلة بعد تحديث كمية عنصر
/// معين. لو الكمية الجديدة صفر أو أقل، بتفوض الحذف لـ [DeleteCartItemUseCase]
/// - نفس سلوك الكيوبت الأصلي بالظبط.
class UpdateQuantityUseCase {
  const UpdateQuantityUseCase(this._deleteCartItemUseCase);

  final DeleteCartItemUseCase _deleteCartItemUseCase;

  CartEntity call(
    CartEntity currentCart,
    AddProductIntety product,
    int newQuantity, {
    String? pharmacyId,
  }) {
    if (newQuantity <= 0) {
      return _deleteCartItemUseCase(
        currentCart,
        product,
        pharmacyId: pharmacyId,
      );
    }

    final items = List<CartItemEntity>.from(currentCart.cartItems);
    final existingIndex = items.indexWhere(
      (item) =>
          item.productIntety.code == product.code &&
          item.pharmacyId == pharmacyId,
    );

    // نفس الأصل: لو العنصر مش موجود، السلة ترجع زي ما هي من غير تغيير.
    if (existingIndex == -1) return currentCart;

    items[existingIndex] = items[existingIndex].copyWith(
      quantty: newQuantity,
    );

    return CartEntity(items);
  }
}
