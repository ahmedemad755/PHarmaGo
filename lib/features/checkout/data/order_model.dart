import 'package:e_commerce/Features/checkout/data/order_product_model.dart';
import 'package:e_commerce/Features/checkout/data/shipping_address_model.dart';
import 'package:e_commerce/Features/checkout/domain/enteteis/order_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class OrderModel {
  final double totalPrice;
  final String uId;
  // final String? userName;
  final ShippingAddressModel shippingAddressModel;
  final List<OrderProductModel> orderProducts;
  final String paymentMethod;
  final String? pharmacyName;
  final String orderId;
  final String status;
  final String date;
  final String pharmacyId;
  final dynamic createdAt; // وقت السيرفر للترتيب
  final String? prescriptionImage; // رابط الروشتة المرفوعة

  OrderModel({
    required this.totalPrice,
    required this.uId,
    required this.pharmacyName,
    // this.userName,
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
      orderProducts: orderEntity.isPrescription
          ? []
          : orderEntity.cartEntity!.cartItems
                .map((e) => OrderProductModel.fromEntity(cartItemEntity: e))
                .toList(),

      paymentMethod: orderEntity.payWithCash == true ? 'Cash' : 'Paypal',
      status: orderEntity.isPrescription ? 'awaiting_pricing' : 'pending',
      date: DateTime.now().toString(),
      createdAt: FieldValue.serverTimestamp(), // الوقت الفعلي من سيرفر جوجل
      pharmacyId: orderEntity.pharmacyId,
      pharmacyName: orderEntity.cartEntity!.cartItems.isNotEmpty
          ? orderEntity.cartEntity!.cartItems.first.pharmacyName ??
                'صيدلية عامة'
          : 'صيدلية عامة',
      // أخذ الرابط الذي تم إنشاؤه بعد رفع الصورة في الـ Cubit
      prescriptionImage: orderEntity.prescriptionImageUrl,
      // userName: orderEntity.userName,
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
      // userName: json['userName']?.toString(),
      shippingAddressModel: ShippingAddressModel.fromJson(
        json['shippingAddressModel'] as Map<String, dynamic>? ?? {},
      ),
      pharmacyName: json['pharmacyName']?.toString() ?? 'صيدلية عامة',
      orderProducts:
          (json['orderProducts'] as List<dynamic>?)
              ?.map(
                (e) => OrderProductModel.fromJson(e as Map<String, dynamic>),
              )
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
    'pharmacyName': pharmacyName,
    'prescriptionImage': prescriptionImage, // سيحفظ كـ URL أو null
    'shippingAddressModel': shippingAddressModel.toJson(),
    'orderProducts': orderProducts.map((e) => e.toJson()).toList(),
    'paymentMethod': paymentMethod,
    // 'userName': userName,
  };
}
