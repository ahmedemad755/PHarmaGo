import 'package:e_commerce/core/repos/cart_repo/cart_repo.dart';
import 'package:e_commerce/core/services/shared_prefs_singelton.dart';

class CartRepoImpl extends CartRepo {
  static const String kCartKey = 'cart_data_v3';

  @override
  Future<void> saveCartData(String cartJson) async {
    await Prefs.setString(kCartKey, cartJson);
  }

  @override
  String? getCartData() {
    return Prefs.getString(kCartKey);
  }

  @override
  Future<void> clearCart() async {
    await Prefs.remove(kCartKey);
  }
}
