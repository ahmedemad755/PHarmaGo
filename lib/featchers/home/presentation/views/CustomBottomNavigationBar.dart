import 'dart:ui';
import 'package:e_commerce/core/di/injection.dart';
import 'package:e_commerce/core/products_cubit/products_cubit.dart';
import 'package:e_commerce/featchers/home/presentation/cubits/curt_cubit/cart_cubit.dart';
import 'package:e_commerce/featchers/home/presentation/views/widgets/cart_view.dart';
import 'package:e_commerce/featchers/home/presentation/views/widgets/chatbootView.dart';
import 'package:e_commerce/featchers/home/presentation/views/widgets/pharmacy_home_screen_new.dart';
import 'package:e_commerce/featchers/home/presentation/views/widgets/preprisepationPage.dart';
import 'package:e_commerce/featchers/home/presentation/views/widgets/product_view.dart';
import 'package:e_commerce/featchers/home/presentation/views/widgets/profileView.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BottomNavPage extends StatefulWidget {
  const BottomNavPage({super.key});

  @override
  State<BottomNavPage> createState() => _BottomNavPageState();
}

class _BottomNavPageState extends State<BottomNavPage>
    with TickerProviderStateMixin {
  int _currentIndex = 0;

  late final List<Widget> _screens = [
    const PharmacyHomeScreenNew(), 
    const ProductsView(), 
    const PreparationPage(),
    const Chatbootview(), 
    const CartView(), 
    const Profileview(), 
  ];

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => getIt<ProductsCubit>()),
        // ملاحظة: تأكد أن CartCubit يتم توفيره هنا أو في main.dart
      ],
      child: Scaffold(
        extendBody: true,
        body: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: _screens[_currentIndex],
          key: ValueKey<int>(_currentIndex),
        ),
        bottomNavigationBar: Padding(
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
                    _navItem(icon: Icons.home, index: 0),
                    _navItem(icon: Icons.grid_view, index: 1),
                    _navItem(image: 'assets/medical-prescription.png', index: 2),
                    _navItem(image: "assets/chatbot_icon.png", index: 3),
                    _navItem(image: "assets/shopping-basket.png", index: 4), // السلة
                    _navItem(icon: Icons.person, index: 5),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _navItem({IconData? icon, String? image, required int index}) {
    final bool isSelected = _currentIndex == index;

    // إصلاح مشكلة عدم التحديث الفوري للسلة
    if (index == 4) {
      return BlocBuilder<CartCubit, CartState>(
        // سنخبر الـ BlocBuilder أن يعيد بناء نفسه عند حدوث أي حالة تخص السلة
        buildWhen: (previous, current) => 
            current is CartItemAdd || current is CartItemRemove || current is CartInitial,
        builder: (context, state) {
          // جلب العدد مباشرة من الـ cartEntity داخل الـ Cubit
          final itemsCount = context.read<CartCubit>().cartEntity.cartItems.length;

          return GestureDetector(
            onTap: () => setState(() => _currentIndex = index),
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
                      constraints: const BoxConstraints(minWidth: 20, minHeight: 20),
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
                            height: 1 // لضمان توسط الرقم تماماً
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
      onTap: () => setState(() => _currentIndex = index),
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
              borderRadius: BorderRadius.circular(15)
            )
          : null,
      child: icon != null
          ? Icon(icon, color: isSelected ? Colors.white : Colors.white60, size: isSelected ? 28 : 24)
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