import 'package:e_commerce/core/di/injection.dart';
import 'package:e_commerce/core/products_cubit/products_cubit.dart';
import 'package:e_commerce/core/utils/app_colors.dart';
import 'package:e_commerce/featchers/AUTH/data/repos/auth_repo_impl.dart';
import 'package:e_commerce/featchers/home/presentation/cubits/cart_cubit/cart_cubit.dart';
import 'package:e_commerce/featchers/home/presentation/cubits/myOrders/my_orders_cubit.dart'; // تأكد من استيراد الكيوبت
import 'package:e_commerce/featchers/home/presentation/views/CustomBottomNavigationBar.dart';
import 'package:e_commerce/featchers/home/presentation/views/widgets/main_view_body_bloc_consumer.dart';
import 'package:firebase_auth/firebase_auth.dart'; // لإحضار الـ uID
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainVeiw extends StatefulWidget {
  const MainVeiw({super.key, required AuthRepoImpl authRepoImpl});

  @override
  State<MainVeiw> createState() => _MainVeiwState();
}

class _MainVeiwState extends State<MainVeiw> {
  int currentViewIndex = 0;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: getIt<CartCubit>()),
        BlocProvider<ProductsCubit>(
          create: (context) => getIt<ProductsCubit>(),
        ),
        // 💡 إضافة OrdersCubit هنا ليعمل عداد الإشعارات في الهوم فوراً
        BlocProvider<OrdersCubit>(
          create: (context) => getIt<OrdersCubit>()..fetchUserOrders(
            uID: FirebaseAuth.instance.currentUser?.uid ?? "",
          ),
        ),
      ],
      child: Scaffold(
        backgroundColor: const Color(0xFFFBFBFB),
        extendBody: true,
        bottomNavigationBar: SafeArea(
          child: BottomNavPage(
            currentIndex: currentViewIndex,
            onTap: (index) {
              setState(() {
                currentViewIndex = index;
              });
            },
          ),
        ),
        body: MainViewBodyBlocConsumer(currentViewIndex: currentViewIndex),
      ),
    );
  }
}