import 'package:e_commerce/featchers/checkout/widgets/ordersummry_widget.dart';
import 'package:e_commerce/featchers/checkout/widgets/shippingaddress_widgets.dart';
import 'package:e_commerce/featchers/home/presentation/cubits/cart_cubit/cart_cubit.dart';
import 'package:e_commerce/featchers/home/presentation/views/widgets/priseperation_pick_order.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PaymentSection extends StatelessWidget {
  const PaymentSection({super.key, required this.pageController});

  final PageController pageController;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 24),
          
          // 🔹 إضافة خانة رفع الروشتة هنا فقط إذا كانت مطلوبة
          BlocBuilder<CartCubit, CartState>(
            builder: (context, state) {
              if (context.read<CartCubit>().isPrescriptionRequired) {
                return const Padding(
                  padding: EdgeInsets.only(bottom: 16),
                  child: PrescriptionPicker(),
                );
              }
              return const SizedBox.shrink();
            },
          ),

          const OrderSummryWidget(),
          const SizedBox(height: 16),
          ShippingAddressWidget(pageController: pageController),
        ],
      ),
    );
  }
}