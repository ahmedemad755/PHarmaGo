import 'package:e_commerce/core/utils/app_colors.dart';
import 'package:e_commerce/core/utils/gradiant_text.dart';
import 'package:flutter/material.dart';

class AppBarAboutPages extends StatelessWidget {
 String title;
  AppBarAboutPages({
    super.key,
      required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title:  GradientText(
        title,
        gradient: AppColors.accentGradient2,
      ),
      centerTitle: true,
      backgroundColor: AppColors.white,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
    );
  }
}