import 'dart:convert';

class AlarmEntity {
  final String id;
  final String medicationName;
  final List<DateTime> reminderTimes;
  final String dosage;

  AlarmEntity({
    required this.id,
    required this.medicationName,
    required this.reminderTimes,
    required this.dosage,
  });

  // تحويل الكائن إلى Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'medicationName': medicationName,
      'reminderTimes': reminderTimes.map((t) => t.toIso8601String()).toList(),
      'dosage': dosage,
    };
  }

  // إنشاء كائن من Map
  factory AlarmEntity.fromMap(Map<String, dynamic> map) {
    return AlarmEntity(
      id: map['id'],
      medicationName: map['medicationName'],
      reminderTimes: (map['reminderTimes'] as List)
          .map((t) => DateTime.parse(t))
          .toList(),
      dosage: map['dosage'],
    );
  }

  // للتعامل مع JSON مباشرة
  String toJson() => json.encode(toMap());
  factory AlarmEntity.fromJson(String source) => AlarmEntity.fromMap(json.decode(source));
}