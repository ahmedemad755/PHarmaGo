import 'package:e_commerce/core/di/injection.dart';
import 'package:e_commerce/Features/products/presentation/cubit/products_cubit.dart';
import 'package:e_commerce/Features/home/presentation/view/pharmacy_home_screen_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PharmacyHomeScreen extends StatelessWidget {
  const PharmacyHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // نستخدم النسخة التي تم إنشاؤها في Router أو getIt مباشرة
    return BlocProvider.value(
      value: getIt<ProductsCubit>(),
      child: const PharmacyHomeScreenNew(),
    );
  }
}
