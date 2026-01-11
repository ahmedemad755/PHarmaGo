import 'package:bloc/bloc.dart';
import 'package:e_commerce/core/enteties/cart_item_entety.dart';
import 'package:e_commerce/core/enteties/product_enteti.dart';
import 'package:e_commerce/core/repos/cart_repo/cart_repo.dart';
import 'package:e_commerce/featchers/home/domain/enteties/cart_entety.dart';
import 'package:meta/meta.dart';

part 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  final CartRepo _cartRepo;

  CartCubit(CartEntity cartEntity, CartRepo cartRepo)
    : _cartRepo = cartRepo,
      super(CartInitial(cartEntity));

  CartEntity get currentCart => switch (state) {
    CartInitial(cartEntity: final cart) => cart,
    CartUpdated(cartEntity: final cart) => cart,
    CartItemAdded(cartEntity: final cart) => cart,
    CartItemRemoved(cartEntity: final cart) => cart,
  };

  void addProduct(AddProductIntety productEntity, {required int quantity}) {
    final currentCartItems = List<CartItemEntity>.from(currentCart.cartItems);

    // البحث عن المنتج باستخدام المساواة الصحيحة
    final existingItemIndex = currentCartItems.indexWhere(
      (item) => item.productIntety == productEntity,
    );

    if (existingItemIndex != -1) {
      // المنتج موجود - تحديث الكمية
      final existingItem = currentCartItems[existingItemIndex];
      currentCartItems[existingItemIndex] = existingItem.copyWith(
        quantty: existingItem.quantty + quantity,
      );
    } else {
      currentCartItems.add(
        CartItemEntity(productIntety: productEntity, quantty: quantity),
      );
    }

    final updatedCart = CartEntity(currentCartItems);
    _saveCartToRepository(updatedCart);
    emit(CartItemAdded(updatedCart));
  }

  void updateQuantity(AddProductIntety productEntity, int newQuantity) {
    if (newQuantity <= 0) {
      deleteCarItemByProduct(productEntity);
      return;
    }

    final currentCartItems = List<CartItemEntity>.from(currentCart.cartItems);
    final existingItemIndex = currentCartItems.indexWhere(
      (item) => item.productIntety == productEntity,
    );

    if (existingItemIndex != -1) {
      final existingItem = currentCartItems[existingItemIndex];
      currentCartItems[existingItemIndex] = existingItem.copyWith(
        quantty: newQuantity,
      );

      final updatedCart = CartEntity(currentCartItems);
      _saveCartToRepository(updatedCart);
      emit(CartUpdated(updatedCart));
    }
  }

  void deleteCarItem(CartItemEntity cartItem) {
    deleteCarItemByProduct(cartItem.productIntety);
  }

  void deleteCarItemByProduct(AddProductIntety productEntity) {
    final currentCartItems = List<CartItemEntity>.from(currentCart.cartItems);
    currentCartItems.removeWhere((item) => item.productIntety == productEntity);

    final updatedCart = CartEntity(currentCartItems);
    _saveCartToRepository(updatedCart);
    emit(CartItemRemoved(updatedCart));
  }

  void clearCart() {
    final updatedCart = const CartEntity([]);
    emit(CartUpdated(updatedCart));
  }

  void loadCartFromRepository() {
    // تم تعطيل التحميل من التخزين حالياً لتبسيط المنطق وجعل السلة تعمل في الذاكرة فقط.
    // إذا أردت دعم الاسترجاع من التخزين لاحقاً، يمكن إعادة تفعيل هذا المنطق بعد إصلاح JSON.
  }

  void _saveCartToRepository(CartEntity cart) {
    // تم تعطيل الحفظ في التخزين حالياً لتفادي مشاكل JSON (مثل DateTime داخل AddProductModel).
    // السلة تعمل الآن في الذاكرة فقط طوال عمر التطبيق.
  }
}
