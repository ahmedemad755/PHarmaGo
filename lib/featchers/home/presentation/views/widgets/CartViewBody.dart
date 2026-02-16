import 'package:e_commerce/constants.dart';
import 'package:e_commerce/core/utils/app_colors.dart';
import 'package:e_commerce/core/widgets/castom_cart_buttom.dart';
import 'package:e_commerce/featchers/AUTH/widgets/build_app_bar.dart';
import 'package:e_commerce/featchers/home/presentation/cubits/cart_cubit/cart_cubit.dart';
import 'package:e_commerce/featchers/home/presentation/views/widgets/CartHeader.dart';
import 'package:e_commerce/featchers/home/presentation/views/widgets/cart_items_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartViewBody extends StatelessWidget {
  const CartViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartCubit, CartState>(
      builder: (context, state) {
        // استخراج البيانات بناءً على الحالة الحالية
        final currentCart = switch (state) {
          CartInitial(cartEntity: final cart) => cart,
          CartUpdated(cartEntity: final cart) => cart,
          CartItemAdded(cartEntity: final cart) => cart,
          CartItemRemoved(cartEntity: final cart) => cart,
        };

        final cartItems = currentCart.cartItems;
        final bool isEmpty = cartItems.isEmpty;

        return Scaffold(
          backgroundColor: AppColors.lightGray, // توحيد خلفية الصفحة
          body: Stack(
            children: [
              CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        const SizedBox(height: kTopPaddding),
                        buildAppBar(
                          context,
                          title: 'سلة المشتريات',
                          showBackButton: false,
                        ),
                        const SizedBox(height: 16),
                        const CartHeader(),
                        const SizedBox(height: 12),
                      ],
                    ),
                  ),

                  // عرض الفاصل فقط إذا كانت السلة تحتوي على منتجات
                  if (!isEmpty)
                    const SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: CustomDivider(),
                      ),
                    ),

                  // قائمة المنتجات
                  CartItemsList(carItems: cartItems),

                  if (!isEmpty)
                    const SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: CustomDivider(),
                      ),
                    ),

                  // مساحة إضافية في الأسفل حتى لا يغطي زر الدفع آخر عنصر
                  if (!isEmpty)
                    const SliverToBoxAdapter(child: SizedBox(height: 150)),
                ],
              ),

              // حالة السلة الفارغة
              if (isEmpty) _buildEmptyState(),
              // زر إتمام الشراء (Checkout)
              if (!isEmpty)
                Positioned(
                  left: 20,
                  right: 20,
                  bottom: 125, 
                  child: CustomCartButton(),
                ),
            ],
          ),
        );
      },
    );
  }

  // ميثود منفصلة لحالة السلة الفارغة لتحسين نظافة الكود
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.05),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.shopping_basket_outlined,
              size: 100,
              color: AppColors.primary.withOpacity(0.3),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'سلتك فارغة حالياً',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.darkBlue,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'أضف بعض المنتجات الرائعة لتبدأ التسوق! 🛒',
            style: TextStyle(fontSize: 14, color: AppColors.mediumGray),
          ),
        ],
      ),
    );
  }
}