import 'dart:convert';

import 'package:e_commerce/Features/alarm/domain/entities/alarm_entity.dart';

class AlarmModel {
  final String id;
  final String medicationName;
  final List<DateTime> reminderTimes;
  final String dosage;
  final List<String> completedTimes;

  AlarmModel({
    required this.id,
    required this.medicationName,
    required this.reminderTimes,
    required this.dosage,
    this.completedTimes = const [],
  });

  factory AlarmModel.fromEntity(AlarmEntity entity) {
    return AlarmModel(
      id: entity.id,
      medicationName: entity.medicationName,
      reminderTimes: entity.reminderTimes,
      dosage: entity.dosage,
      completedTimes: entity.completedTimes,
    );
  }

  AlarmEntity toEntity() {
    return AlarmEntity(
      id: id,
      medicationName: medicationName,
      reminderTimes: reminderTimes,
      dosage: dosage,
      completedTimes: completedTimes,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'medicationName': medicationName,
      'reminderTimes': reminderTimes.map((t) => t.toIso8601String()).toList(),
      'dosage': dosage,
      'completedTimes': completedTimes,
    };
  }

  factory AlarmModel.fromMap(Map<String, dynamic> map) {
    return AlarmModel(
      id: map['id'],
      medicationName: map['medicationName'],
      reminderTimes: (map['reminderTimes'] as List)
          .map((t) => DateTime.parse(t))
          .toList(),
      dosage: map['dosage'],
      completedTimes: List<String>.from(map['completedTimes'] ?? []),
    );
  }

  String toJson() => json.encode(toMap());
  factory AlarmModel.fromJson(String source) =>
      AlarmModel.fromMap(json.decode(source));
}
