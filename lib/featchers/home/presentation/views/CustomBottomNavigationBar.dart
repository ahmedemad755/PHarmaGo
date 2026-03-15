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
    // RepaintBoundary يعزل الـ Nav Bar برمجياً لتحسين أداء السكرول في الخلفية
    return RepaintBoundary(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
        child: Container(
          height: 70,
          decoration: BoxDecoration(
            // لون داكن ثابت بدلاً من الـ Blur لتوفير موارد المعالج الرسومي
            color: const Color.fromARGB(29, 0, 40, 124).withOpacity(0.92),
            borderRadius: BorderRadius.circular(25),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
            // boxShadow: [
            //   BoxShadow(
            //     color: const Color.fromARGB(29, 3, 3, 48).withOpacity(0.3),
            //     blurRadius: 15,
            //     offset: const Offset(0, 5),
            //   ),
            // ],
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
    );
  }

  Widget _navItem(
    BuildContext context, {
    IconData? icon,
    String? image,
    required int index,
  }) {
    final bool isSelected = currentIndex == index;

    // جزء أيقونة السلة مع معالجة الـ States بأمان
    if (index == 4) {
      return BlocBuilder<CartCubit, CartState>(
        buildWhen: (previous, current) {
          // استخراج الكيان من الحالة السابقة والحالية للمقارنة
          final prevItems = _getCartEntity(previous).cartItems.length;
          final currItems = _getCartEntity(current).cartItems.length;
          return prevItems != currItems || isSelected; 
        },
        builder: (context, state) {
          final currentCart = _getCartEntity(state);
          final itemsCount = currentCart.cartItems.length;

          return GestureDetector(
            onTap: () => onTap(index),
            behavior: HitTestBehavior.opaque,
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
                        minWidth: 18,
                        minHeight: 18,
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
                            fontSize: 9,
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
      onTap: () => onTap(index),
      behavior: HitTestBehavior.opaque,
      child: _buildIconOrImage(icon, image, isSelected),
    );
  }

  // دالة مساعدة لاستخراج الـ CartEntity من أي State بأمان
  dynamic _getCartEntity(CartState state) {
    return switch (state) {
      CartInitial(cartEntity: final cart) => cart,
      CartUpdated(cartEntity: final cart) => cart,
      CartItemAdded(cartEntity: final cart) => cart,
      CartItemRemoved(cartEntity: final cart) => cart,
    };
  }

  Widget _buildIconOrImage(IconData? icon, String? image, bool isSelected) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      padding: const EdgeInsets.all(10),
      decoration: isSelected
          ? BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(15),
            )
          : const BoxDecoration(),
      child: icon != null
          ? Icon(
              icon,
              color: isSelected ? Colors.white : Colors.white54,
              size: isSelected ? 26 : 24,
            )
          : Image.asset(
              image!,
              width: isSelected ? 24 : 22,
              height: isSelected ? 24 : 22,
              color: isSelected ? null : Colors.white.withOpacity(0.5),
              colorBlendMode: isSelected ? null : BlendMode.modulate,
            ),
    );
  }
}