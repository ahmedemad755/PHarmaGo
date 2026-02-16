import 'package:e_commerce/core/utils/app_colors.dart';
import 'package:e_commerce/core/utils/app_text_styles.dart';
import 'package:e_commerce/featchers/home/presentation/cubits/cart_cubit/cart_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartHeader extends StatelessWidget {
  const CartHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1), // استخدام لون الهوية بشفافية
        borderRadius: BorderRadius.circular(8),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: BlocBuilder<CartCubit, CartState>(
        builder: (context, state) {
          final currentCart = context.read<CartCubit>().getCartEntity(state);
          final count = currentCart.cartItems.length;
          
          return Text(
            'لديك $count ${count >= 3 && count <= 10 ? 'منتجات' : 'منتج'} في سلة التسوق',
            textAlign: TextAlign.center,
            style: TextStyles.bold13.copyWith(
              color: AppColors.primary,
            ),
          );
        },
      ),
    );
  }
}