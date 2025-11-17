import 'package:e_commerce/core/functions_helper/build_overlay_bar.dart';
import 'package:e_commerce/core/functions_helper/routs.dart';
import 'package:e_commerce/featchers/auth/widgets/custombotton.dart';
import 'package:e_commerce/featchers/home/presentation/cubits/cart_item_cubit/cart_item_cubit.dart';
import 'package:e_commerce/featchers/home/presentation/cubits/curt_cubit/cart_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomCartButton extends StatelessWidget {
  const CustomCartButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartItemCubit, CartItemState>(
      builder: (context, state) {
        return CustomButton(
          onPressed: () {
            if (context.read<CartCubit>().cartEntity.cartItems.isNotEmpty) {
              // نطبع اللوج في الكونسول للتأكد
              print(
                '✅ cartItems sent: ${context.read<CartCubit>().cartEntity.cartItems.length} items',
              );
              print(context.read<CartCubit>().cartEntity.cartItems.toString());

              Navigator.pushNamed(
                context,
                AppRoutes.checkout,
                arguments: context.read<CartCubit>().cartEntity,
              );
            } else {
              showBar(context, 'لا يوجد منتجات في السلة');
            }
          },

          text:
              'الدفع  ${context.watch<CartCubit>().cartEntity.getTotalPrice()} جنيه',
        );
      },
    );
  }
}
