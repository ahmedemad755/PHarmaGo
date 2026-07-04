import 'package:e_commerce/Features/cart/presentation/cubits/cart_item_cubit/cart_item_cubit.dart';
import 'package:e_commerce/Features/cart/presentation/widgets/CartViewBody.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartView extends StatelessWidget {
  const CartView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CartItemCubit(),
      child: CartViewBody(),
    );
  }
}
