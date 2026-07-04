import 'package:dartz/dartz.dart';
import 'package:e_commerce/Features/products/data/datasource/remote/products_remote_datasource.dart';
import 'package:e_commerce/Features/products/data/model/product_model.dart';
import 'package:e_commerce/Features/products/domain/entityes/product_enteti.dart';
import 'package:e_commerce/Features/products/domain/repositories/products_repo.dart';
import 'package:e_commerce/core/errors/faliur.dart';

class ProductsRepoImpl extends ProductsRepo {
  ProductsRepoImpl(this._remoteDataSource);

  final ProductsRemoteDataSource _remoteDataSource;

  @override
  Future<Either<Faliur, List<AddProductIntety>>> getProducts() async {
    try {
      final data = await _remoteDataSource.getProducts();
      return right(_toEntities(data));
    } catch (e) {
      return left(ServerFaliur('فشل في تحميل المنتجات'));
    }
  }

  @override
  Stream<Either<Faliur, List<AddProductIntety>>>
  fetchBestSellingProductsStream({int topN = 10}) {
    return _remoteDataSource.fetchBestSellingProducts(topN: topN).map((data) {
      try {
        return right(_toEntities(data));
      } catch (e) {
        return left(ServerFaliur('فشل في جلب البيانات الحية'));
      }
    });
  }

  List<AddProductIntety> _toEntities(List<Map<String, dynamic>> data) {
    return data.map((e) => ProductModel.fromJson(e).toEntity()).toList();
  }
}
