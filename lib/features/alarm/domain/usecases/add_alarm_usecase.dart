import 'package:dartz/dartz.dart';
import 'package:e_commerce/core/errors/faliur.dart';
import 'package:e_commerce/Features/alarm/domain/entities/alarm_entity.dart';
import 'package:e_commerce/Features/alarm/domain/repositories/alarms_repo.dart';

class AddAlarmUseCase {
  const AddAlarmUseCase(this._alarmsRepo);

  final AlarmsRepo _alarmsRepo;

  Future<Either<Faliur, void>> call({required AlarmEntity alarm}) {
    return _alarmsRepo.addAlarm(alarm);
  }
}
