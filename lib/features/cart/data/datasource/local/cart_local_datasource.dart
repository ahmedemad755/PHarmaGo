abstract class CartLocalDataSource {
  Future<void> saveCart(String? userId, String cartJson);

  Future<String?> loadCart(String? userId);

  Future<void> clearCart(String? userId);
}
