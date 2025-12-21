import 'package:e_commerce/featchers/home/presentation/views/widgets/cart_view.dart';
import 'package:e_commerce/featchers/home/presentation/views/widgets/pharmacy_home_screen.dart';
import 'package:e_commerce/featchers/home/presentation/views/widgets/product_view.dart';
import 'package:flutter/material.dart';

class MainViewBody extends StatelessWidget {
  const MainViewBody({super.key, required this.currentViewIndex});

  final int currentViewIndex;

  @override
  Widget build(BuildContext context) {
    return IndexedStack(
      index: currentViewIndex,
      children: const [PharmacyHomeScreen(), ProductsView(), CartView(), CartView()],
    );
  }
}
