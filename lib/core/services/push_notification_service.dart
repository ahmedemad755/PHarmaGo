import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce/core/utils/backend_points.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:e_commerce/core/functions_helper/routs.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint('📨 Background FCM: ${message.messageId}');
}

class PushNotificationService {
  static final _messaging = FirebaseMessaging.instance;
  static final _localPlugin = FlutterLocalNotificationsPlugin();
  static GlobalKey<NavigatorState>? _navigatorKey;

  static const _fcmChannel = AndroidNotificationChannel(
    'fcm_high_importance_channel',
    'إشعارات PharmaGo',
    description: 'إشعارات الطلبات وتنبيهات الحرارة',
    importance: Importance.max,
  );

  static Future<void> init(GlobalKey<NavigatorState> navKey) async {
    _navigatorKey = navKey;

    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.denied) return;

    await _localPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_fcmChannel);

    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageOpenedApp);

    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      _handleMessageOpenedApp(initialMessage);
    }

    await _messaging.subscribeToTopic('pharma_go_offers');
    debugPrint('✅ PushNotificationService initialized');
  }

  // ─── إرسال إشعار يدوي (من التطبيق) ──────────────────────────────────────────
  
  static Future<void> sendOrderNotification({
    required String userToken,
    required String orderId,
    required String status,
  }) async {
    try {
      // ملاحظة: الإرسال المباشر من الكود يتطلب إعدادات OAuth2 معقدة في التحديث الجديد لـ Firebase
      // لذا يفضل دائماً جعل هذه الخطوة تتم عبر Cloud Functions.
      // هنا سنحاكي المنطق الذي ستستدعيه:
      debugPrint('🔔 محاولة إرسال إشعار لتحديث الطلب رقم: $orderId');
      
      // إذا كنت تستخدم مكتبة خارجية أو API وسيط للإرسال:
      // await http.post( ... ); 
    } catch (e) {
      debugPrint('❌ Error sending notification: $e');
    }
  }

  // ─── Foreground Handler ─────────────────────────────────────────────────────

  static Future<void> _handleForegroundMessage(RemoteMessage message) async {
    final notification = message.notification;
    if (notification == null) return;

    await _localPlugin.show(
      id: message.hashCode,
      title: notification.title,
      body: notification.body,
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          _fcmChannel.id,
          _fcmChannel.name,
          channelDescription: _fcmChannel.description,
          importance: Importance.max,
          priority: Priority.high,
          color: _isTemperatureAlert(message.data)
              ? const Color(0xFFE53935)
              : const Color(0xFF1D9E75),
        ),
      ),
      payload: jsonEncode(message.data),
    );
  }

  // ─── Navigation Handler ──────────────────────────────────────────────────────

  static void _handleMessageOpenedApp(RemoteMessage message) {
    final data = message.data;
    final type = data['type'] as String?;

    if (type == 'order_update' && data.containsKey('orderId')) {
      _navigatorKey?.currentState?.pushNamed(
        AppRoutes.myordersView, // تأكد من وجود هذا المسار في ملف الروتس
        arguments: data['orderId'],
      );
    } else {
      _navigatorKey?.currentState?.pushNamed(AppRoutes.home); // أو أي صفحة افتراضية أخرى
    }
  }

  // ─── Helpers & Token Management ──────────────────────────────────────────────

  static bool _isTemperatureAlert(Map<String, dynamic> data) {
    return data['type'] == 'temperature_alert';
  }

  static Future<String?> getToken() async => await _messaging.getToken();

  static Future<void> saveTokenToFirestore({
    required String userId,
    required FirebaseFirestore firestore,
  }) async {
    final token = await getToken();
    if (token == null) return;

    await firestore.collection(BackendPoints.getUserData).doc(userId).update({
      'fcmToken': token,
      'tokenUpdatedAt': FieldValue.serverTimestamp(),
    });
  }
}