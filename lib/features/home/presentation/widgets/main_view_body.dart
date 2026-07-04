import 'package:e_commerce/Features/alarm/presentation/views/alarmpage.dart';
import 'package:e_commerce/Features/cart/presentation/view/cart_view.dart';
import 'package:e_commerce/Features/chatbot/presentation/views/chatbootView.dart';
import 'package:e_commerce/Features/home/presentation/view/pharmacy_home_screen_body.dart';
import 'package:e_commerce/Features/products/presentation/view/product_view.dart';
import 'package:e_commerce/Features/profile/presentation/view/profileView.dart';
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
