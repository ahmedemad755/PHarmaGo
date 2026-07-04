import 'package:e_commerce/core/utils/app_colors.dart';
import 'package:e_commerce/core/utils/app_text_styles.dart';
import 'package:flutter/material.dart';

class ActivStepIcon extends StatelessWidget {
  const ActivStepIcon({super.key, required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 11.5,
          backgroundColor: AppColors.primaryColor,
          child: Icon(size: 18, Icons.check, color: Colors.white),
        ),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyles.bold13.copyWith(color: AppColors.primaryColor),
        ),
      ],
    );
  }
}
