import 'package:e_commerce/core/enteties/product_enteti.dart';
import 'package:equatable/equatable.dart';

/// يمثل عنصر واحد في السلة (Item). فيه:
/// productIntety — بيانات المنتج (من AddProductIntety).
/// count — عدد نفس المنتج داخل السلة.
// ignore: must_be_immutable
class CartItemEntity extends Equatable {
  final AddProductIntety productIntety;

  int quantty;

  CartItemEntity({required this.productIntety, this.quantty = 0});

  num calculateTotalPrice() {
    return productIntety.price * quantty;
  }

  num calculateTotalWeight() {
    return productIntety.unitAmount * quantty;
  }

  incrementquantty() {
    quantty++;
  }

  decrementquantty() {
    if (quantty > 0) {
      quantty--;
    }
  }

  @override
  List<Object?> get props => [productIntety];
}
