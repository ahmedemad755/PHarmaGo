import 'package:dartz/dartz.dart';
import 'package:e_commerce/core/enteties/product_enteti.dart';
import 'package:e_commerce/core/errors/faliur.dart';

abstract class ProductsRepo {
  Future<Either<Faliur, List<AddProductIntety>>> getProducts();
  Future<Either<Faliur, List<AddProductIntety>>> getBestSellingProducts();
}
