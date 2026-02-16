import 'package:e_commerce/core/enteties/cart_item_entety.dart';
import 'package:e_commerce/featchers/home/presentation/views/widgets/cart_item.dart';
import 'package:flutter/material.dart';

class CartItemsList extends StatelessWidget {
  const CartItemsList({super.key, required this.carItems});
  
  final List<CartItemEntity> carItems;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.only(top: 8, bottom: 16),
      sliver: SliverList.separated(
        itemCount: carItems.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: CartItem(carItemEntity: carItems[index]),
          );
        },
        separatorBuilder: (context, index) => const CustomDivider(),
      ),
    );
  }
}

class CustomDivider extends StatelessWidget {
  const CustomDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Divider(
        color: Color(0xFFF1F1F5), 
        thickness: 1.2, 
        height: 24,
      ),
    );
  }
}