import 'package:dartz/dartz.dart';
import 'package:intl/intl.dart';
import 'package:e_commerce/core/errors/faliur.dart';
import 'package:e_commerce/Features/alarm/data/datasource/local/alarms_local_datasource.dart';
import 'package:e_commerce/Features/alarm/data/models/alarm_model.dart';
import 'package:e_commerce/Features/alarm/domain/entities/alarm_entity.dart';
import 'package:e_commerce/Features/alarm/domain/repositories/alarms_repo.dart';

class AlarmsRepoImpl implements AlarmsRepo {
  AlarmsRepoImpl(this._localDataSource);

  final AlarmsLocalDataSource _localDataSource;

  @override
  Future<Either<Faliur, List<AlarmEntity>>> getAlarms() async {
    try {
      final data = await _localDataSource.getAlarms();
      final alarms = data
          .map((e) => AlarmModel.fromMap(e).toEntity())
          .toList();
      return right(alarms);
    } catch (e) {
      return left(ServerFaliur('فشل في تحميل المنبهات السابقة'));
    }
  }

  @override
  Future<Either<Faliur, void>> addAlarm(AlarmEntity alarm) async {
    try {
      // 1. جدولة المنبه في نظام التشغيل
      await _localDataSource.scheduleReminders(
        alarmId: alarm.id,
        medicationName: alarm.medicationName,
        dosage: alarm.dosage,
        times: alarm.reminderTimes,
      );

      // 2. حفظ المنبه محلياً
      final current = await _localDataSource.getAlarms();
      current.add(AlarmModel.fromEntity(alarm).toMap());
      await _localDataSource.saveAlarms(current);

      return right(null);
    } catch (e) {
      return left(ServerFaliur('فشل في ضبط المنبه: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Faliur, void>> removeAlarm(AlarmEntity alarm) async {
    try {
      // 1. إلغاء الجدولة من نظام التشغيل
      await _localDataSource.cancelReminders(
        alarmId: alarm.id,
        remindersCount: alarm.reminderTimes.length,
      );

      // 2. الحذف من القائمة المحفوظة
      final current = await _localDataSource.getAlarms();
      current.removeWhere((e) => e['id'] == alarm.id);
      await _localDataSource.saveAlarms(current);

      return right(null);
    } catch (e) {
      return left(ServerFaliur('فشل في حذف المنبه'));
    }
  }

  @override
  Future<Either<Faliur, void>> markAlarmAsDone({
    required String alarmId,
    required DateTime time,
  }) async {
    try {
      final current = await _localDataSource.getAlarms();
      final index = current.indexWhere((e) => e['id'] == alarmId);
      if (index == -1) return right(null);

      final alarm = AlarmModel.fromMap(current[index]);
      final timeKey = DateFormat('yyyy-MM-dd HH:mm').format(time);

      if (!alarm.completedTimes.contains(timeKey)) {
        final updated = AlarmModel(
          id: alarm.id,
          medicationName: alarm.medicationName,
          reminderTimes: alarm.reminderTimes,
          dosage: alarm.dosage,
          completedTimes: [...alarm.completedTimes, timeKey],
        );
        current[index] = updated.toMap();
        await _localDataSource.saveAlarms(current);
      }

      return right(null);
    } catch (e) {
      return left(ServerFaliur('فشل في تحديث حالة الجرعة'));
    }
  }
}
