
import 'package:e_commerce/Features/alarm/domain/entities/alarm_entity.dart';
import 'package:e_commerce/Features/alarm/presentation/cubits/alarm/alarm_cubit.dart';
import 'package:e_commerce/Features/alarm/presentation/cubits/alarm/alarm_state.dart';
import 'package:e_commerce/Features/alarm/presentation/widgets/alarm_action_area.dart';
import 'package:e_commerce/Features/alarm/presentation/widgets/alarm_empty_state.dart';
import 'package:e_commerce/Features/alarm/presentation/widgets/dismissiblealarm_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AlarmsBodyBuilder extends StatelessWidget {
  const AlarmsBodyBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AlarmsCubit, AlarmsState>(
      builder: (context, state) {
        final alarms = (state is AlarmsSuccess) ? state.alarms : <AlarmEntity>[];

        if (alarms.isEmpty) return const AlarmsEmptyState();

        return Column(
          children: [
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
                itemCount: alarms.length,
                separatorBuilder: (context, index) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final alarm = alarms[index];
                  return DismissibleAlarmItem(alarm: alarm);
                },
              ),
            ),
            const AlarmsActionArea(),
          ],
        );
      },
    );
  }
}