abstract class AlarmsLocalDataSource {
  Future<List<Map<String, dynamic>>> getAlarms();

  Future<void> saveAlarms(List<Map<String, dynamic>> alarms);

  Future<void> scheduleReminders({
    required String alarmId,
    required String medicationName,
    required String dosage,
    required List<DateTime> times,
  });

  Future<void> cancelReminders({
    required String alarmId,
    required int remindersCount,
  });
}
