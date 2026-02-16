import 'package:e_commerce/core/functions_helper/routs.dart';
import 'package:e_commerce/core/utils/app_colors.dart';
import 'package:e_commerce/featchers/onboarding/widgets/custom_button.dart';
import 'package:flutter/material.dart';

class Chatbootview extends StatelessWidget {
  const Chatbootview({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.white, 
      appBar: AppBar(
        title: const Text(
          "محادثة صحية",
          style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.darkBlue),
        ),
        centerTitle: true,
        backgroundColor: AppColors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),
                // --- 💡 Visual Element ---
                ShaderMask(
                  shaderCallback: (Rect bounds) {
                    return AppColors.primaryGradient.createShader(bounds);
                  },
                  blendMode: BlendMode.srcIn,
                  child: Icon(
                    Icons.medical_services_rounded,
                    size: screenHeight * 0.12, 
                    color: AppColors.white,
                  ),
                ),
                SizedBox(height: screenHeight * 0.04),

                // --- 📘 Title Text ---
                const Text(
                  'صحتك… بذكاء',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkBlue,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'استشارات طبية سريعة بدعم الذكاء الاصطناعي',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.mediumGray,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 32),

                // --- ⚠️ Warning Section ---
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.errorColor.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.errorColor.withOpacity(0.1)),
                  ),
                  child: Column(
                    children: [
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.warning_amber_rounded, color: AppColors.errorColor, size: 20),
                          SizedBox(width: 8),
                          Text(
                            'تنبيه هام',
                            style: TextStyle(
                              color: AppColors.errorColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'هذا المساعد لا يُغني أبدًا عن استشارة الطبيب. مهمتك هنا الحصول على نصائح عامة، وتوضيحات بسيطة، ومقترحات للبدائل المحتملة للأدوية، وليس توصيات علاجية نهائية. في الحالات الطارئة يرجى التوجه لأقرب مستشفى.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.errorColor.withOpacity(0.8),
                          fontSize: 13,
                          height: 1.6,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: screenHeight * 0.06),

                // --- 🔘 Action Button ---
                SizedBox(
                  height: 56,
                  child: GradientButton(
                    onPressed: () {
                      Navigator.pushNamed(context, AppRoutes.ChatbootBody);
                    },
                    label: 'ابدأ الاستشارة الطبية الآن',
                  ),
                ),

                SizedBox(height: screenHeight * 0.1),
              ],
            ),
          ),
        ),
      ),
    );
  }
}