import 'package:e_commerce/core/utils/app_colors.dart';
import 'package:e_commerce/featchers/alarm/presentation/widgets/alarm_add_button.dart';
import 'package:flutter/material.dart';

class AlarmsEmptyState extends StatelessWidget {
  const AlarmsEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.05),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.notifications_active_outlined,
              size: 80,
              color: AppColors.primary.withOpacity(0.5),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            "لا توجد منبهات حالياً",
            style: TextStyle(
              color: AppColors.darkBlue,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "ابدأ بإضافة أول منبه لجرعاتك",
            style: TextStyle(color: AppColors.mediumGray),
          ),
          const SizedBox(height: 40),
          const AlarmAddButton(),
        ],
      ),
    );
  }
}