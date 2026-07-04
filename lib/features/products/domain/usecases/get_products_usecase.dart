import 'package:dartz/dartz.dart';
import 'package:e_commerce/Features/products/domain/entityes/product_enteti.dart';
import 'package:e_commerce/Features/products/domain/repositories/products_repo.dart';
import 'package:e_commerce/core/errors/faliur.dart';

class GetProductsUseCase {
  GetProductsUseCase(this._productsRepo);

  final ProductsRepo _productsRepo;

  Future<Either<Faliur, List<AddProductIntety>>> call() {
    return _productsRepo.getProducts();
  }
}
