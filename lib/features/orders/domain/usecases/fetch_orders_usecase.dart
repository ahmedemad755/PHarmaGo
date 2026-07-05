import 'package:dartz/dartz.dart';
import 'package:e_commerce/Features/orders/domain/entities/order_entity.dart';
import 'package:e_commerce/Features/orders/domain/repositories/orders_repo.dart';
import 'package:e_commerce/core/errors/faliur.dart';

class FetchOrdersUseCase {
  const FetchOrdersUseCase(this._ordersRepo);

  final OrdersRepo _ordersRepo;

  Stream<Either<Faliur, List<OrderEntity>>> call({required String uID}) {
    return _ordersRepo.fetchOrders(uID: uID);
  }
}
