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
    pharmacyId: '123',
    categoryId: 'cat-001',
    cost: 15.0, // تم إضافة الحقل الجديد هنا
    isPrescriptionRequired: false, // تم إضافة الحقل الجديد هنا
    pharmacyName: 'صيدلية ', // اسم الصيدلية
    pharmacyLat: 30.0444, // خط العرض
    pharmacyLng: 31.2357, // خط الطول
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
