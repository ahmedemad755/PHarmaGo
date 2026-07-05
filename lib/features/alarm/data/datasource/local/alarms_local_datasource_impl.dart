import 'dart:convert';

import 'package:e_commerce/core/services/notification/local_notification_service.dart';
import 'package:e_commerce/core/services/preferences/shared_prefs_service.dart';
import 'package:e_commerce/Features/alarm/data/datasource/local/alarms_local_datasource.dart';

class AlarmsLocalDataSourceImpl implements AlarmsLocalDataSource {
  static const String _storageKey = 'saved_alarms';

  @override
  Future<List<Map<String, dynamic>>> getAlarms() async {
    final jsonString = Prefs.getString(_storageKey);
    if (jsonString.isEmpty) return [];

    final List<dynamic> jsonList = json.decode(jsonString);
    return jsonList.cast<Map<String, dynamic>>();
  }

  @override
  Future<void> saveAlarms(List<Map<String, dynamic>> alarms) async {
    await Prefs.setString(_storageKey, json.encode(alarms));
  }

  @override
  Future<void> scheduleReminders({
    required String alarmId,
    required String medicationName,
    required String dosage,
    required List<DateTime> times,
  }) {
    return LocalNotificationService.scheduleMedicationReminders(
      alarmId: alarmId,
      medicationName: medicationName,
      dosage: dosage,
      times: times,
    );
  }

  @override
  Future<void> cancelReminders({
    required String alarmId,
    required int remindersCount,
  }) {
    return LocalNotificationService.cancelMedicationReminders(
      alarmId,
      remindersCount,
    );
  }
}
