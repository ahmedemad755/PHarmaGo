import 'package:e_commerce/featchers/home/presentation/views/widgets/alarmpage.dart';
import 'package:e_commerce/featchers/home/presentation/views/widgets/cart_view.dart';
import 'package:e_commerce/featchers/home/presentation/views/widgets/chatbootView.dart';
import 'package:e_commerce/featchers/home/presentation/views/widgets/pharmacy_home_screen_new.dart';
import 'package:e_commerce/featchers/home/presentation/views/widgets/product_view.dart';
import 'package:e_commerce/featchers/home/presentation/views/widgets/profileView.dart';
import 'package:flutter/material.dart';

class MainViewBody extends StatelessWidget {
  const MainViewBody({super.key, required this.currentViewIndex});
  final int currentViewIndex;

  @override
  Widget build(BuildContext context) {
    return IndexedStack(
      index: currentViewIndex,
      children: const [
        PharmacyHomeScreenNew(), // 0
        ProductsView(), // 1
        MainAlarmsView(), // 2
        Chatbootview(), // 3
        CartView(), // 4
        Profileview(), // 5
      ],
    );
  }
}
