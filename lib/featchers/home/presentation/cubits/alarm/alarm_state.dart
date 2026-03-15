// تعريف حالات الـ Cubit
import 'package:e_commerce/featchers/home/domain/enteties/alarm_entites.dart';

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

