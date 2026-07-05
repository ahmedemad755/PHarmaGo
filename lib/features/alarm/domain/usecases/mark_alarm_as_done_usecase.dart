import 'package:dartz/dartz.dart';
import 'package:e_commerce/core/errors/faliur.dart';
import 'package:e_commerce/Features/alarm/domain/repositories/alarms_repo.dart';

class MarkAlarmAsDoneUseCase {
  const MarkAlarmAsDoneUseCase(this._alarmsRepo);

  final AlarmsRepo _alarmsRepo;

  Future<Either<Faliur, void>> call({
    required String alarmId,
    required DateTime time,
  }) {
    return _alarmsRepo.markAlarmAsDone(alarmId: alarmId, time: time);
  }
}
