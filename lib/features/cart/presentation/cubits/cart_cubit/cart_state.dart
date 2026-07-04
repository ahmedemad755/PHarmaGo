part of 'cart_cubit.dart';

@immutable
sealed class CartState extends Equatable {
  const CartState();

  @override
  List<Object?> get props => [];
}

final class CartInitial extends CartState {
  final CartEntity cartEntity;
  const CartInitial(this.cartEntity);

  @override
  List<Object?> get props => [cartEntity];
}

final class CartUpdated extends CartState {
  final CartEntity cartEntity;
  const CartUpdated(this.cartEntity);

  @override
  List<Object?> get props => [cartEntity, DateTime.now()];
}

final class CartItemAdded extends CartState {
  final CartEntity cartEntity;
  const CartItemAdded(this.cartEntity);

  @override
  List<Object?> get props => [cartEntity];
}

final class CartItemRemoved extends CartState {
  final CartEntity cartEntity;
  const CartItemRemoved(this.cartEntity);

  @override
  List<Object?> get props => [cartEntity];
}
