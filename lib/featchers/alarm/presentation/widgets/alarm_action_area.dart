import 'package:e_commerce/core/utils/app_colors.dart';
import 'package:e_commerce/featchers/alarm/presentation/widgets/alarm_add_button.dart';
import 'package:flutter/material.dart';

class AlarmsActionArea extends StatelessWidget {
  const AlarmsActionArea({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24),
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: const SafeArea(
        child: Center(
          child: AlarmAddButton(),
        ),
      ),
    );
  }
}





