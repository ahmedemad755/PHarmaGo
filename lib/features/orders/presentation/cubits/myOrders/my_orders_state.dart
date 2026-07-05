import 'package:e_commerce/Features/orders/domain/entities/order_entity.dart';
import 'package:meta/meta.dart';

@immutable
abstract class OrdersState {}

class OrdersInitial extends OrdersState {}

class OrdersLoading extends OrdersState {}

class OrdersSuccess extends OrdersState {
  final List<OrderEntity> orders;
  final bool hasNotification; // ✅ الحقل الجديد
  OrdersSuccess(this.orders, {this.hasNotification = false});
}

class OrdersFailure extends OrdersState {
  final String errMessage;
  OrdersFailure(this.errMessage);
}
