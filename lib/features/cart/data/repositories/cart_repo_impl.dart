import 'package:e_commerce/Features/cart/data/datasource/local/cart_local_datasource.dart';
import 'package:e_commerce/Features/cart/domain/repositories/cart_repo.dart';

class CartRepoImpl extends CartRepo {
  CartRepoImpl(this._localDataSource);

  final CartLocalDataSource _localDataSource;

  @override
  Future<void> saveCartData(String? userId, String cartJson) {
    return _localDataSource.saveCart(userId, cartJson);
  }

  @override
  Future<String?> getCartData(String? userId) {
    return _localDataSource.loadCart(userId);
  }

  @override
  Future<void> clearCart(String? userId) {
    return _localDataSource.clearCart(userId);
  }
}
