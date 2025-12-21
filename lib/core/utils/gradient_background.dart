import 'package:e_commerce/core/utils/app_colors.dart';
import 'package:flutter/material.dart';

class GradientBackground extends StatelessWidget {
  const GradientBackground({super.key, required this.child});

  // الـ child هو المحتوى الذي تريد عرضه فوق الخلفية (مثل MaterialApp أو Scaffold)
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      // تطبيق التدرج اللوني على الـ Container
      decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
      // عرض المحتوى فوق الخلفية
      child: child,
    );
  }
}
