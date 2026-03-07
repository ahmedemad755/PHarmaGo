import 'package:e_commerce/featchers/checkout/data/order_product_model.dart';
import 'package:e_commerce/featchers/checkout/data/shipping_address_model.dart';
import 'package:e_commerce/featchers/checkout/domain/enteteis/order_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  final String pharmacyId;
  final dynamic createdAt; // وقت السيرفر للترتيب
  final String? prescriptionImage; // رابط الروشتة المرفوعة

  OrderModel({
    required this.totalPrice,
    required this.uId,
    required this.orderId,
    required this.shippingAddressModel,
    required this.orderProducts,
    required this.paymentMethod,
    required this.status,
    required this.date,
    required this.pharmacyId,
    this.createdAt,
    this.prescriptionImage,
  });

  factory OrderModel.fromEntity(OrderInputEntity orderEntity) {
    return OrderModel(
      // توليد ID فريد للطلب إذا لم يكن موجوداً
      orderId: const Uuid().v4(),
      totalPrice: orderEntity.calculatetotalpriceAfterDiscountAndDelivery(),
      uId: orderEntity.uID,
      shippingAddressModel: ShippingAddressModel.fromEntity(
        orderEntity.shippingAddressEntity,
      ),
      // تحويل كل منتج في السلة إلى OrderProductModel
      orderProducts: orderEntity.cartEntity.cartItems
          .map((e) => OrderProductModel.fromEntity(cartItemEntity: e))
          .toList(),
      paymentMethod: orderEntity.payWithCash == true ? 'Cash' : 'Paypal',
      status: 'pending',
      date: DateTime.now().toString(),
      createdAt: FieldValue.serverTimestamp(), // الوقت الفعلي من سيرفر جوجل
      pharmacyId: orderEntity.pharmacyId,
      // أخذ الرابط الذي تم إنشاؤه بعد رفع الصورة في الـ Cubit
      prescriptionImage: orderEntity.prescriptionImageUrl,
    );
  }

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      orderId: json['orderId']?.toString() ?? '',
      totalPrice: (json['totalPrice'] as num?)?.toDouble() ?? 0.0,
      uId: json['uId']?.toString() ?? '',
      status: json['status']?.toString() ?? 'pending',
      date: json['date']?.toString() ?? '',
      createdAt: json['createdAt'],
      paymentMethod: json['paymentMethod']?.toString() ?? '',
      pharmacyId: json['pharmacyId']?.toString() ?? 'unknown',
      prescriptionImage: json['prescriptionImage']?.toString(),
      shippingAddressModel: ShippingAddressModel.fromJson(
        json['shippingAddressModel'] as Map<String, dynamic>? ?? {},
      ),
      orderProducts: (json['orderProducts'] as List<dynamic>?)
              ?.map((e) => OrderProductModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
        'orderId': orderId,
        'totalPrice': totalPrice,
        'uId': uId,
        'status': status,
        'date': date,
        'createdAt': createdAt ?? FieldValue.serverTimestamp(),
        'pharmacyId': pharmacyId,
        'prescriptionImage': prescriptionImage, // سيحفظ كـ URL أو null
        'shippingAddressModel': shippingAddressModel.toJson(),
        'orderProducts': orderProducts.map((e) => e.toJson()).toList(),
        'paymentMethod': paymentMethod,
      };
}