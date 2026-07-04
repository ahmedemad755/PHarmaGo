import 'package:e_commerce/Features/cart/data/datasource/local/cart_local_datasource.dart';
import 'package:e_commerce/core/services/preferences/shared_prefs_service.dart';

class CartLocalDataSourceImpl implements CartLocalDataSource {
  static const String _baseKey = 'cart_data_v3_';
  static const String _guestKey = 'cart_data_guest';

  /// Use userId if provided, otherwise fallback to guest key
  String _keyForUser(String? userId) =>
      userId == null ? _guestKey : '$_baseKey$userId';

  @override
  Future<void> saveCart(String? userId, String cartJson) async {
    await Prefs.setString(_keyForUser(userId), cartJson);
  }

  @override
  Future<String?> loadCart(String? userId) async {
    final stored = Prefs.getString(_keyForUser(userId));
    if (stored.isEmpty) return null;
    return stored;
  }

  @override
  Future<void> clearCart(String? userId) async {
    await Prefs.remove(_keyForUser(userId));
  }
}
