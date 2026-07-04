abstract class ProductsRemoteDataSource {
  Future<List<Map<String, dynamic>>> getProducts();

  Stream<List<Map<String, dynamic>>> fetchBestSellingProducts({int topN = 10});
}
