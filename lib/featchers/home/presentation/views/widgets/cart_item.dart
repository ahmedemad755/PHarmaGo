import 'package:e_commerce/core/enteties/cart_item_entety.dart';
import 'package:e_commerce/core/utils/app_colors.dart';
import 'package:e_commerce/core/widgets/custom_network_image.dart';
import 'package:e_commerce/featchers/home/presentation/cubits/curt_cubit/cart_cubit.dart';
import 'package:e_commerce/featchers/home/presentation/views/widgets/cart_item_action_bottons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/utils/app_text_styles.dart';

class CartItem extends StatelessWidget {
  const CartItem({super.key, required this.carItemEntity});

  final CartItemEntity carItemEntity;

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

        final currentItem = currentCart.cartItems.firstWhere(
          (item) => item.productIntety == carItemEntity.productIntety,
          orElse: () => carItemEntity,
        );

        return IntrinsicHeight(
          child: Row(
            children: [
              Container(
                width: 73,
                height: 92,
                decoration: const BoxDecoration(color: Color(0xFFF3F5F7)),
                child: CustomNetworkImage(
                  imageUrl: currentItem.productIntety.imageurl!,
                ),
              ),
              const SizedBox(width: 17),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          currentItem.productIntety.name,
                          style: TextStyles.bold13,
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: () {
                            context.read<CartCubit>().deleteCarItem(
                              currentItem,
                            );
                          },
                          child: Icon(Icons.delete, color: Colors.red),
                        ),
                      ],
                    ),
                    Text(
                      '${currentItem.calculateTotalWeight()} كم',
                      textAlign: TextAlign.right,
                      style: TextStyles.regular13.copyWith(
                        color: AppColors.secondaryColor,
                      ),
                    ),
                    Row(
                      children: [
                        CartItemActionButtons(cartItemEntity: currentItem),
                        const Spacer(),
                        Text(
                          '${currentItem.calculateTotalPrice()} جنيه ',
                          style: TextStyles.bold16.copyWith(
                            color: AppColors.secondaryColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
