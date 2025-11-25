import 'package:e_commerce/core/enteties/product_enteti.dart';

AddProductIntety getDummyProduct() {
  return AddProductIntety(
    name: 'Apple',
    code: '123',
    description: 'Fresh apple',
    price: 2.5,
    reviews: [],
    expirationDate: 6,
    unitAmount: 1,
    isOrganic: true,
    imageurl: null,
    numberOfcalories: 100, sellingcount: 20,
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
