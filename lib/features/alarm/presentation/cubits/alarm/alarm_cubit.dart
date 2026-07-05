import 'package:e_commerce/Features/alarm/domain/entities/alarm_entity.dart';
import 'package:e_commerce/Features/alarm/domain/usecases/add_alarm_usecase.dart';
import 'package:e_commerce/Features/alarm/domain/usecases/get_alarms_usecase.dart';
import 'package:e_commerce/Features/alarm/domain/usecases/mark_alarm_as_done_usecase.dart';
import 'package:e_commerce/Features/alarm/domain/usecases/remove_alarm_usecase.dart';
import 'package:e_commerce/Features/alarm/presentation/cubits/alarm/alarm_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AlarmsCubit extends Cubit<AlarmsState> {
  AlarmsCubit({
    required GetAlarmsUseCase getAlarmsUseCase,
    required AddAlarmUseCase addAlarmUseCase,
    required RemoveAlarmUseCase removeAlarmUseCase,
    required MarkAlarmAsDoneUseCase markAlarmAsDoneUseCase,
  }) : _getAlarmsUseCase = getAlarmsUseCase,
       _addAlarmUseCase = addAlarmUseCase,
       _removeAlarmUseCase = removeAlarmUseCase,
       _markAlarmAsDoneUseCase = markAlarmAsDoneUseCase,
       super(AlarmsInitial()) {
    loadAlarms();
  }

  final GetAlarmsUseCase _getAlarmsUseCase;
  final AddAlarmUseCase _addAlarmUseCase;
  final RemoveAlarmUseCase _removeAlarmUseCase;
  final MarkAlarmAsDoneUseCase _markAlarmAsDoneUseCase;

  Future<void> loadAlarms() async {
    final result = await _getAlarmsUseCase();
    result.fold(
      (failure) => emit(AlarmsError(failure.message)),
      (alarms) => emit(AlarmsSuccess(alarms)),
    );
  }

  Future<void> addAlarm(AlarmEntity alarm) async {
    if (alarm.medicationName.isEmpty) {
      emit(AlarmsError("يرجى إدخال اسم الدواء"));
      return;
    }

    emit(AlarmsLoading());
    final result = await _addAlarmUseCase(alarm: alarm);
    await result.fold(
      (failure) async => emit(AlarmsError(failure.message)),
      (_) async {
        emit(AlarmAddedSuccessfully());
        await loadAlarms();
      },
    );
  }

  Future<void> removeAlarm(AlarmEntity alarm) async {
    final result = await _removeAlarmUseCase(alarm: alarm);
    await result.fold(
      (failure) async => emit(AlarmsError(failure.message)),
      (_) async => loadAlarms(),
    );
  }

  Future<void> markAsDone(String alarmId, DateTime time) async {
    final result = await _markAlarmAsDoneUseCase(alarmId: alarmId, time: time);
    await result.fold(
      (failure) async => emit(AlarmsError(failure.message)),
      (_) async => loadAlarms(),
    );
  }
}
