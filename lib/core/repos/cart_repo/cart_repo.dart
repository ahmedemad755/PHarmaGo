import 'package:e_commerce/core/enteties/product_enteti.dart';

abstract class CartRepo {
  // لاحظ هنا لا نستخدم Either لأن التعامل مع الشيرد بريفرنس محلياً نادراً ما يفشل
  // وإذا فشل نفضل التعامل معه مباشرة أو إرجاع قائمة فارغة
  Future<void> addProductToCart(AddProductIntety product);
  List<AddProductIntety> getCartProducts();
  Future<void> clearCart();
}