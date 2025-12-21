import 'package:e_commerce/constants.dart';
import 'package:e_commerce/core/widgets/castom_cart_buttom.dart';
import 'package:e_commerce/featchers/auth/widgets/build_app_bar.dart';
import 'package:e_commerce/featchers/home/presentation/cubits/curt_cubit/cart_cubit.dart';
import 'package:e_commerce/featchers/home/presentation/views/widgets/CartHeader.dart';
import 'package:e_commerce/featchers/home/presentation/views/widgets/cart_items_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartViewBody extends StatelessWidget {
  const CartViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    // 💡 الحل: نستخدم BlocBuilder للاستماع لتغييرات حالة CartCubit
    return BlocBuilder<CartCubit, dynamic>(
      builder: (context, state) {
        final cartItems = context.read<CartCubit>().cartEntity.cartItems;
        final bool isEmpty = cartItems.isEmpty;

        return Stack(
          children: [
            CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      const SizedBox(height: kTopPaddding),
                      buildAppBar(context, title: 'السلة', showBackButton: false),
                      const SizedBox(height: 16),
                      // يمكن أن تستمع CartHeader هي الأخرى إذا كانت تعرض أرقامًا
                      const CartHeader(), 
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
                
                // 🛑 استخدام المتغير isEmpty لتحديد ما إذا كان سيتم عرض الفاصل
                SliverToBoxAdapter(
                  child: isEmpty
                      ? const SizedBox()
                      : const CustomDivider(),
                ),
                
                // 🛑 استخدام CartItemsList لعرض القائمة
                CartItemsList(
                  // نمرر القائمة المحدثة
                  carItems: cartItems, 
                ),
                
                SliverToBoxAdapter(
                  child: isEmpty
                      ? const SizedBox()
                      : const CustomDivider(),
                ),

                // إذا كانت القائمة غير فارغة، نضيف مساحة أسفل لزر Checkout
                if (!isEmpty)
                   const SliverToBoxAdapter(child: SizedBox(height: 100)),
              ],
            ),

            // زر Checkout يظهر فقط إذا كانت السلة غير فارغة
            if (!isEmpty)
              Positioned(
                left: 16,
                right: 16,
                bottom: MediaQuery.of(context).size.height * 0.12,
                child: CustomCartButton(),
              ),
            
            // إذا كانت السلة فارغة، يمكنك عرض رسالة
            if (isEmpty)
              const Center(
                child: Text(
                  'سلتك فارغة! أضف بعض المنتجات الرائعة. 🛒',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),
          ],
        );
      },
    );
  }
}