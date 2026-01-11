part of 'cart_cubit.dart';

@immutable
sealed class CartState {}

final class CartInitial extends CartState {
  final CartEntity cartEntity;
  CartInitial(this.cartEntity);
}

final class CartUpdated extends CartState {
  final CartEntity cartEntity;
  CartUpdated(this.cartEntity);
}

final class CartItemAdded extends CartState {
  final CartEntity cartEntity;
  CartItemAdded(this.cartEntity);
}

final class CartItemRemoved extends CartState {
  final CartEntity cartEntity;
  CartItemRemoved(this.cartEntity);
}
