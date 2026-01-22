import 'package:e_commerce/core/functions_helper/routs.dart';
import 'package:e_commerce/core/utils/app_colors.dart';
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

    // إعداد وحدة التحكم - زيادة المدة لـ 1000ms تعطي تأثير Elastic أجمل
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut, // حركة قفزة احترافية
    );

    // التأكد من تشغيل الأنيميشن بعد استقرار رسم الشاشة تماماً
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _controller.forward(from: 0.0);
      }
    });
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
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // --- أنيميشن الأيقونة المتداخلة بالأخضر ---
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
                    size: 120, // تكبير الحجم قليلاً للمسة جمالية
                  ),
                ),
              ),

              const SizedBox(height: 32),

              const Text(
                'تم استلام طلبك بنجاح!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),

              const SizedBox(height: 16),

              const Text(
                'شكراً لثقتك بنا. ستصلك رسالة تفصيلية\nبموعد التوصيل وحالة الشحنة قريباً.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey, height: 1.5),
              ),

              const SizedBox(height: 48),

              // --- زر العودة للرئيسية بالتصميم الأخضر ---
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pushReplacementNamed(AppRoutes.home);
                },
                child: Container(
                  width: double.infinity,
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: AppColors.successGradient,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.success.withOpacity(0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
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
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
