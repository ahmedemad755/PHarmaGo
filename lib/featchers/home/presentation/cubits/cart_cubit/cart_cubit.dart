import 'dart:convert';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:e_commerce/core/enteties/cart_item_entety.dart';
import 'package:e_commerce/core/enteties/product_enteti.dart';
import 'package:e_commerce/core/models/product_model.dart';
import 'package:e_commerce/core/repos/cart_repo/cart_repo.dart';
import 'package:e_commerce/featchers/home/domain/enteties/cart_entety.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart'; // تأكد من إضافة الـ package
import 'package:meta/meta.dart';

part 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  final CartRepo _cartRepo;

  // 📸 متغير لحمل صورة الروشتة المختارة
  XFile? prescriptionImage;

  CartCubit(CartEntity cartEntity, CartRepo cartRepo)
    : _cartRepo = cartRepo,
      super(CartInitial(cartEntity)) {
    _restoreCartOnInit();
  }

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
      prescriptionImage = null; // مسح الصورة عند تفريغ السلة
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
          priceAtSelection: (map['priceAtSelection'] as num?)?.toDouble(),
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

    try {
      final cartData = cart.cartItems.map((item) {
        // تحويل الـ Entity لموديل ثم لـ Map
        Map<String, dynamic> productMap = AddProductModel.fromentity(
          item.productIntety,
        ).toJson();

        // 🔥 معالجة التواريخ داخل الـ Product Map لتجنب خطأ الـ Json
        productMap.forEach((key, value) {
          if (value is DateTime) {
            productMap[key] = value.toIso8601String();
          } else if (value.runtimeType.toString() == 'Timestamp') {
            // التعامل مع Timestamp الخاص بفايربيز لو موجود
            productMap[key] = value.toDate().toIso8601String();
          }
        });

        return {
          'product': productMap,
          'quantity': item.quantty,
          'pharmacyId': item.pharmacyId,
          'pharmacyName': item.pharmacyName,
          'priceAtSelection': item.priceAtSelection,
        };
      }).toList();

      // الآن الحفظ سيتم بنجاح لأن كل القيم أصبحت String/Num
      await _cartRepo.saveCartData(user.uid, jsonEncode(cartData));
    } catch (e) {
      print("❌ Error saving cart: ${e.toString()}");
    }
  }

  void clearInMemoryCart() {
    prescriptionImage = null;
    emit(CartUpdated(const CartEntity([])));
  }
}
