import 'package:e_commerce/Features/checkout/domain/enteteis/shipping_address_entity.dart';
import 'package:e_commerce/Features/orders/domain/entities/order_product_entity.dart';
import 'package:e_commerce/Features/orders/domain/entities/order_status.dart';
import 'package:e_commerce/Features/orders/domain/entities/payment_method.dart';

/// يمثل طلب تم إنشاؤه بالفعل ورجع من Firestore. مختلف عن
/// OrderInputEntity (بتاعة Checkout)، اللي بتمثل مسودة الطلب وإحنا لسه
/// بنملاها فى شاشات الدفع.
class OrderEntity {
  const OrderEntity({
    required this.orderId,
    required this.userId,
    required this.createdAt,
    required this.paymentMethod,
    required this.status,
    required this.confirmedByPhone,
    required this.pharmacyId,
    required this.totalPrice,
    required this.shippingAddress,
    required this.orderProducts,
    this.pharmacyName,
    this.prescriptionImage,
  });

  final String orderId;
  final String userId;
  final DateTime createdAt;
  final PaymentMethod paymentMethod;
  final OrderStatus status;
  final bool confirmedByPhone;
  final String pharmacyId;

  // مش من الحقول المطلوبة أصلاً، لكن شاشة تفاصيل الطلب بتعرضها فعلاً
  // (اسم الصيدلية)، فلو اتشالت هتكسر الشاشة دي.
  final String? pharmacyName;
  final String? prescriptionImage;
  final double totalPrice;
  final ShippingAddressEntity shippingAddress;
  final List<OrderProductEntity> orderProducts;
}
