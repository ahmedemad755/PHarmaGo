import 'package:e_commerce/featchers/checkout/domain/enteteis/shipping_address_entity.dart';
import 'package:e_commerce/featchers/home/domain/enteties/cart_entety.dart';
import 'package:image_picker/image_picker.dart';

class OrderInputEntity {
  final String uID;
  final CartEntity cartEntity;
  String pharmacyId; // 🔹 تم إزالة final لتسمح بالتحديث عند الدفع
  bool? payWithCash;
  XFile? prescriptionFile;
  ShippingAddressEntity shippingAddressEntity;
  String? prescriptionImageUrl;

  OrderInputEntity(
    this.cartEntity, {
    required this.uID,
    required this.pharmacyId,
    this.payWithCash,
    this.prescriptionFile,
    ShippingAddressEntity? shippingAddressEntity,
    this.prescriptionImageUrl,
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