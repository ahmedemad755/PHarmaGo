import 'package:bloc/bloc.dart';
import 'package:e_commerce/core/enteties/cart_item_entety.dart';

part 'cart_item_state.dart';

class CartItemCubit extends Cubit<CartItemState> {
  CartItemCubit() : super(CartItemInitial());

  void updateCartItem(CartItemEntity carItem) {
    // 1. تحديد القائمة الحالية
    List<CartItemEntity> currentItems = [];
    
    if (state is CartItemUpdated) {
      currentItems = (state as CartItemUpdated).cartItemEntity;
    }

    // 2. تصفية القائمة (حذف المنتج لو كان موجوداً سابقاً لتحديثه بالنسخة الجديدة)
    // نستخدم المقارنة المباشرة لأنك تستخدم Equatable في الـ Entity
    final filteredList = currentItems.where((item) {
      return item.productIntety != carItem.productIntety;
    }).toList();

    // 3. إضافة العنصر الجديد للقائمة
    final newList = [...filteredList, carItem];

    // 4. إرسال الحالة الجديدة
    emit(CartItemUpdated(newList));
  }

  // ميثود مساعدة لمسح عنصر من السلة نهائياً
  void removeItem(CartItemEntity carItem) {
    if (state is CartItemUpdated) {
      final currentItems = (state as CartItemUpdated).cartItemEntity;
      final newList = currentItems.where((item) => item.productIntety != carItem.productIntety).toList();
      emit(CartItemUpdated(newList));
    }
  }
}