import 'package:bloc/bloc.dart';
import 'package:e_commerce/core/enteties/cart_item_entety.dart';
import 'package:e_commerce/core/enteties/product_enteti.dart';
import 'package:e_commerce/featchers/home/domain/enteties/cart_entety.dart';

part 'cart_state.dart';

//CartCubit →
//هو مدير الحالة (state manager) للسلة كلها.
//يعني أي تعديل في السلة (إضافة/حذف/زيادة عدد) المفروض يتم من خلاله.
//CartEntity →
//تمثل السلة نفسها وتحتوي على قائمة بالعناصر (cartItems).
//CartItemEntity →
//يتمثل عنصر واحد داخل السلة (زي منتج واحد ومعاه الكمية والسعر

// ده الكيوبت المسؤول عن إدارة حالة (السلة)
class CartCubit extends Cubit<CartState> {
  // هنا بنبدأ الكيوبت بحالة ابتدائية وهي CartInitial
  CartCubit() : super(CartInitial());

  // دي السلة نفسها (كائن من CartEntity)
  // يعني cartEntity بتمثل السلة اللي فيها كل العناصر
  CartEntity cartEntity = CartEntity([]);

  // دالة لإضافة عنصر للسلة
  /// دالة لإضافة عنصر للسلة
  void addItemToCart(AddProductIntety product) {
    bool isProductExist = cartEntity.isexist(product);
    var cartItem = cartEntity.getCartItemByProduct(product);

    if (isProductExist) {
      cartItem.incrementquantty();
    } else {
      cartEntity.addCartItem(cartItem);
    }
    emit(CartItemAdd());
  }

  /// دالة لحذف عنصر من السلة
  void deleteCarItem(CartItemEntity carItem) {
    cartEntity.removeCarItem(carItem);
    emit(CartItemRemove());
  }
}
