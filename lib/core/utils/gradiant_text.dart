import 'package:e_commerce/core/utils/app_colors.dart';
import 'package:flutter/material.dart';

class GradientText extends StatelessWidget {
  final String text;
  final LinearGradient gradient;
  final double fontSize;

  const GradientText(this.text, {super.key, required this.gradient, this.fontSize = 22});

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => gradient.createShader(
        Rect.fromLTWH(0, 0, bounds.width, bounds.height),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: AppColors.white, // ضروري لظهور التدرج
        ),
      ),
    );
  }
}