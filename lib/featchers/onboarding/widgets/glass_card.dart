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
    Key? key,
    this.width = 120,
    this.height = 150,
    required this.child,
    this.glassColor,
    this.borderRadius = 24,
    this.opacity = 0.2,
    this.gradientColors,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        gradient: gradientColors != null
            ? LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  gradientColors![0].withOpacity(opacity),
                  gradientColors![1].withOpacity(opacity * 0.5),
                ],
              )
            : LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withOpacity(opacity),
                  Colors.white.withOpacity(opacity * 0.5),
                ],
              ),
        border: Border.all(
          color: Colors.white.withOpacity(0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.white.withOpacity(0.1),
            blurRadius: 12,
            spreadRadius: 1,
          ),
        ],
      ),
      child: BackdropFilter(
        filter: const ColorFilter.mode(
          Colors.transparent,
          BlendMode.lighten,
        ),
        child: child,
      ),
    );
  }
}
