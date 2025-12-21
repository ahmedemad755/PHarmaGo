import 'package:e_commerce/core/enteties/product_enteti.dart';

AddProductIntety getDummyProduct() {
  return AddProductIntety(
    name: 'Paracetamol 500mg',
    code: 'PH-123456',
    description: 'مسكن للألم وخافض للحرارة',
    price: 25.0,
    reviews: [],
    expirationDate: DateTime(2026, 4, 12), // 12-4-2026
    unitAmount: 20, // عدد الأقراص
    imageurl: null,
    sellingcount: 0,
    category: 'الأدوية',
    averageRating: 0,
    ratingcount: 0,
  );
}

List<AddProductIntety> getDummyProducts() {
  return [
    getDummyProduct(),
    getDummyProduct(),
    getDummyProduct(),
    getDummyProduct(),
    getDummyProduct(),
  ];
}
