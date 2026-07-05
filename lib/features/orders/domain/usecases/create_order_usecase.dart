import 'package:dartz/dartz.dart';
import 'package:e_commerce/Features/checkout/domain/enteteis/order_entity.dart';
import 'package:e_commerce/Features/orders/domain/repositories/orders_repo.dart';
import 'package:e_commerce/core/errors/faliur.dart';

class CreateOrderUseCase {
  const CreateOrderUseCase(this._ordersRepo);

  final OrdersRepo _ordersRepo;

  Future<Either<Faliur, void>> call({required OrderInputEntity order}) {
    return _ordersRepo.addOrder(order: order);
  }
}
