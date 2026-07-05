class OrderProductEntity {
  const OrderProductEntity({
    required this.name,
    required this.code,
    required this.imageUrl,
    required this.quantity,
    required this.price,
    required this.isPrescriptionRequired,
    this.prescriptionImageUrl,
  });

  final String name;
  final String code;
  final String imageUrl;
  final int quantity;
  final double price;
  final bool isPrescriptionRequired;
  final String? prescriptionImageUrl;
}
