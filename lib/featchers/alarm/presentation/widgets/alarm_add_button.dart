import 'package:e_commerce/core/utils/app_colors.dart';
import 'package:e_commerce/featchers/alarm/cubits/alarm/alarm_cubit.dart';
import 'package:e_commerce/featchers/alarm/presentation/widgets/add_alarm_view.dart';
import 'package:e_commerce/featchers/auth/widgets/custombotton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AlarmAddButton extends StatelessWidget {
  const AlarmAddButton({super.key});

  void _navigateToAddTask(BuildContext context) {
    final cubit = context.read<AlarmsCubit>();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: cubit,
          child: const AddAlarmView(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GradientButton(
      label: "إضافة منبه جديد",
      width: MediaQuery.of(context).size.width * 0.7,
      icon: Icons.add_alarm_rounded,
      gradientColors: AppColors.getAccentGradientByPage(2).colors.toList(),
      onPressed: () => _navigateToAddTask(context),
    );
  }
}