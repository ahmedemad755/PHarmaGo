import 'package:dartz/dartz.dart';
import 'package:e_commerce/core/enteties/product_enteti.dart';
import 'package:e_commerce/core/errors/faliur.dart';
import 'package:e_commerce/core/models/product_model.dart';
import 'package:e_commerce/core/repos/products_repo/products_repo.dart';
import 'package:e_commerce/core/services/database_service.dart';
import 'package:e_commerce/core/utils/backend_points.dart';

class ProductsRepoImpl extends ProductsRepo {
  final DatabaseService databaseService;

  ProductsRepoImpl(this.databaseService);
  @override
  Future<Either<Faliur, List<AddProductIntety>>>
  getBestSellingProducts() async {
    try {
      var data =
          await databaseService.getData(
                path: BackendPoints.getBestSellingProducts,
                query: {
                  'limit': 10,
                  'orderBy': 'sellingcount',
                  'descending': true,
                },
              )
              as List<Map<String, dynamic>>;

      List<AddProductIntety> products = data
          .map((e) => AddProductModel.fromJson(e).toEntity())
          .toList();
      return right(products);
    } catch (e, s) {
      print('🔥 Error in getBestSellingProducts: $e');
      print(s);
      return left(ServerFaliur('Failed to get products'));
    }
  }

  @override
  Future<Either<Faliur, List<AddProductIntety>>> getProducts() async {
    try {
      var data =
          await databaseService.getData(path: BackendPoints.getProducts)
              as List<Map<String, dynamic>>;

      List<AddProductIntety> products = data
          .map((e) => AddProductModel.fromJson(e).toEntity())
          .toList();
      return right(products);
    } catch (e) {
      return left(ServerFaliur('Failed to get products'));
    }
  }
}
