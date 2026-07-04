import 'package:dartz/dartz.dart';
import 'package:e_commerce/Features/products/domain/entityes/product_enteti.dart';
import 'package:e_commerce/Features/products/domain/repositories/products_repo.dart';
import 'package:e_commerce/core/errors/faliur.dart';

class GetBestSellingProductsUseCase {
  GetBestSellingProductsUseCase(this._productsRepo);

  final ProductsRepo _productsRepo;

  Stream<Either<Faliur, List<AddProductIntety>>> call({int topN = 10}) {
    return _productsRepo.fetchBestSellingProductsStream(topN: topN);
  }
}
