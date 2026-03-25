import 'package:e_commerce/core/utils/app_colors.dart';
import 'package:e_commerce/core/widgets/castom_cart_buttom.dart';
import 'package:e_commerce/featchers/auth/widgets/app_bar_about_pages.dart';
import 'package:e_commerce/featchers/home/presentation/cubits/cart_cubit/cart_cubit.dart';
import 'package:e_commerce/featchers/home/presentation/views/widgets/CartHeader.dart';
import 'package:e_commerce/featchers/home/presentation/views/widgets/cart_items_list.dart';
import 'package:e_commerce/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartViewBody extends StatelessWidget {
  const CartViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartCubit, CartState>(
      builder: (context, state) {
        // الحفاظ على اللوجيك الحالي لاستخراج البيانات
        final currentCart = switch (state) {
          CartInitial(cartEntity: final cart) => cart,
          CartUpdated(cartEntity: final cart) => cart,
          CartItemAdded(cartEntity: final cart) => cart,
          CartItemRemoved(cartEntity: final cart) => cart,
        };

        final cartItems = currentCart.cartItems;
        final bool isEmpty = cartItems.isEmpty;

        return Scaffold(
          backgroundColor: AppColors.lightGray,
          // استخدام الـ AppBar المخصص في مكانه الطبيعي
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(kToolbarHeight + 20),
            child: AppBarAboutPages(title: "سلة التسوق"),
          ),
          
          // عرض زر الدفع في الأسفل فقط إذا كانت السلة غير فارغة
          bottomNavigationBar: isEmpty 
              ? null 
              : SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    child: CustomCartButton(),
                  ),
                ),

          body: isEmpty 
              ? _buildEmptyState() 
              : _buildCartContent(cartItems),
        );
      },
    );
  }

  // بناء محتوى السلة (التمرير)
  Widget _buildCartContent(dynamic cartItems) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        const SliverToBoxAdapter(child: SizedBox(height: 16)),
        
        // الهيدر (عدد المنتجات مثلاً)
        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: CartHeader(),
          ),
        ),
        
        const SliverToBoxAdapter(child: SizedBox(height: 12)),
        
        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: CustomDivider(),
          ),
        ),

        // قائمة المنتجات (Sliver)
        CartItemsList(carItems: cartItems),

        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: CustomDivider(),
          ),
        ),

        // مساحة أمان إضافية للتمرير
        const SliverToBoxAdapter(child: SizedBox(height: 32)),
      ],
    );
  }

  // حالة السلة الفارغة المحدثة
  Widget _buildEmptyState() {
    return FadeInUp( // إذا كان لديك مكتبة animate_do أو استبدلها بـ AnimatedOpacity
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildEmptyIcon(),
              const SizedBox(height: 32),
              const Text(
                'سلتك فارغة حالياً',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkBlue,
                ),
              ),
              const SizedBox(height: 12),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: Text(
                  'يبدو أنك لم تضف أي منتجات بعد. استكشف أفضل العروض وابدأ بالتسوق الآن!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    color: AppColors.mediumGray,
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyIcon() {
    return Container(
      width: 180,
      height: 180,
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.05),
        shape: BoxShape.circle,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: 80,
            color: AppColors.primary.withOpacity(0.2),
          ),
          Positioned(
            right: 45,
            top: 45,
            child: Icon(Icons.close, color: AppColors.primary.withOpacity(0.4), size: 30),
          )
        ],
      ),
    );
  }
}

// ويدجيت مساعدة لتحريك العناصر (اختياري)
class FadeInUp extends StatelessWidget {
  final Widget child;
  const FadeInUp({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 800),
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - value)),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}