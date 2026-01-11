import 'package:e_commerce/core/enteties/product_enteti.dart';
import 'package:equatable/equatable.dart';

/// يمثل عنصر واحد في السلة (Item). فيه:
/// productIntety — بيانات المنتج (من AddProductIntety).
/// count — عدد نفس المنتج داخل السلة.
class CartItemEntity extends Equatable {
  final AddProductIntety productIntety;
  final int quantty;

  const CartItemEntity({required this.productIntety, required this.quantty});

  CartItemEntity copyWith({AddProductIntety? productIntety, int? quantty}) {
    return CartItemEntity(
      productIntety: productIntety ?? this.productIntety,
      quantty: quantty ?? this.quantty,
    );
  }

  num calculateTotalPrice() {
    return productIntety.price * quantty;
  }

  num calculateTotalWeight() {
    return productIntety.unitAmount * quantty;
  }

  CartItemEntity incrementQuantity() {
    return copyWith(quantty: quantty + 1);
  }

  CartItemEntity decrementQuantity() {
    if (quantty > 1) {
      return copyWith(quantty: quantty - 1);
    }
    return this;
  }

  @override
  List<Object?> get props => [productIntety, quantty];
}
