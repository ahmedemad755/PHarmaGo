import 'package:e_commerce/core/enteties/cart_item_entety.dart';

class OrderProductModel {
  final String name;
  final String code;
  final String imageUrl;
  final double price;
  final num cost;
  final int quantity;
  final String? pharmacyName;
  final bool isPrescriptionRequired; // ✅ تم إضافة الحقل هنا

  OrderProductModel({
    required this.name,
    required this.code,
    required this.imageUrl,
    required this.price,
    required this.cost,
    required this.quantity,
    required this.isPrescriptionRequired, // ✅ مطلوب في الـ Constructor
    this.pharmacyName,
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
    );
  }

  factory OrderProductModel.fromEntity({
    required CartItemEntity cartItemEntity,
  }) {
    return OrderProductModel(
      name: cartItemEntity.productIntety.name,
      code: cartItemEntity.productIntety.code,
      imageUrl: cartItemEntity.productIntety.imageurl ?? '',
      price: (cartItemEntity.priceAtSelection ?? cartItemEntity.productIntety.price).toDouble(),
      cost: cartItemEntity.productIntety.cost.toDouble(),
      quantity: cartItemEntity.quantty,
      pharmacyName: cartItemEntity.pharmacyName,
      // 🔥 نقل الحالة من كيان المنتج لضمان تفعيل التحقق في صفحة الدفع
      isPrescriptionRequired: cartItemEntity.productIntety.isPrescriptionRequired,
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
      'isPrescriptionRequired': isPrescriptionRequired, // ✅ حفظ الحالة في Firestore
    };
  }
}