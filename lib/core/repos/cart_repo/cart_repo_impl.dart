import 'package:e_commerce/core/repos/cart_repo/cart_repo.dart';
import 'package:e_commerce/core/services/shared_prefs_singelton.dart';

class CartRepoImpl extends CartRepo {
  static const String _baseKey = 'cart_data_v3_';
  static const String _guestKey = 'cart_data_guest';

  /// Use userId if provided, otherwise fallback to guest key
  String _keyForUser(String? userId) =>
      userId == null ? _guestKey : '$_baseKey$userId';

  @override
  Future<void> saveCartData(String? userId, String cartJson) async {
    await Prefs.setString(_keyForUser(userId), cartJson);
  }

  @override
  Future<String?> getCartData(String? userId) async {
    final stored = Prefs.getString(_keyForUser(userId));
    if (stored.isEmpty) return null;
    return stored;
  }

  @override
  Future<void> clearCart(String? userId) async {
    await Prefs.remove(_keyForUser(userId));
  }
}
