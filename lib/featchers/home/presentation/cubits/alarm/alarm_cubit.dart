import 'dart:convert';

import 'package:e_commerce/core/services/shared_prefs_singelton.dart';
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
  final String _storageKey = "saved_alarms"; // مفتاح التخزين

  AlarmsCubit() : super(AlarmsInitial()) {
    loadAlarms(); // تحميل المنبهات فور إنشاء الـ Cubit
  }

  // استعادة المنبهات من SharedPreferences
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

  // حفظ القائمة الحالية في SharedPreferences
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
      _allAlarms.add(alarm);
      await _saveToPrefs(); // حفظ بعد الإضافة
      emit(AlarmAddedSuccessfully());
      emit(AlarmsSuccess(List.from(_allAlarms)));
    } catch (e) {
      emit(AlarmsError("فشل حفظ المنبه"));
    }
  }

  void removeAlarm(String id) async {
    _allAlarms.removeWhere((a) => a.id == id);
    await _saveToPrefs(); // حفظ بعد الحذف
    emit(AlarmsSuccess(List.from(_allAlarms)));
  }
}