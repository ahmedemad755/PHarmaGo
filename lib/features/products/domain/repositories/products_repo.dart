import 'package:dartz/dartz.dart';
import 'package:e_commerce/Features/products/domain/entityes/product_enteti.dart';
import 'package:e_commerce/core/errors/faliur.dart';

abstract class ProductsRepo {
  Future<Either<Faliur, List<AddProductIntety>>> getProducts();

  // تغيير هذه الدالة لتعمل كـ Stream لمراقبة التغيير في الـ sellingcount
  Stream<Either<Faliur, List<AddProductIntety>>>
  fetchBestSellingProductsStream({int topN = 10});
}
