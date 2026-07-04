import 'package:e_commerce/Features/cart/data/models/cart_model.dart';
import 'package:e_commerce/Features/cart/domain/enteties/cart_entety.dart';
import 'package:e_commerce/Features/cart/domain/repositories/cart_repo.dart';

class SaveCartUseCase {
  const SaveCartUseCase(this._cartRepo);

  final CartRepo _cartRepo;

  Future<void> call(String userId, CartEntity cart) {
    return _cartRepo.saveCartData(userId, CartModel.fromEntity(cart).toJson());
  }
}
