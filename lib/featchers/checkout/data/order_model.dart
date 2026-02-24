import 'package:e_commerce/featchers/checkout/data/order_product_model.dart';
import 'package:e_commerce/featchers/checkout/data/shipping_address_model.dart';
import 'package:e_commerce/featchers/checkout/domain/enteteis/order_entity.dart';
import 'package:uuid/uuid.dart';

class OrderModel {
  final double totalPrice;
  final String uId;
  final ShippingAddressModel shippingAddressModel;
  final List<OrderProductModel> orderProducts;
  final String paymentMethod;
  final String orderId;
  final String status; 
  final String date;   
  final String pharmacyId; // 🔹 الحقل موجود هنا

  OrderModel({
    required this.totalPrice,
    required this.uId,
    required this.orderId,
    required this.shippingAddressModel,
    required this.orderProducts,
    required this.paymentMethod,
    required this.status,
    required this.date,
    required this.pharmacyId, // 🔹 الحقل موجود هنا
  });

  factory OrderModel.fromEntity(OrderInputEntity orderEntity) {
    return OrderModel(
      orderId: const Uuid().v4(),
      totalPrice: orderEntity.calculatetotalpriceAfterDiscountAndDelivery(), // 🔹 تم التعديل لاستخدام السعر النهائي
      uId: orderEntity.uID,
      shippingAddressModel: ShippingAddressModel.fromEntity(
        orderEntity.shippingAddressEntity,
      ),
      orderProducts: orderEntity.cartEntity.cartItems
          .map((e) => OrderProductModel.fromEntity(cartItemEntity: e))
          .toList(),
      paymentMethod: orderEntity.payWithCash == true ? 'Cash' : 'Paypal',
      status: 'pending', 
      date: DateTime.now().toString(), 
      pharmacyId: orderEntity.pharmacyId, // 🔹 جلب المعرف من الـ Entity
    );
  }

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    var shippingAddress = json['shippingAddressModel'] as Map<String, dynamic>? ?? {};
    
    return OrderModel(
      orderId: json['orderId']?.toString() ?? '',
      totalPrice: (json['totalPrice'] as num?)?.toDouble() ?? 0.0,
      uId: json['uId']?.toString() ?? '',
      status: shippingAddress['status']?.toString() ?? json['status']?.toString() ?? 'pending',
      date: json['date']?.toString() ?? '',
      paymentMethod: json['paymentMethod']?.toString() ?? '',
      pharmacyId: json['pharmacyId']?.toString() ?? 'unknown', // 🔹 قراءة المعرف من JSON
      shippingAddressModel: ShippingAddressModel.fromJson(shippingAddress),
      orderProducts: (json['orderProducts'] as List<dynamic>?)
              ?.map((e) => OrderProductModel.fromJson(e as Map<String, dynamic>))
              .toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() => {
        'orderId': orderId,
        'totalPrice': totalPrice,
        'uId': uId,
        'status': status,
        'date': date,
        'pharmacyId': pharmacyId, // 🔹 حفظ المعرف في Firebase
        'shippingAddressModel': shippingAddressModel.toJson(),
        'orderProducts': orderProducts.map((e) => e.toJson()).toList(),
        'paymentMethod': paymentMethod,
      };
}