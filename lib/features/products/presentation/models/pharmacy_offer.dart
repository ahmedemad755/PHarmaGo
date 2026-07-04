class PharmacyOffer {
  final String id;
  final String name;
  final String address;
  final String status;
  final double originalPrice; // السعر الأصلي
  final double discountedPrice; // السعر بعد الخصم
  final double distanceKm;
  final int deliveryTimeMin;
  final double rating;
  final bool isSponsored;
  final int unitAmount; // الكمية المتاحة
  final bool hasDiscount; // حالة الخصم

  PharmacyOffer({
    required this.id,
    required this.name,
    required this.address,
    required this.status,
    required this.originalPrice,
    required this.discountedPrice,
    required this.distanceKm,
    required this.deliveryTimeMin,
    required this.rating,
    this.isSponsored = false,
    required this.unitAmount,
    required this.hasDiscount,
  });

  bool get isAvailable => unitAmount > 0;
  double get finalPrice => hasDiscount ? discountedPrice : originalPrice;
}
