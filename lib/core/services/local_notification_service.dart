import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:e_commerce/core/functions_helper/routs.dart';

class LocalNotificationService {
  static final _plugin = FlutterLocalNotificationsPlugin();

  // تفعيل الـ Global Navigator Key لفتح الصفحات
  static GlobalKey<NavigatorState>? _navigatorKey;

  static Future<void> init(GlobalKey<NavigatorState> navKey) async {
    _navigatorKey = navKey;
    tz.initializeTimeZones();

    const androidInit = AndroidInitializationSettings('@drawable/pharma_go_splash');
    const iosInit = DarwinInitializationSettings();
    
    const initSettings = InitializationSettings(android: androidInit, iOS: iosInit);

    await _plugin.initialize(
      settings:  initSettings,
      onDidReceiveNotificationResponse: _onNotificationTap,
      onDidReceiveBackgroundNotificationResponse: _notificationTapBackground,
    );
  }

  // يتم استدعاؤها عند الضغط على الإشعار والتطبيق مفتوح أو في الخلفية
  static void _onNotificationTap(NotificationResponse response) {
    if (response.payload != null) {
      // ننتقل لصفحة المنبهات (يمكنك تغيير الوجهة لصفحة تفاصيل الدواء)
      _navigatorKey?.currentState?.pushNamed(AppRoutes.alarmsMain);
    }
  }

// دالة التعامل مع الخلفية (Killed State)
  @pragma('vm:entry-point')
  static void _notificationTapBackground(NotificationResponse response) {
    // 1. فك التشفير
    if (response.payload != null) {
      final Map<String, dynamic> data = jsonDecode(response.payload!);
      final String alarmId = data['id'];

      // 2. تسجيل التفاعل في Log النظام (للمطور)
      debugPrint("💊 Background Action: User interacted with Alarm $alarmId");

      // 3. (اختياري) إذا أضفت أزرار مثل "تم أخذ الدواء"
      if (response.actionId == 'mark_as_done') {
  _saveTapDataLocally(alarmId);
      }
    }
  }

  // دالة مساعدة للتخزين (يجب أن تستخدم SharedPreferences بشكل مستقل)
static Future<void> _saveTapDataLocally(String alarmId) async {
    try {
      // 1. فتح نسخة جديدة من SharedPreferences لأننا في Isolate معزول
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      
      // 2. الحصول على قائمة المنبهات التي تم التفاعل معها سابقاً (إن وجدت)
      List<String> tappedAlarms = prefs.getStringList('tapped_alarms_list') ?? [];
      
      // 3. إضافة الـ ID الجديد إذا لم يكن موجوداً
      if (!tappedAlarms.contains(alarmId)) {
        tappedAlarms.add(alarmId);
        await prefs.setStringList('tapped_alarms_list', tappedAlarms);
      }
      
      debugPrint("✅ Alarm ID $alarmId saved successfully in background isolate.");
    } catch (e) {
      debugPrint("❌ Error saving tap data in background: $e");
    }
  }

  /// جدولة منبهات لدواء معين
  static Future<void> scheduleMedicationReminders({
    required String alarmId,
    required String medicationName,
    required String dosage,
    required List<DateTime> times,
  }) async {
    for (int i = 0; i < times.length; i++) {
      // إنشاء ID فريد لكل موعد داخل نفس المنبه
      final int notificationId = alarmId.hashCode + i;
      
      var scheduledDate = tz.TZDateTime.from(times[i], tz.local);

      // إذا كان الوقت قد فات اليوم، نجدوله للغد
      if (scheduledDate.isBefore(tz.TZDateTime.now(tz.local))) {
        scheduledDate = scheduledDate.add(const Duration(days: 1));
      }

      await _plugin.zonedSchedule(
        id:  notificationId,
        title:  'موعد دواء: $medicationName',
        body: 'الجرعة المطلوبة: $dosage',
        scheduledDate: scheduledDate,
        notificationDetails: const NotificationDetails(
          android: AndroidNotificationDetails(
            'medication_reminders_channel',
            'تذكيرات الأدوية',
            channelDescription: 'قناة تذكير مواعيد الأدوية اليومية',
            importance: Importance.max,
            priority: Priority.high,
            fullScreenIntent: true, // يجعل الإشعار يظهر بشكل بارز
            styleInformation: BigTextStyleInformation(''),
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        //  uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time, // يجعله يتكرر يومياً في نفس الوقت
        payload: jsonEncode({'id': alarmId, 'name': medicationName}),
      );
    }
  }

  /// إلغاء كافة المنبهات الخاصة بدواء معين
static Future<void> cancelMedicationReminders(String alarmId, int count) async {
    for (int i = 0; i < count; i++) {
      // ✅ التصحيح: إضافة id: قبل المعامل واستخدام abs لضمان رقم موجب
      await _plugin.cancel(id: (alarmId.hashCode + i).abs());
    }
  }
}