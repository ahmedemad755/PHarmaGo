import 'package:flutter/material.dart';

class GlassCard extends StatelessWidget {
  final double width;
  final double height;
  final Widget child;
  final Color? glassColor;
  final double borderRadius;
  final double opacity;
  final List<Color>? gradientColors;

  const GlassCard({
    super.key,
    this.width = 120,
    this.height = 150,
    required this.child,
    this.glassColor,
    this.borderRadius = 24,
    this.opacity = 0.2,
    this.gradientColors,
  });

@override
Widget build(BuildContext context) {
  return Container(
    width: width,
    height: height,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(borderRadius),
      // بديل الـ Blur: لون أبيض شفاف جداً مع لون خلفية الصفحة
      color: Colors.white.withOpacity(0.7), 
      border: Border.all(
        color: Colors.white.withOpacity(0.4), // حدود بيضاء تعطي إيحاء الزجاج
        width: 1.5,
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 10,
          spreadRadius: 2,
        ),
      ],
    ),
    child: child,
  );
}
}
