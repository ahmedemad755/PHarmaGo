import 'package:e_commerce/core/functions_helper/build_overlay_bar.dart';
import 'package:e_commerce/featchers/home/presentation/cubits/curt_cubit/cart_cubit.dart';
import 'package:e_commerce/featchers/home/presentation/views/widgets/main_view_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainViewBodyBlocConsumer extends StatelessWidget {
  const MainViewBodyBlocConsumer({super.key, required this.currentViewIndex});
  final int currentViewIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // The error is pointing to this Scaffold as the unmounted reference box.
      body: BlocListener<CartCubit, CartState>(
        listener: (context, state) {
          
          // CRITICAL FIX: Use a post-frame callback to ensure the context
          // is stable and attached before attempting to show the overlay bar.
          WidgetsBinding.instance.addPostFrameCallback((_) {
            // Re-check context.mounted inside the callback for safety
            if (!context.mounted) return;

            if (state is CartItemAdd) {
              showBar(context, 'تمت العملية بنجاح', color: Colors.green);
            }
            if (state is CartItemRemove) {
              showBar(
                context,
                'تم حذف العنصر بنجاح',
                color: const Color.fromARGB(134, 76, 175, 79),
              );
            }
          });
        },
        child: MainViewBody(currentViewIndex: currentViewIndex),
      ),
    );
  }
}