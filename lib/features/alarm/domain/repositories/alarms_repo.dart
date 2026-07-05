import 'package:dartz/dartz.dart';
import 'package:e_commerce/core/errors/faliur.dart';
import 'package:e_commerce/Features/alarm/domain/entities/alarm_entity.dart';

abstract class AlarmsRepo {
  Future<Either<Faliur, List<AlarmEntity>>> getAlarms();

  Future<Either<Faliur, void>> addAlarm(AlarmEntity alarm);

  Future<Either<Faliur, void>> removeAlarm(AlarmEntity alarm);

  Future<Either<Faliur, void>> markAlarmAsDone({
    required String alarmId,
    required DateTime time,
  });
}
