abstract class CartRepo {
  Future<void> saveCartData(String userId, String cartJson);
  Future<String?> getCartData(String userId);
  Future<void> clearCart(String userId);
}
