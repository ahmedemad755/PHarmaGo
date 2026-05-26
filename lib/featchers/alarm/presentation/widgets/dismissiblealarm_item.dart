import 'package:e_commerce/core/functions_helper/build_overlay_bar.dart';
import 'package:e_commerce/core/utils/app_colors.dart';
import 'package:e_commerce/featchers/alarm/cubits/alarm/alarm_cubit.dart';
import 'package:e_commerce/featchers/alarm/presentation/widgets/alarm_card.dart';
import 'package:e_commerce/featchers/alarm/presentation/widgets/alarm_delete_background.dart';
import 'package:e_commerce/featchers/home/domain/enteties/alarm_entites.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DismissibleAlarmItem extends StatelessWidget {
  final AlarmEntity alarm;
  const DismissibleAlarmItem({super.key, required this.alarm});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(alarm.id),
      direction: DismissDirection.horizontal,
      background: const AlarmDeleteBackground(alignment: Alignment.centerRight),
      secondaryBackground: const AlarmDeleteBackground(alignment: Alignment.centerLeft),
      confirmDismiss: (direction) async => await _showDeleteConfirmation(context),
      onDismissed: (direction) {
        context.read<AlarmsCubit>().removeAlarm(alarm);
        showBar(context, "تم حذف المنبه وإلغاء تذكيراته");
      },
      child: AlarmCard(alarm: alarm),
    );
  }

  Future<bool?> _showDeleteConfirmation(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: AppColors.white,
        title: const Text(
          "حذف المنبه",
          textAlign: TextAlign.right,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: const Text(
          "هل أنت متأكد من رغبتك في حذف هذا المنبه؟",
          textAlign: TextAlign.right,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text(
              "إلغاء",
              style: TextStyle(color: AppColors.darkGray),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.errorColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text("حذف", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}