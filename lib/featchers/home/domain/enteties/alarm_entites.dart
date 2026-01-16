// 1. Entity Model
class AlarmEntity {
  final String id;
  final String medicationName;
  final String? note;
  final List<DateTime> reminderTimes;
  final String dosage;

  AlarmEntity({
    required this.id,
    required this.medicationName,
    this.note,
    required this.reminderTimes,
    required this.dosage,
  });
}
