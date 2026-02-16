part of 'cart_item_cubit.dart';

sealed class CartItemState {
  const CartItemState();
}

final class CartItemInitial extends CartItemState {}

final class CartItemUpdated extends CartItemState {
  // تم تغيير النوع إلى List لدعم إضافة أكثر من منتج
  final List<CartItemEntity> cartItemEntity; 

  const CartItemUpdated(this.cartItemEntity);
}