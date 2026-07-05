import 'package:dartz/dartz.dart';
import 'package:e_commerce/Features/orders/domain/repositories/orders_repo.dart';
import 'package:e_commerce/core/errors/faliur.dart';

class CancelOrderUseCase {
  const CancelOrderUseCase(this._ordersRepo);

  final OrdersRepo _ordersRepo;

  Future<Either<Faliur, void>> call({required String orderId}) {
    return _ordersRepo.cancelOrder(orderId: orderId);
  }
}
