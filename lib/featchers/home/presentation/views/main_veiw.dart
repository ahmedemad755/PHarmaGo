import 'package:e_commerce/core/di/injection.dart';
import 'package:e_commerce/featchers/AUTH/data/repos/auth_repo_impl.dart';
import 'package:e_commerce/featchers/home/domain/enteties/cart_entety.dart';
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
  Widget build(BuildContext context) {
    return BlocProvider(
      // بدلاً من تمرير الباراميترز يدوياً، اطلب النسخة الجاهزة من getIt
      create: (context) => getIt<CartCubit>(), 
      child: Scaffold(
        bottomNavigationBar: BottomNavPage(),
        body: SafeArea(
          child: MainViewBodyBlocConsumer(currentViewIndex: currentViewIndex),
        ),
      ),
    );
  }
}
