import 'package:e_commerce/Features/orders/data/models/order_product_model.dart';
import 'package:e_commerce/Features/orders/data/models/shipping_address_model.dart';
import 'package:e_commerce/Features/orders/domain/entities/order_entity.dart';
import 'package:e_commerce/Features/orders/domain/entities/order_status.dart';
import 'package:e_commerce/Features/orders/domain/entities/payment_method.dart';
import 'package:e_commerce/Features/checkout/domain/enteteis/order_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class OrderModel {
  final double totalPrice;
  final String uId;
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
  final bool confirmedByPhone;

  OrderModel({
    required this.totalPrice,
    required this.uId,
    required this.pharmacyName,
    required this.orderId,
    required this.shippingAddressModel,
    required this.orderProducts,
    required this.paymentMethod,
    required this.status,
    required this.date,
    required this.pharmacyId,
    this.createdAt,
    this.prescriptionImage,
    this.confirmedByPhone = false,
  });

  /// من مسودة الطلب (OrderInputEntity بتاعة Checkout) وقت إنشاء طلب جديد.
  /// نفس المنطق الأصلي بالظبط - الاسم بس اتغير من fromEntity.
  factory OrderModel.fromInputEntity(OrderInputEntity orderEntity) {
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
status: _statusToJson(
  orderEntity.isPrescription
      ? OrderStatus.awaitingPricing
      : OrderStatus.pending,
),      date: DateTime.now().toString(),
      createdAt: FieldValue.serverTimestamp(), // الوقت الفعلي من سيرفر جوجل
      pharmacyId: orderEntity.pharmacyId,
      pharmacyName: orderEntity.cartEntity!.cartItems.isNotEmpty
          ? orderEntity.cartEntity!.cartItems.first.pharmacyName ??
                'صيدلية عامة'
          : 'صيدلية عامة',
      // أخذ الرابط الذي تم إنشاؤه بعد رفع الصورة في الـ Cubit
      prescriptionImage: orderEntity.prescriptionImageUrl,
      confirmedByPhone: false,
    );
  }

  /// اتجاه Domain -> Data: من الـ OrderEntity الخاصة بطلب موجود بالفعل.
  factory OrderModel.fromEntity(OrderEntity entity) {
    return OrderModel(
      orderId: entity.orderId,
      uId: entity.userId,
      totalPrice: entity.totalPrice,
      shippingAddressModel: ShippingAddressModel.fromEntity(
        entity.shippingAddress,
      ),
      orderProducts: entity.orderProducts
          .map(OrderProductModel.fromOrderProductEntity)
          .toList(),
      paymentMethod: _paymentMethodToJson(entity.paymentMethod),
      status: _statusToJson(entity.status),
      date: entity.createdAt.toString(),
      createdAt: Timestamp.fromDate(entity.createdAt),
      pharmacyId: entity.pharmacyId,
      pharmacyName: entity.pharmacyName,
      prescriptionImage: entity.prescriptionImage,
      confirmedByPhone: entity.confirmedByPhone,
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
      pharmacyName: json['pharmacyName']?.toString() ?? 'صيدلية عامة',
      orderProducts:
          (json['orderProducts'] as List<dynamic>?)
              ?.map(
                (e) => OrderProductModel.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          [],
      confirmedByPhone: json['confirmedByPhone'] as bool? ?? false,
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
    'confirmedByPhone': confirmedByPhone,
  };

  /// اتجاه Data -> Domain. التحويل بين String <-> Enum و Timestamp <->
  /// DateTime بيحصل هنا بس - الـ Presentation والـ Repository محدش فيهم
  /// بيعرف حاجة عن Firestore types.
  OrderEntity toEntity() {
    return OrderEntity(
      orderId: orderId,
      userId: uId,
      createdAt: _resolveCreatedAt(),
      paymentMethod: _paymentMethodFromJson(paymentMethod),
      status: _statusFromJson(status),
      confirmedByPhone: confirmedByPhone,
      pharmacyId: pharmacyId,
      pharmacyName: pharmacyName,
      prescriptionImage: prescriptionImage,
      totalPrice: totalPrice,
      shippingAddress: shippingAddressModel.toEntity(),
      orderProducts: orderProducts.map((e) => e.toEntity()).toList(),
    );
  }

  /// بنفضّل createdAt (وقت السيرفر الحقيقي)، ولو مش موجود بنرجع لـ date
  /// كنص احتياطي - عشان التوافق مع الطلبات القديمة اللي متسجلتش فيها.
  DateTime _resolveCreatedAt() {
    final rawCreatedAt = createdAt;
    if (rawCreatedAt is Timestamp) {
      return rawCreatedAt.toDate();
    }if (rawCreatedAt is DateTime) {
    return rawCreatedAt;
}
    return DateTime.tryParse(date) ?? DateTime.now();
  }

static OrderStatus _statusFromJson(String value) {
  switch (value.toLowerCase()) {
    case 'awaiting_pricing':
      return OrderStatus.awaitingPricing;

    case 'pending':
      return OrderStatus.pending;

    case 'accepted':
      return OrderStatus.accepted;

    case 'preparing':
      return OrderStatus.preparing;

    case 'delivering':
      return OrderStatus.delivering;

    case 'delivered':
      return OrderStatus.delivered;

    case 'cancelled':
    case 'canceled':
      return OrderStatus.cancelled;

    default:
      return OrderStatus.pending;
  }
}

static String _statusToJson(OrderStatus status) {
  switch (status) {
    case OrderStatus.awaitingPricing:
      return 'awaiting_pricing';

    case OrderStatus.pending:
      return 'pending';

    case OrderStatus.accepted:
      return 'accepted';

    case OrderStatus.preparing:
      return 'preparing';

    case OrderStatus.delivering:
      return 'delivering';

    case OrderStatus.delivered:
      return 'delivered';

    case OrderStatus.cancelled:
      return 'cancelled';
  }
}
  static PaymentMethod _paymentMethodFromJson(String value) {
    return value.toLowerCase() == 'paypal'
        ? PaymentMethod.paypal
        : PaymentMethod.cash;
  }

  static String _paymentMethodToJson(PaymentMethod method) {
    return method == PaymentMethod.paypal ? 'Paypal' : 'Cash';
  }
}
