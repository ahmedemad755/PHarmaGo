import 'package:e_commerce/core/enteties/product_enteti.dart';
import 'package:equatable/equatable.dart';

class CartItemEntity extends Equatable {
  final AddProductIntety productIntety;
  final int quantty;
  // أضفنا هذه الحقول لدعم فلو الصيدليات
  final String? pharmacyId;
  final String? pharmacyName;
  final num? priceAtSelection;

  const CartItemEntity({
    required this.productIntety,
    required this.quantty,
    this.pharmacyId,
    this.pharmacyName,
    this.priceAtSelection,
  });

  CartItemEntity copyWith({
    AddProductIntety? productIntety,
    int? quantty,
    String? pharmacyId,
    String? pharmacyName,
    num? priceAtSelection,
  }) {
    return CartItemEntity(
      productIntety: productIntety ?? this.productIntety,
      quantty: quantty ?? this.quantty,
      pharmacyId: pharmacyId ?? this.pharmacyId,
      pharmacyName: pharmacyName ?? this.pharmacyName,
      priceAtSelection: priceAtSelection ?? this.priceAtSelection,
    );
  }

  // نستخدم السعر المختار من الصيدلية، وإذا لم يوجد نستخدم سعر المنتج الافتراضي
  num calculateTotalPrice() {
    return (priceAtSelection ?? productIntety.price) * quantty;
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
  List<Object?> get props => [productIntety, quantty, pharmacyId];
}
