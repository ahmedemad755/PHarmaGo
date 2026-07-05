import 'package:e_commerce/Features/cart/domain/enteties/cart_item_entety.dart';
import 'package:e_commerce/Features/orders/domain/entities/order_product_entity.dart';

class OrderProductModel {
  final String name;
  final String code;
  final String imageUrl;
  final double price;
  final num cost;
  final int quantity;
  final String? pharmacyName;
  final bool isPrescriptionRequired; // ✅ تم إضافة الحقل هنا
  final String? prescriptionImageUrl; // بيتحدد لاحقاً من الأدمن لأوردرات الروشتة

  OrderProductModel({
    required this.name,
    required this.code,
    required this.imageUrl,
    required this.price,
    required this.cost,
    required this.quantity,
    required this.isPrescriptionRequired, // ✅ مطلوب في الـ Constructor
    this.pharmacyName,
    this.prescriptionImageUrl,
  });

  factory OrderProductModel.fromJson(Map<String, dynamic> json) {
    return OrderProductModel(
      name: json['name']?.toString() ?? '',
      code: json['code']?.toString() ?? '',
      imageUrl: json['imageUrl']?.toString() ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      cost: (json['cost'] as num?) ?? 0,
      quantity: (json['quantity'] as num?)?.toInt() ?? 0,
      pharmacyName: json['pharmacyName']?.toString() ?? 'صيدلية عامة',
      // ✅ قراءة القيمة من JSON عند جلب الطلبات القديمة
      isPrescriptionRequired: json['isPrescriptionRequired'] as bool? ?? false,
      prescriptionImageUrl: json['prescriptionImageUrl']?.toString(),
    );
  }

  factory OrderProductModel.fromEntity({
    required CartItemEntity cartItemEntity,
  }) {
    return OrderProductModel(
      name: cartItemEntity.productIntety.name,
      code: cartItemEntity.productIntety.code,
      imageUrl: cartItemEntity.productIntety.imageurl ?? '',
      price:
          (cartItemEntity.priceAtSelection ??
                  cartItemEntity.productIntety.price)
              .toDouble(),
      cost: cartItemEntity.productIntety.cost.toDouble(),
      quantity: cartItemEntity.quantty,
      pharmacyName: cartItemEntity.pharmacyName,
      // 🔥 نقل الحالة من كيان المنتج لضمان تفعيل التحقق في صفحة الدفع
      isPrescriptionRequired:
          cartItemEntity.productIntety.isPrescriptionRequired,
    );
  }

  /// من الـ Entity الخاصة بالـ Orders (طلب موجود بالفعل) - مستخدمة جوه
  /// OrderModel.fromEntity بس، مش فى مسار إنشاء الطلب.
  factory OrderProductModel.fromOrderProductEntity(OrderProductEntity entity) {
    return OrderProductModel(
      name: entity.name,
      code: entity.code,
      imageUrl: entity.imageUrl,
      price: entity.price,
      cost: 0,
      quantity: entity.quantity,
      isPrescriptionRequired: entity.isPrescriptionRequired,
      prescriptionImageUrl: entity.prescriptionImageUrl,
    );
  }

  OrderProductEntity toEntity() {
    return OrderProductEntity(
      name: name,
      code: code,
      imageUrl: imageUrl,
      quantity: quantity,
      price: price,
      isPrescriptionRequired: isPrescriptionRequired,
      prescriptionImageUrl: prescriptionImageUrl,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'code': code,
      'imageUrl': imageUrl,
      'price': price,
      'cost': cost,
      'quantity': quantity,
      'pharmacyName': pharmacyName,
      'isPrescriptionRequired':
          isPrescriptionRequired, // ✅ حفظ الحالة في Firestore
      'prescriptionImageUrl': prescriptionImageUrl,
    };
  }
}
