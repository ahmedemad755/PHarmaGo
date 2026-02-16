import 'package:e_commerce/featchers/checkout/data/order_model.dart';
import 'package:meta/meta.dart';

@immutable
abstract class OrdersState {}

class OrdersInitial extends OrdersState {}

class OrdersLoading extends OrdersState {}

class OrdersSuccess extends OrdersState {
  final List<OrderModel> orders;
  OrdersSuccess(this.orders);
}

class OrdersFailure extends OrdersState {
  final String errMessage;
  OrdersFailure(this.errMessage);
}
