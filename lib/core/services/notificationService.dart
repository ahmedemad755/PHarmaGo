// // 2. Notification Service

// class NotificationService {
//   // تعريف الـ Plugin كمتغير خاص داخل الكلاس
//   static final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();

//   static Future<void> init() async {
//     tz.initializeTimeZones();
    
//     const AndroidInitializationSettings androidSettings = 
//         AndroidInitializationSettings('@mipmap/ic_launcher');
        
//     const InitializationSettings settings = InitializationSettings(
//       android: androidSettings,
//       iOS: DarwinInitializationSettings(),
//     );
    
//     await _notifications.initialize(settings);
//   }

//   static Future<void> scheduleDailyNotification({
//     required int id,
//     required String title,
//     required String body,
//     required DateTime time,
//   }) async {
//     // التأكد من استدعاء المكونات من مكتبة الإشعارات مباشرة
//     await _notifications.zonedSchedule(
//       id,
//       title,
//       body,
//       _nextInstanceOfTime(time),
//       const NotificationDetails(
//         android: AndroidNotificationDetails(
//           'med_channel', 
//           'Medication Alarms',
//           channelDescription: 'Notifications for medication reminders',
//           importance: Importance.max,
//           priority: Priority.high,
//           ticker: 'ticker',
//         ),
//         iOS: DarwinNotificationDetails(),
//       ),
//       androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
//       uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
//       matchDateTimeComponents: DateTimeComponents.time,
//     );
//   }

//   static tz.TZDateTime _nextInstanceOfTime(DateTime time) {
//     final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
//     tz.TZDateTime scheduledDate = tz.TZDateTime(
//         tz.local, now.year, now.month, now.day, time.hour, time.minute);
    
//     if (scheduledDate.isBefore(now)) {
//       scheduledDate = scheduledDate.add(const Duration(days: 1));
//     }
//     return scheduledDate;
//   }
// }