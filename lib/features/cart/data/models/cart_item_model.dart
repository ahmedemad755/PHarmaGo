import 'package:e_commerce/Features/cart/domain/enteties/cart_item_entety.dart';
import 'package:e_commerce/Features/products/data/model/product_model.dart';

class CartItemModel {
  CartItemModel({
    required this.product,
    required this.quantity,
    this.pharmacyId,
    this.pharmacyName,
    this.priceAtSelection,
  });

  final ProductModel product;
  final int quantity;
  final String? pharmacyId;
  final String? pharmacyName;
  final num? priceAtSelection;

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      product: ProductModel.fromJson(json['product'] as Map<String, dynamic>),
      quantity: json['quantity'] as int,
      pharmacyId: json['pharmacyId'] as String?,
      pharmacyName: json['pharmacyName'] as String?,
      priceAtSelection: (json['priceAtSelection'] as num?)?.toDouble(),
    );
  }

  factory CartItemModel.fromEntity(CartItemEntity entity) {
    return CartItemModel(
      product: ProductModel.fromentity(entity.productIntety),
      quantity: entity.quantty,
      pharmacyId: entity.pharmacyId,
      pharmacyName: entity.pharmacyName,
      priceAtSelection: entity.priceAtSelection,
    );
  }

  CartItemEntity toEntity() {
    return CartItemEntity(
      productIntety: product.toEntity(),
      quantty: quantity,
      pharmacyId: pharmacyId,
      pharmacyName: pharmacyName,
      priceAtSelection: priceAtSelection,
    );
  }

  Map<String, dynamic> toJson() {
    final productMap = product.toJson();

    // نفس المعالجة الأصلية اللي كانت جوه الـ Cubit لتفادي مشاكل تسلسل
    // DateTime/Timestamp عند حفظها فى الـ JSON.
    productMap.forEach((key, value) {
      if (value is DateTime) {
        productMap[key] = value.toIso8601String();
      } else if (value.runtimeType.toString() == 'Timestamp') {
        productMap[key] = (value as dynamic).toDate().toIso8601String();
      }
    });

    return {
      'product': productMap,
      'quantity': quantity,
      'pharmacyId': pharmacyId,
      'pharmacyName': pharmacyName,
      'priceAtSelection': priceAtSelection,
    };
  }
}
