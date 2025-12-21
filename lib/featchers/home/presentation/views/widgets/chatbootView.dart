import 'package:e_commerce/core/functions_helper/routs.dart';
import 'package:e_commerce/core/utils/app_colors.dart';
import 'package:e_commerce/featchers/onboarding/widgets/custom_button.dart';
import 'package:flutter/material.dart';

class Chatbootview extends StatelessWidget {
  const Chatbootview({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. Get screen dimensions for responsive padding
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white, // Ensure a clean background
      appBar: AppBar(
        title: const Text( "محادثة صحية" ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            // Centers the content vertically within the Center widget
            mainAxisAlignment: MainAxisAlignment.center,
            // Centers the content horizontally
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // --- 💡 Icon/Visual Element with Gradient (بدون Container) ---
              // تم إزالة Container الخلفية واستبقاء ShaderMask لتطبيق التدرج
              ShaderMask(
                // تطبيق التدرج اللوني (primaryGradient) على الأيقونة
                shaderCallback: (Rect bounds) {
                  return AppColors.primaryGradient.createShader(bounds);
                },
                // هذا النمط يضمن أن التدرج يظهر فقط حيث توجد الأيقونة
                blendMode: BlendMode.srcIn,
                child: Icon(
                  Icons.medical_services_outlined,
                  size: screenHeight * 0.1, // Responsive size
                  // يجب أن يكون لون الأيقونة أبيض أو شفاف حتى يعمل الـ ShaderMask
                  color: AppColors.white,
                ),
              ),
              SizedBox(height: screenHeight * 0.03),

              // --- 📘 Title Text ---
              Text(
                'صحتك… بذكاء',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'استشارات طبية سريعة',
                textAlign: TextAlign.center,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium!.copyWith(color: Colors.grey[600]),
              ),


                            const SizedBox(height: 12),

              // ⚠️ النصيحة الطبية المهمة
              Text(
                'تنبيه هام: هذا المساعد لا يُغني أبدًا عن استشارة الطبيب. '
                'مهمتك هنا الحصول على نصائح عامة، وتوضيحات بسيطة، ومقترحات للبدائل المحتملة للأدوية—not توصيات علاجية نهائية. '
                'لو عندك أي مشكلة صحية خطيرة، لازم ترجع لطبيب مختص.',
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(color: Colors.red[700], height: 1.4),
              ),

              SizedBox(height: screenHeight * 0.05),

              // --- 🔘 Action Button (Using GradientButton as requested in context) ---
              SizedBox(
                height: 56, // Fixed height for a comfortable touch target
                child: GradientButton(
                  onPressed: () {
                    Navigator.pushNamed(context, AppRoutes.ChatbootBody);
                  },
                  label: 'ابدأ الاستشارة الطبية',
                ),
              ),

              SizedBox(height: screenHeight * 0.15), // Push content slightly up
            ],
          ),
        ),
      ),
    );
  }
}
