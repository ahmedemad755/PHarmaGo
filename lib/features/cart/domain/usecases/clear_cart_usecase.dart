import 'package:e_commerce/Features/cart/domain/repositories/cart_repo.dart';

class ClearCartUseCase {
  const ClearCartUseCase(this._cartRepo);

  final CartRepo _cartRepo;

  Future<void> call(String userId) {
    return _cartRepo.clearCart(userId);
  }
}
