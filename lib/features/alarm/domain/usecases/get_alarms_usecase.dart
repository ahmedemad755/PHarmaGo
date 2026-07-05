import 'package:dartz/dartz.dart';
import 'package:e_commerce/core/errors/faliur.dart';
import 'package:e_commerce/Features/alarm/domain/entities/alarm_entity.dart';
import 'package:e_commerce/Features/alarm/domain/repositories/alarms_repo.dart';

class GetAlarmsUseCase {
  const GetAlarmsUseCase(this._alarmsRepo);

  final AlarmsRepo _alarmsRepo;

  Future<Either<Faliur, List<AlarmEntity>>> call() {
    return _alarmsRepo.getAlarms();
  }
}
