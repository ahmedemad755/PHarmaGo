import 'package:e_commerce/core/functions_helper/build_overlay_bar.dart';
import 'package:e_commerce/core/functions_helper/routs.dart';
import 'package:e_commerce/featchers/auth/widgets/custombotton.dart';
import 'package:e_commerce/featchers/home/presentation/cubits/curt_cubit/cart_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomCartButton extends StatelessWidget {
  const CustomCartButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartCubit, CartState>(
      builder: (context, state) {
        final currentCart = switch (state) {
          CartInitial(cartEntity: final cart) => cart,
          CartUpdated(cartEntity: final cart) => cart,
          CartItemAdded(cartEntity: final cart) => cart,
          CartItemRemoved(cartEntity: final cart) => cart,
        };

        return GradientButton(
          onPressed: () {
            if (currentCart.cartItems.isNotEmpty) {
              print('✅ cartItems sent: ${currentCart.cartItems.length} items');
              print(currentCart.cartItems.toString());

              Navigator.pushNamed(
                context,
                AppRoutes.checkout,
                arguments: currentCart,
              );
            } else {
              showBar(context, 'لا يوجد منتجات في السلة');
            }
          },
          label: 'الدفع  ${currentCart.getTotalPrice()} جنيه',
        );
      },
    );
  }
}
