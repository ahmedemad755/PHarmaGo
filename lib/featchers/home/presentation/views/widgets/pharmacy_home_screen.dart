import 'package:e_commerce/core/di/injection.dart';
import 'package:e_commerce/core/products_cubit/products_cubit.dart';
import 'package:e_commerce/core/repos/products_repo/products_repo.dart';
import 'package:e_commerce/featchers/home/presentation/views/widgets/pharmacy_home_screen_new.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Lightweight wrapper for compatibility.
// class PharmacyHomeScreen extends StatelessWidget {
//   const PharmacyHomeScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) => ProductsCubit(getIt.get<ProductsRepo>()),
//       child: const PharmacyHomeScreenNew(),
//     );
//   }
//}
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