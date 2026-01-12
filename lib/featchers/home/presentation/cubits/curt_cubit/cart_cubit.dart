import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:e_commerce/core/enteties/cart_item_entety.dart';
import 'package:e_commerce/core/enteties/product_enteti.dart';
import 'package:e_commerce/core/models/product_model.dart';
import 'package:e_commerce/core/repos/cart_repo/cart_repo.dart';
import 'package:e_commerce/featchers/home/domain/enteties/cart_entety.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

part 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  final CartRepo _cartRepo;

  CartCubit(CartEntity cartEntity, CartRepo cartRepo)
    : _cartRepo = cartRepo,
      super(CartInitial(cartEntity)) {
    _restoreCartOnInit();
  }

  CartEntity get currentCart => switch (state) {
    CartInitial(cartEntity: final cart) => cart,
    CartUpdated(cartEntity: final cart) => cart,
    CartItemAdded(cartEntity: final cart) => cart,
    CartItemRemoved(cartEntity: final cart) => cart,
  };

  void addProduct(AddProductIntety productEntity, {required int quantity}) {
    final currentCartItems = List<CartItemEntity>.from(currentCart.cartItems);

    final existingItemIndex = currentCartItems.indexWhere(
      (item) => item.productIntety == productEntity,
    );

    if (existingItemIndex != -1) {
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

  Future<void> clearCart() async {
    final user = FirebaseAuth.instance.currentUser;
    const updatedCart = CartEntity([]);
    if (user != null) {
      await _cartRepo.clearCart(user.uid);
    }
    emit(CartUpdated(updatedCart));
  }

  Future<void> loadCartFromRepository() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      emit(CartUpdated(const CartEntity([])));
      return;
    }

    try {
      final cartJson = await _cartRepo.getCartData(user.uid);

      if (cartJson == null || cartJson.isEmpty) {
        emit(CartUpdated(const CartEntity([])));
        return;
      }

      final List<dynamic> decoded = jsonDecode(cartJson) as List<dynamic>;
      final cartItems = decoded.map<CartItemEntity>((itemData) {
        final map = itemData as Map<String, dynamic>;
        final productJson = map['product'] as Map<String, dynamic>;
        final quantity = map['quantity'] as int;
        final product = AddProductModel.fromJson(productJson).toEntity();
        return CartItemEntity(productIntety: product, quantty: quantity);
      }).toList();
      final cart = CartEntity(cartItems);
      emit(CartUpdated(cart));
    } catch (_) {
      emit(CartUpdated(const CartEntity([])));
    }
  }

  Future<void> _restoreCartOnInit() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await loadCartFromRepository();
    }
  }

  Future<void> _saveCartToRepository(CartEntity cart) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final cartData = cart.cartItems.map((item) {
      return {
        'product': AddProductModel.fromentity(item.productIntety).toJson(),
        'quantity': item.quantty,
      };
    }).toList();

    final cartJson = jsonEncode(cartData);
    await _cartRepo.saveCartData(user.uid, cartJson);
  }

  void clearInMemoryCart() {
    const emptyCart = CartEntity([]);
    emit(CartUpdated(emptyCart));
  }
}
