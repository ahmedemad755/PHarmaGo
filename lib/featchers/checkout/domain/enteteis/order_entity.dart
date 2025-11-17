import 'package:e_commerce/featchers/checkout/domain/enteteis/shipping_address_entity.dart';
import 'package:e_commerce/featchers/home/domain/enteties/cart_entety.dart';

class OrderInputEntity {
  final String uID;
  final CartEntity cartEntity;
  bool? payWithCash;
  ShippingAddressEntity shippingAddressEntity;
  OrderInputEntity(
    this.cartEntity, {
    required this.uID,
    this.payWithCash,
    ShippingAddressEntity? shippingAddressEntity,
  }) : shippingAddressEntity = shippingAddressEntity ?? ShippingAddressEntity();

  /// 🔹 المجموع الفرعي (السعر الإجمالي قبل التوصيل)
  double get totalPrice => cartEntity.getTotalPrice().toDouble();

  /// 🔹 تكلفة التوصيل (لو كاش = 50، لو أونلاين = 0)
  double get deliveryPrice => payWithCash == true ? 50.0 : 0.0;

  /// 🔹 السعر النهائي (المجموع الفرعي + التوصيل)
  double get finalPrice => totalPrice + deliveryPrice;

  int shippingdescount() {
    return 0;
  }

  double calculatetotalpriceAfterDiscountAndDelivery() {
    return cartEntity.getTotalPrice().toDouble() +
        deliveryPrice -
        shippingdescount();
  }
}
