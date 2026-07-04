import 'package:e_commerce/Features/cart/data/models/cart_model.dart';
import 'package:e_commerce/Features/cart/domain/enteties/cart_entety.dart';
import 'package:e_commerce/Features/cart/domain/repositories/cart_repo.dart';

class GetCartUseCase {
  const GetCartUseCase(this._cartRepo);

  final CartRepo _cartRepo;

  Future<CartEntity> call(String userId) async {
    final cartJson = await _cartRepo.getCartData(userId);
    if (cartJson == null || cartJson.isEmpty) {
      return const CartEntity([]);
    }
    return CartModel.fromJson(cartJson).toEntity();
  }
}
