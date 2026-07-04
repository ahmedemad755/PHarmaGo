import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:e_commerce/Features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:e_commerce/Features/cart/domain/enteties/cart_item_entety.dart';
import 'package:e_commerce/Features/cart/domain/usecases/add_product_to_cart_usecase.dart';
import 'package:e_commerce/Features/cart/domain/usecases/clear_cart_usecase.dart';
import 'package:e_commerce/Features/cart/domain/usecases/delete_cart_item_usecase.dart';
import 'package:e_commerce/Features/cart/domain/usecases/get_cart_usecase.dart';
import 'package:e_commerce/Features/cart/domain/usecases/save_cart_usecase.dart';
import 'package:e_commerce/Features/cart/domain/usecases/update_quantity_usecase.dart';
import 'package:e_commerce/Features/products/domain/entityes/product_enteti.dart';
import 'package:e_commerce/Features/cart/domain/enteties/cart_entety.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart'; // تأكد من إضافة الـ package
import 'package:meta/meta.dart';

part 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit(
    CartEntity cartEntity, {
    required GetCurrentUserUseCase getCurrentUserUseCase,
    required GetCartUseCase getCartUseCase,
    required SaveCartUseCase saveCartUseCase,
    required ClearCartUseCase clearCartUseCase,
    required AddProductToCartUseCase addProductToCartUseCase,
    required UpdateQuantityUseCase updateQuantityUseCase,
    required DeleteCartItemUseCase deleteCartItemUseCase,
  }) : _getCurrentUserUseCase = getCurrentUserUseCase,
       _getCartUseCase = getCartUseCase,
       _saveCartUseCase = saveCartUseCase,
       _clearCartUseCase = clearCartUseCase,
       _addProductToCartUseCase = addProductToCartUseCase,
       _updateQuantityUseCase = updateQuantityUseCase,
       _deleteCartItemUseCase = deleteCartItemUseCase,
       super(CartInitial(cartEntity)) {
    _restoreCartOnInit();
  }

  final GetCurrentUserUseCase _getCurrentUserUseCase;
  final GetCartUseCase _getCartUseCase;
  final SaveCartUseCase _saveCartUseCase;
  final ClearCartUseCase _clearCartUseCase;
  final AddProductToCartUseCase _addProductToCartUseCase;
  final UpdateQuantityUseCase _updateQuantityUseCase;
  final DeleteCartItemUseCase _deleteCartItemUseCase;

  // 📸 متغير لحمل صورة الروشتة المختارة
  XFile? prescriptionImage;

  // ✅ Getter للتحقق هل السلة تحتوي على منتج يتطلب روشتة
  bool get isPrescriptionRequired => currentCart.cartItems.any(
    (item) => item.productIntety.isPrescriptionRequired == true,
  );

  // ✅ دالة لتحديث صورة الروشتة
  void setPrescriptionImage(XFile? image) {
    prescriptionImage = image;
    emit(CartUpdated(currentCart));
  }

  CartEntity getCartEntity(CartState state) {
    return switch (state) {
      CartInitial(cartEntity: final cart) => cart,
      CartUpdated(cartEntity: final cart) => cart,
      CartItemAdded(cartEntity: final cart) => cart,
      CartItemRemoved(cartEntity: final cart) => cart,
    };
  }

  CartEntity get currentCart => getCartEntity(state);
  List<CartItemEntity> get cartItems => currentCart.cartItems;

  void addProduct(
    AddProductIntety productEntity, {
    required int quantity,
    String? pharmacyId,
    String? pharmacyName,
    num? priceAtSelection,
  }) {
    print("🛒 ADDING TO CART: Product Name: ${productEntity.name}");
    print(
      "🛒 ADDING TO CART: Is Prescription Required: ${productEntity.isPrescriptionRequired}",
    );

    final updatedCart = _addProductToCartUseCase(
      currentCart,
      productEntity,
      quantity: quantity,
      pharmacyId: pharmacyId,
      pharmacyName: pharmacyName,
      priceAtSelection: priceAtSelection,
    );

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

    final cartBeforeUpdate = currentCart;
    final updatedCart = _updateQuantityUseCase(
      cartBeforeUpdate,
      productEntity,
      newQuantity,
      pharmacyId: pharmacyId,
    );

    // نفس الأصل بالظبط: لو المنتج مش موجود فى السلة، الـ UseCase بترجع
    // نفس الكائن من غير تغيير، فمفيش داعي نحفظ أو نعمل emit.
    if (identical(updatedCart, cartBeforeUpdate)) return;

    _saveCartToRepository(updatedCart);
    emit(CartUpdated(updatedCart));
  }

  void addPrescriptionToCart(
    File image,
    String pharmacyId,
    String pharmacyName,
  ) {
    // إنشاء كائن منتج وهمي متوافق مع الـ Entity الجديد الخاص بك مع تمرير كافة الحقول المطلوبة
    final dummyProduct = AddProductIntety(
      name: "روشتة طبية",
      code: "prescription_${DateTime.now().millisecondsSinceEpoch}",
      price: 0,
      cost: 0, // الحقل الجديد المطلوب
      description: "صورة روشتة مرفوعة من العميل", // الحقل الجديد المطلوب
      expirationDate: DateTime.now(), // الحقل الجديد المطلوب
      sellingcount: 0, // الحقل الجديد المطلوب
      reviews: const [], // الحقل الجديد المطلوب
      pharmacyId: pharmacyId, // الحقل الجديد المطلوب
      imageurl: null,
      unitAmount: 0,
      isPrescriptionRequired: true,
      pharmacyName: '',
      pharmacyLat: 0.0,
      pharmacyLng: 0.0,
    );

    final prescriptionItem = CartItemEntity(
      productIntety: dummyProduct,
      quantty: 1,
      isPrescription: true,
      prescriptionFile: image,
      pharmacyId: pharmacyId,
      pharmacyName: pharmacyName,
    );

    // الوصول للسلة الحالية وتحديثها
    final currentCartItems = List<CartItemEntity>.from(currentCart.cartItems);
    currentCartItems.add(prescriptionItem);

    final updatedCart = CartEntity(currentCartItems);
    _saveCartToRepository(updatedCart);
    emit(CartItemAdded(updatedCart));
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
    final updatedCart = _deleteCartItemUseCase(
      currentCart,
      productEntity,
      pharmacyId: pharmacyId,
    );

    _saveCartToRepository(updatedCart);
    emit(CartItemRemoved(updatedCart));
  }

  // الكيوبت ميعرفش Firebase؛ بيسأل GetCurrentUserUseCase بس عشان يجيب الـ uid.
  Future<String?> _currentUserId() async {
    final result = await _getCurrentUserUseCase();
    return result.fold((_) => null, (user) => user?.uId);
  }

  Future<void> clearCart() async {
    try {
      final userId = await _currentUserId();
      prescriptionImage = null; // مسح الصورة عند تفريغ السلة
      emit(CartUpdated(const CartEntity([])));
      if (userId != null) {
        await _clearCartUseCase(userId);
      }
      emit(CartInitial(const CartEntity([])));
    } catch (e) {
      emit(CartUpdated(const CartEntity([])));
    }
  }

  Future<void> loadCartFromRepository() async {
    final userId = await _currentUserId();
    if (userId == null) {
      emit(CartUpdated(const CartEntity([])));
      return;
    }

    try {
      final cart = await _getCartUseCase(userId);
      emit(CartUpdated(cart));
    } catch (_) {
      emit(CartUpdated(const CartEntity([])));
    }
  }

  Future<void> _restoreCartOnInit() async {
    // loadCartFromRepository بالفعل بتتعامل مع حالة عدم تسجيل الدخول.
    await loadCartFromRepository();
  }

  Future<void> _saveCartToRepository(CartEntity cart) async {
    final userId = await _currentUserId();
    if (userId == null) return;

    try {
      await _saveCartUseCase(userId, cart);
    } catch (e) {
      print("❌ Error saving cart: ${e.toString()}");
    }
  }

  void clearInMemoryCart() {
    prescriptionImage = null;
    emit(CartUpdated(const CartEntity([])));
  }
}
