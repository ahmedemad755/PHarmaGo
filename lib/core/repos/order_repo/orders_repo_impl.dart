import 'package:dartz/dartz.dart';
import 'package:e_commerce/core/errors/faliur.dart';
import 'package:e_commerce/core/repos/order_repo/orders_repo.dart';
import 'package:e_commerce/core/services/database_service.dart';
import 'package:e_commerce/core/utils/backend_points.dart';
import 'package:e_commerce/featchers/checkout/data/order_model.dart';
import 'package:e_commerce/featchers/checkout/domain/enteteis/order_entity.dart';

class OrdersRepoImpl implements OrdersRepo {
  final DatabaseService fireStoreService;
  OrdersRepoImpl(this.fireStoreService);
  @override
  Future<Either<Faliur, void>> addOrder({
    required OrderInputEntity order,
  }) async {
    try {
      var orderModel = OrderModel.fromEntity(order);
      await fireStoreService.addData(
        path: BackendPoints.orders,
        data: orderModel.toJson(),
        documentId: orderModel.orderId,
      );
    } catch (e) {
      return left(ServerFaliur(e.toString()));
    }
    return right(null);
  }
}
