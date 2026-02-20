import 'package:e_commerce/core/di/injection.dart';
import 'package:e_commerce/core/functions_helper/build_overlay_bar.dart';
import 'package:e_commerce/core/utils/app_colors.dart';
import 'package:e_commerce/featchers/home/presentation/cubits/cart_cubit/cart_cubit.dart';
import 'package:e_commerce/featchers/home/presentation/views/widgets/main_view_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainViewBodyBlocConsumer extends StatelessWidget {
  const MainViewBodyBlocConsumer({super.key, required this.currentViewIndex});
  final int currentViewIndex;

  @override
  Widget build(BuildContext context) {

    // إزالة الـ Scaffold الزائد هنا يجعل الصفحات الفرعية "تطفو" فوق خلفية الـ MainVeiw
    return BlocListener<CartCubit, CartState>(
      bloc: getIt<CartCubit>(),
      listener: (context, state) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!context.mounted) return;
          if (state is CartItemAdded) {
            showBar(context, 'تمت العملية بنجاح', color: AppColors.success);
          }
          if (state is CartItemRemoved) {
            showBar(context, 'تم حذف العنصر بنجاح', color: AppColors.success.withOpacity(0.7));
          }
        });
      },
      child: MainViewBody(currentViewIndex: currentViewIndex),
    );
  }
}