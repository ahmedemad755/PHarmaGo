import 'dart:ui';

import 'package:e_commerce/featchers/home/presentation/cubits/cart_cubit/cart_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BottomNavPage extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavPage({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            height: 70,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.4),
              borderRadius: BorderRadius.circular(25),
              border: Border.all(color: Colors.white.withOpacity(0.2)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _navItem(context, icon: Icons.home, index: 0),
                _navItem(context, icon: Icons.grid_view, index: 1),
                _navItem(context, icon: Icons.alarm, index: 2),
                _navItem(context, image: "assets/chatbot_icon.png", index: 3),
                _navItem(
                  context,
                  image: "assets/shopping-basket.png",
                  index: 4,
                ),
                _navItem(context, icon: Icons.person, index: 5),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _navItem(
    BuildContext context, {
    IconData? icon,
    String? image,
    required int index,
  }) {
    final bool isSelected = currentIndex == index;

    if (index == 4) {
      return BlocBuilder<CartCubit, CartState>(
        buildWhen: (previous, current) => true,
        builder: (context, state) {
          final currentCart = switch (state) {
            CartInitial(cartEntity: final cart) => cart,
            CartUpdated(cartEntity: final cart) => cart,
            CartItemAdded(cartEntity: final cart) => cart,
            CartItemRemoved(cartEntity: final cart) => cart,
          };
          final itemsCount = currentCart.cartItems.length;

          return GestureDetector(
            onTap: () => onTap(index), // استدعاء الدالة الممررة من MainView
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                _buildIconOrImage(icon, image, isSelected),
                if (itemsCount > 0)
                  Positioned(
                    right: -2,
                    top: -2,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      constraints: const BoxConstraints(
                        minWidth: 20,
                        minHeight: 20,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 1.5),
                      ),
                      child: Center(
                        child: Text(
                          itemsCount.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            height: 1,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      );
    }

    return GestureDetector(
      onTap: () => onTap(index), // استدعاء الدالة الممررة من MainView
      child: _buildIconOrImage(icon, image, isSelected),
    );
  }

  Widget _buildIconOrImage(IconData? icon, String? image, bool isSelected) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.all(8),
      decoration: isSelected
          ? BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(15),
            )
          : null,
      child: icon != null
          ? Icon(
              icon,
              color: isSelected ? Colors.white : Colors.white60,
              size: isSelected ? 28 : 24,
            )
          : Image.asset(
              image!,
              width: isSelected ? 26 : 22,
              height: isSelected ? 26 : 22,
              color: isSelected ? null : Colors.white.withOpacity(0.6),
              colorBlendMode: isSelected ? null : BlendMode.modulate,
            ),
    );
  }
}
