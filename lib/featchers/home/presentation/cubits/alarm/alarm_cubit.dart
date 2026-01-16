import 'package:e_commerce/featchers/home/domain/enteties/alarm_entites.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// تعريف حالات الـ Cubit
abstract class AlarmsState {}
class AlarmsInitial extends AlarmsState {}
class AlarmsLoading extends AlarmsState {}
class AlarmsSuccess extends AlarmsState {
  final List<AlarmEntity> alarms;
  AlarmsSuccess(this.alarms);
}
class AlarmsError extends AlarmsState {
  final String message;
  AlarmsError(this.message);
}
class AlarmAddedSuccessfully extends AlarmsState {}

class AlarmsCubit extends Cubit<AlarmsState> {
  final List<AlarmEntity> _allAlarms = [];
  AlarmsCubit() : super(AlarmsInitial());

  // حافظنا على اسم الميثود addAlarm
  void addAlarm(AlarmEntity alarm) {
    if (alarm.medicationName.isEmpty) {
      emit(AlarmsError("يرجى إدخال اسم الدواء"));
      return;
    }
    if (alarm.reminderTimes.isEmpty) {
      emit(AlarmsError("يجب اختيار وقت واحد على الأقل"));
      return;
    }

    emit(AlarmsLoading());
    try {
      _allAlarms.add(alarm);
      emit(AlarmAddedSuccessfully()); // حالة للعودة التلقائية للصفحة
      emit(AlarmsSuccess(List.from(_allAlarms)));
    } catch (e) {
      emit(AlarmsError("فشل حفظ المنبه، حاول مرة أخرى"));
    }
  }

  // حافظنا على اسم الميثود removeAlarm
  void removeAlarm(String id) {
    _allAlarms.removeWhere((a) => a.id == id);
    emit(AlarmsSuccess(List.from(_allAlarms)));
  }
}