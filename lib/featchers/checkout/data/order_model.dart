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
  final String status; // أضفنا هذا الحقل لقراءة الحالة
  final String date;   // أضفنا هذا الحقل لقراءة التاريخ

  OrderModel({
    required this.totalPrice,
    required this.uId,
    required this.orderId,
    required this.shippingAddressModel,
    required this.orderProducts,
    required this.paymentMethod,
    required this.status,
    required this.date,
  });

  factory OrderModel.fromEntity(OrderInputEntity orderEntity) {
    return OrderModel(
      orderId: const Uuid().v4(),
      totalPrice: orderEntity.cartEntity.getTotalPrice(),
      uId: orderEntity.uID,
      shippingAddressModel: ShippingAddressModel.fromEntity(
        orderEntity.shippingAddressEntity,
      ),
      orderProducts: orderEntity.cartEntity.cartItems
          .map((e) => OrderProductModel.fromEntity(cartItemEntity: e))
          .toList(),
      paymentMethod: orderEntity.payWithCash! ? 'Cash' : 'Paypal',
      status: 'pending', // قيمة افتراضية عند الإنشاء
      date: DateTime.now().toString(),
    );
  }

  // 💡 الميثود الجديدة لتحويل البيانات القادمة من Firebase
factory OrderModel.fromJson(Map<String, dynamic> json) {
    // 💡 نلاحظ هنا أن الـ status موجود داخل الـ shippingAddressModel في الداتابيز عندك
    var shippingAddress = json['shippingAddressModel'] as Map<String, dynamic>? ?? {};
    
    return OrderModel(
      orderId: json['orderId']?.toString() ?? '',
      totalPrice: (json['totalPrice'] as num?)?.toDouble() ?? 0.0,
      uId: json['uId']?.toString() ?? '',
      // 💡 تعديل قراءة الحالة لتطابق بياناتك في Firebase
      status: shippingAddress['status']?.toString() ?? json['status']?.toString() ?? 'pending',
      date: json['date']?.toString() ?? '',
      paymentMethod: json['paymentMethod']?.toString() ?? '',
      shippingAddressModel: ShippingAddressModel.fromJson(shippingAddress),
      orderProducts: (json['orderProducts'] as List<dynamic>?)
              ?.map((e) => OrderProductModel.fromJson(e as Map<String, dynamic>))
              .toList() ?? [],
    );
  }

  toJson() => {
        'orderId': orderId,
        'totalPrice': totalPrice,
        'uId': uId,
        'status': status,
        'date': date,
        'shippingAddressModel': shippingAddressModel.toJson(),
        'orderProducts': orderProducts.map((e) => e.toJson()).toList(),
        'paymentMethod': paymentMethod,
      };
}