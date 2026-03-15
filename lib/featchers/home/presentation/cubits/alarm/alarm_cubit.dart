import 'dart:convert';
import 'package:e_commerce/core/services/shared_prefs_singelton.dart';
import 'package:e_commerce/featchers/home/domain/enteties/alarm_entites.dart';
import 'package:e_commerce/featchers/home/presentation/cubits/alarm/alarm_state.dart';
import 'package:e_commerce/core/services/local_notification_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AlarmsCubit extends Cubit<AlarmsState> {
  final List<AlarmEntity> _allAlarms = [];
  final String _storageKey = "saved_alarms";

  AlarmsCubit() : super(AlarmsInitial()) {
    loadAlarms();
  }

  void loadAlarms() {
    try {
      String jsonString = Prefs.getString(_storageKey);
      if (jsonString.isNotEmpty) {
        List<dynamic> jsonList = json.decode(jsonString);
        _allAlarms.clear();
        _allAlarms.addAll(jsonList.map((item) => AlarmEntity.fromMap(item)).toList());
        emit(AlarmsSuccess(List.from(_allAlarms)));
      }
    } catch (e) {
      emit(AlarmsError("فشل في تحميل المنبهات السابقة"));
    }
  }

  Future<void> _saveToPrefs() async {
    List<Map<String, dynamic>> mapList = _allAlarms.map((a) => a.toMap()).toList();
    String jsonString = json.encode(mapList);
    await Prefs.setString(_storageKey, jsonString);
  }

  void addAlarm(AlarmEntity alarm) async {
    if (alarm.medicationName.isEmpty) {
      emit(AlarmsError("يرجى إدخال اسم الدواء"));
      return;
    }
    
    emit(AlarmsLoading());
    try {
      // 1. جدولة المنبه في نظام التشغيل
      await LocalNotificationService.scheduleMedicationReminders(
        alarmId: alarm.id,
        medicationName: alarm.medicationName,
        dosage: alarm.dosage,
        times: alarm.reminderTimes,
      );

      // 2. حفظ المنبه محلياً
      _allAlarms.add(alarm);
      await _saveToPrefs();
      
      emit(AlarmAddedSuccessfully());
      emit(AlarmsSuccess(List.from(_allAlarms)));
    } catch (e) {
      emit(AlarmsError("فشل في ضبط المنبه: ${e.toString()}"));
    }
  }

  void removeAlarm(AlarmEntity alarm) async {
    try {
      // 1. إلغاء الجدولة من نظام التشغيل
      await LocalNotificationService.cancelMedicationReminders(
        alarm.id,
        alarm.reminderTimes.length,
      );

      // 2. الحذف من القائمة والذاكرة
      _allAlarms.removeWhere((a) => a.id == alarm.id);
      await _saveToPrefs();
      emit(AlarmsSuccess(List.from(_allAlarms)));
    } catch (e) {
      emit(AlarmsError("فشل في حذف المنبه"));
    }
  }
}