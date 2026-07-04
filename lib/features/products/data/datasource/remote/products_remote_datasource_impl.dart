import 'package:e_commerce/Features/products/data/datasource/remote/products_remote_datasource.dart';
import 'package:e_commerce/core/services/database/database_service.dart';
import 'package:e_commerce/core/utils/backend_points.dart';

class ProductsRemoteDataSourceImpl implements ProductsRemoteDataSource {
  ProductsRemoteDataSourceImpl(this._databaseService);

  final DatabaseService _databaseService;

  @override
  Future<List<Map<String, dynamic>>> getProducts() async {
    final data = await _databaseService.getData(path: BackendPoints.getProducts);
    return data as List<Map<String, dynamic>>;
  }

  @override
  Stream<List<Map<String, dynamic>>> fetchBestSellingProducts({int topN = 10}) {
    return _databaseService.getCollectionStream(
      path: BackendPoints.getProducts,
      query: (q) => q.orderBy('sellingcount', descending: true).limit(topN),
    );
  }
}
