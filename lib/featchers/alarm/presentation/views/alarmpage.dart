import 'package:e_commerce/core/utils/app_colors.dart';
import 'package:e_commerce/core/utils/gradiant_text.dart';
import 'package:e_commerce/featchers/alarm/presentation/widgets/alarm_body_builder.dart';
import 'package:flutter/material.dart';
class MainAlarmsView extends StatelessWidget {
  const MainAlarmsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGray,
      appBar: AppBar(
        title: const GradientText(
          "منبه الدواء",
          gradient: AppColors.accentGradient2,
        ),
        centerTitle: true,
        backgroundColor: AppColors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      body: const AlarmsBodyBuilder(),
    );
  }
}