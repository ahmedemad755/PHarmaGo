abstract class CartRepo {
  Future<void> saveCartData(String cartJson);
  String? getCartData();
  Future<void> clearCart();
}
