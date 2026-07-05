class AlarmEntity {
  final String id;
  final String medicationName;
  final List<DateTime> reminderTimes;
  final String dosage;
  final List<String> completedTimes;

  AlarmEntity({
    required this.id,
    required this.medicationName,
    required this.reminderTimes,
    required this.dosage,
    this.completedTimes = const [],
  });
}
