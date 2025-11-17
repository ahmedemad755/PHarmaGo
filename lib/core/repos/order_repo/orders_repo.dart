import 'package:dartz/dartz.dart';
import 'package:e_commerce/core/errors/faliur.dart';
import 'package:e_commerce/featchers/checkout/domain/enteteis/order_entity.dart';

abstract class OrdersRepo {
  Future<Either<Faliur, void>> addOrder({required OrderInputEntity order});
}
