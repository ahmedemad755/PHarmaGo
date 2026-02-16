import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:e_commerce/core/enteties/cart_item_entety.dart';
import 'package:e_commerce/core/enteties/product_enteti.dart';
import 'package:e_commerce/core/models/product_model.dart';
import 'package:e_commerce/core/repos/cart_repo/cart_repo.dart';
import 'package:e_commerce/featchers/home/domain/enteties/cart_entety.dart';
import 'package:equatable/equatable.dart';
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

  // --- 💡 وظيفة استخراج البيانات من الـ State لتبسيط الـ UI ---
  CartEntity getCartEntity(CartState state) {
    return switch (state) {
      CartInitial(cartEntity: final cart) => cart,
      CartUpdated(cartEntity: final cart) => cart,
      CartItemAdded(cartEntity: final cart) => cart,
      CartItemRemoved(cartEntity: final cart) => cart,
    };
  }

  // الحصول على السلة الحالية بناءً على الـ State الحالي للكيوبت
  CartEntity get currentCart => getCartEntity(state);

  void addProduct(
    AddProductIntety productEntity, {
    required int quantity,
    String? pharmacyId,
    String? pharmacyName,
    num? priceAtSelection,
  }) {
    final currentCartItems = List<CartItemEntity>.from(currentCart.cartItems);

    final existingItemIndex = currentCartItems.indexWhere(
      (item) =>
          item.productIntety.code == productEntity.code &&
          item.pharmacyId == pharmacyId,
    );

    if (existingItemIndex != -1) {
      final existingItem = currentCartItems[existingItemIndex];
      currentCartItems[existingItemIndex] = existingItem.copyWith(
        quantty: existingItem.quantty + quantity,
      );
    } else {
      currentCartItems.add(
        CartItemEntity(
          productIntety: productEntity,
          quantty: quantity,
          pharmacyId: pharmacyId,
          pharmacyName: pharmacyName,
          priceAtSelection: priceAtSelection,
        ),
      );
    }

    final updatedCart = CartEntity(currentCartItems);
    _saveCartToRepository(updatedCart);
    emit(CartItemAdded(updatedCart));
  }

  void updateQuantity(
    AddProductIntety productEntity,
    int newQuantity, {
    String? pharmacyId,
  }) {
    if (newQuantity <= 0) {
      deleteCarItemByProduct(productEntity, pharmacyId: pharmacyId);
      return;
    }

    final List<CartItemEntity> currentCartItems = List.from(
      currentCart.cartItems,
    );

    final existingItemIndex = currentCartItems.indexWhere(
      (item) =>
          item.productIntety.code == productEntity.code &&
          item.pharmacyId == pharmacyId,
    );

    if (existingItemIndex != -1) {
      currentCartItems[existingItemIndex] = currentCartItems[existingItemIndex]
          .copyWith(quantty: newQuantity);

      final updatedCart = CartEntity(currentCartItems);
      _saveCartToRepository(updatedCart);
      emit(CartUpdated(updatedCart));
    }
  }

  void deleteCarItem(CartItemEntity cartItem) {
    deleteCarItemByProduct(
      cartItem.productIntety,
      pharmacyId: cartItem.pharmacyId,
    );
  }

  void deleteCarItemByProduct(
    AddProductIntety productEntity, {
    String? pharmacyId,
  }) {
    final currentCartItems = List<CartItemEntity>.from(currentCart.cartItems);
    currentCartItems.removeWhere(
      (item) =>
          item.productIntety.code == productEntity.code &&
          item.pharmacyId == pharmacyId,
    );

    final updatedCart = CartEntity(currentCartItems);
    _saveCartToRepository(updatedCart);
    emit(CartItemRemoved(updatedCart));
  }

  Future<void> clearCart() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      emit(CartUpdated(const CartEntity([])));

      if (user != null) {
        await _cartRepo.clearCart(user.uid);
      }
      emit(CartInitial(const CartEntity([])));
    } catch (e) {
      emit(CartUpdated(const CartEntity([])));
    }
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
        final product = AddProductModel.fromJson(productJson).toEntity();

        return CartItemEntity(
          productIntety: product,
          quantty: map['quantity'] as int,
          pharmacyId: map['pharmacyId'],
          pharmacyName: map['pharmacyName'],
          priceAtSelection: map['priceAtSelection'],
        );
      }).toList();

      emit(CartUpdated(CartEntity(cartItems)));
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
        'pharmacyId': item.pharmacyId,
        'pharmacyName': item.pharmacyName,
        'priceAtSelection': item.priceAtSelection,
      };
    }).toList();

    await _cartRepo.saveCartData(user.uid, jsonEncode(cartData));
  }

  void clearInMemoryCart() {
    emit(CartUpdated(const CartEntity([])));
  }
}