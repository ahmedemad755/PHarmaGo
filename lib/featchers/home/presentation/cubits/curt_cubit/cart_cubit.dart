import 'package:bloc/bloc.dart';
import 'package:e_commerce/core/enteties/cart_item_entety.dart';
import 'package:e_commerce/core/enteties/product_enteti.dart';
import 'package:e_commerce/core/repos/cart_repo/cart_repo.dart';
import 'package:e_commerce/featchers/home/domain/enteties/cart_entety.dart';

part 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  final CartEntity cartEntity;
  final CartRepo cartRepo;

  CartCubit(this.cartEntity, this.cartRepo) : super(CartInitial());


  /// إضافة عنصر للسلة
void addItemToCart(AddProductIntety product, {int quantity = 1}) async {
    // إرسال حالة تحميل مؤقتة (اختياري) ولكن مفيد لإجبار الواجهة على التحديث
    bool exists = cartEntity.isexist(product);

    if (exists) {
      CartItemEntity item = cartEntity.getCartItemByProduct(product);
      item.quantty += quantity;
    } else {
      CartItemEntity newItem =
          CartItemEntity(productIntety: product, quantty: quantity);

      await cartEntity.addCartItem(newItem);
    }

    await cartEntity.updateCartInStorage();

    // إرسال الحالة الجديدة - تأكد أن CartItemAdd لا تستخدم الـ const 
    // إذا كنت تريد إجبار الـ BlocBuilder على إعادة البناء
    emit(CartItemAdd()); 
  }

  /// حذف عنصر
  void deleteCarItem(CartItemEntity cartItem) async {
    cartEntity.removeCarItem(cartItem);
    await cartEntity.updateCartInStorage();
    emit(CartItemRemove());
  }
}
