import 'package:e_commerce/core/utils/app_colors.dart';
import 'package:flutter/material.dart';

class AlarmDeleteBackground extends StatelessWidget {
  final Alignment alignment;
  const AlarmDeleteBackground({super.key, required this.alignment});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      alignment: alignment,
      decoration: BoxDecoration(
        color: AppColors.errorColor.withOpacity(0.9),
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Icon(
        Icons.delete_sweep_rounded,
        color: Colors.white,
        size: 28,
      ),
    );
  }
}