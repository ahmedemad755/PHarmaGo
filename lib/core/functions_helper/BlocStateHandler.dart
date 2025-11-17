import 'package:e_commerce/core/functions_helper/build_overlay_bar.dart';
import 'package:e_commerce/featchers/AUTH/widgets/customProgressLoading.dart';
import 'package:e_commerce/featchers/checkout/presentation/manger/add_order_cubit/add_order_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BlocStateHandler extends StatelessWidget {
  const BlocStateHandler({super.key, required this.child});

  final Widget child;
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddOrderCubit, AddOrderState>(
      listener: (context, state) {
        if (state is AddOrderSuccess) {
          showBar(context, 'تمت العملية بنجاح', color: Colors.green);
        }

        if (state is AddOrderFailure) {
          showBar(context, state.message);
        }
      },
      builder: (context, state) {
        return CustomProgresIndecatorHUD(
          isLoading: state is AddOrderLoading,
          child: child,
        );
      },
    );
  }
}
