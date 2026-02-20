// import 'package:e_commerce/core/functions_helper/routs.dart';
// import 'package:e_commerce/core/utils/app_colors.dart';
// import 'package:e_commerce/featchers/home/presentation/cubits/cart_cubit/cart_cubit.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// class ThankYouView extends StatefulWidget {
//   const ThankYouView({super.key});

//   @override
//   State<ThankYouView> createState() => _ThankYouViewState();
// }

// class _ThankYouViewState extends State<ThankYouView>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<double> _scaleAnimation;

//   @override
//   void initState() {
//     super.initState();

//     // مسح السلة فوراً (محلياً وفي الفايربيس) عند الدخول لصفحة الشكر
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       if (mounted) {
//         context.read<CartCubit>().clearCart();
//       }
//     });

//     _controller = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 1000),
//     );

//     _scaleAnimation = CurvedAnimation(
//       parent: _controller,
//       curve: Curves.elasticOut,
//     );

//     _controller.forward();
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: PopScope(
//         canPop: false, // منع الرجوع لشاشة الدفع
//         onPopInvokedWithResult: (didPop, result) {
//           if (didPop) return;
//           // عند محاولة الرجوع يتم توجيهه للرئيسية
//           Navigator.of(
//             context,
//           ).pushNamedAndRemoveUntil(AppRoutes.home, (route) => false);
//         },
//         child: Center(
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 24.0),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 ScaleTransition(
//                   scale: _scaleAnimation,
//                   child: ShaderMask(
//                     shaderCallback: (bounds) =>
//                         AppColors.successGradient.createShader(
//                           Rect.fromLTWH(0, 0, bounds.width, bounds.height),
//                         ),
//                     child: const Icon(
//                       Icons.check_circle_rounded,
//                       color: Colors.white,
//                       size: 120,
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 32),
//                 const Text(
//                   'تم استلام طلبك بنجاح!',
//                   style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
//                 ),
//                 const SizedBox(height: 16),
//                 const Text(
//                   'شكراً لثقتك بنا. ستصلك تفاصيل الشحنة قريباً.',
//                   textAlign: TextAlign.center,
//                   style: TextStyle(fontSize: 16, color: Colors.grey),
//                 ),
//                 const SizedBox(height: 48),
//                 _buildHomeButton(context),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildHomeButton(BuildContext context) {
//     return GestureDetector(
//       onTap: () => Navigator.of(
//         context,
//       ).pushNamedAndRemoveUntil(AppRoutes.home, (route) => false),
//       child: Container(
//         width: double.infinity,
//         height: 56,
//         decoration: BoxDecoration(
//           gradient: AppColors.successGradient,
//           borderRadius: BorderRadius.circular(16),
//         ),
//         child: const Center(
//           child: Text(
//             'متابعة التسوق',
//             style: TextStyle(
//               color: Colors.white,
//               fontSize: 18,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:e_commerce/core/di/injection.dart';
import 'package:e_commerce/core/functions_helper/routs.dart';
import 'package:e_commerce/core/utils/app_colors.dart';
import 'package:e_commerce/featchers/home/presentation/cubits/cart_cubit/cart_cubit.dart';
import 'package:flutter/material.dart';

class ThankYouView extends StatefulWidget {
  const ThankYouView({super.key});

  @override
  State<ThankYouView> createState() => _ThankYouViewState();
}

class _ThankYouViewState extends State<ThankYouView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    // تأكيد مسح السلة لضمان عدم تكرار الطلب أو بقاء أصناف قديمة
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        // نستخدم getIt لضمان الوصول لنفس نسخة الكيوبت المعتمدة في التطبيق
        getIt<CartCubit>().clearCart();
      }
    });

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: PopScope(
        canPop: false, // منع الرجوع تماماً لشاشة الدفع بالزر الخلفي للهاتف
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) return;
          // توجيه المستخدم للرئيسية وتصفير المكدس (Stack)
          _navigateToHome();
        },
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ScaleTransition(
                  scale: _scaleAnimation,
                  child: ShaderMask(
                    shaderCallback: (bounds) =>
                        AppColors.successGradient.createShader(
                          Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                        ),
                    child: const Icon(
                      Icons.check_circle_rounded,
                      color: Colors.white,
                      size: 120,
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                const Text(
                  'تم استلام طلبك بنجاح!',
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                const Text(
                  'شكراً لثقتك بنا. ستصلك تفاصيل الشحنة قريباً.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 48),
                _buildHomeButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHomeButton(BuildContext context) {
    return GestureDetector(
      onTap: _navigateToHome,
      child: Container(
        width: double.infinity,
        height: 56,
        decoration: BoxDecoration(
          gradient: AppColors.successGradient,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.green.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Center(
          child: Text(
            'متابعة التسوق',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  void _navigateToHome() {
    Navigator.of(context).pushNamedAndRemoveUntil(
      AppRoutes.home,
      (route) => false,
    );
  }
}