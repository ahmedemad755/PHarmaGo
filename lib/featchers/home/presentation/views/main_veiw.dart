import 'package:e_commerce/core/di/injection.dart';
import 'package:e_commerce/core/products_cubit/products_cubit.dart';
import 'package:e_commerce/featchers/AUTH/data/repos/auth_repo_impl.dart';
import 'package:e_commerce/featchers/home/presentation/cubits/curt_cubit/cart_cubit.dart';
import 'package:e_commerce/featchers/home/presentation/views/CustomBottomNavigationBar.dart';
import 'package:e_commerce/featchers/home/presentation/views/widgets/main_view_body_bloc_consumer.dart';
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
  void initState() {
    super.initState();
    // تحميل السلة من الـ Repository عند بدء التطبيق
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CartCubit>().loadCartFromRepository();
    });
  }

  @override
  Widget build(BuildContext context) {
    // استخدمنا MultiBlocProvider مباشرة وقمنا بجلب النسخ من getIt هنا
    // هذا يضمن توفرها قبل بناء أي Widget تحتها
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: getIt<CartCubit>()),
        BlocProvider<ProductsCubit>(
          create: (context) => getIt<ProductsCubit>(),
        ),
      ],
      child: Scaffold(
        extendBody: true, // مهم جداً لجعل الصفحات تظهر خلف الناف بار الزجاجي
        bottomNavigationBar: BottomNavPage(
          currentIndex: currentViewIndex,
          onTap: (index) {
            setState(() {
              currentViewIndex = index;
            });
          },
        ),
        body: MainViewBodyBlocConsumer(currentViewIndex: currentViewIndex),
      ),
    );
  }
}
