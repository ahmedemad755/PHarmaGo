import 'dart:async';
import 'package:e_commerce/constants.dart';
import 'package:e_commerce/core/di/injection.dart';
import 'package:e_commerce/core/functions_helper/routs.dart';
import 'package:e_commerce/core/services/custom_bloc_observer.dart';
import 'package:e_commerce/core/services/shared_prefs_singelton.dart';
import 'package:e_commerce/core/services/supabase_storge.dart';
import 'package:e_commerce/core/services/local_notification_service.dart';
import 'package:e_commerce/core/utils/app_colors.dart';
import 'package:e_commerce/core/utils/gradient_background.dart';
import 'package:e_commerce/firebase_options.dart';
import 'package:e_commerce/generated/l10n.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest_all.dart' as tz; // مكتبة التوقيت
import 'package:timezone/timezone.dart' as tz;      // مكتبة التوقيت

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    
    // تهيئة مناطق التوقيت لعمل المنبهات بشكل دقيق
    tz.initializeTimeZones();

    // 1. تهيئة الخدمات الأساسية (Firebase, Supabase, Prefs, GetIt, Notifications)
    await _initServices();

    // 2. تحديد الشاشة الافتتاحية
    final String initialRoute = _getInitialRoute();

    runApp(PharmaGo(initialRoute: initialRoute));
  }, (error, stack) {
    debugPrint("🔥 GLOBAL CRASH: $error \n $stack");
  });
}

Future<void> _initServices() async {
  Bloc.observer = CustomBlocObserver();
  
  // تهيئة Firebase
  try {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  } catch (e) {
    debugPrint("❌ Firebase Init Failed: $e");
  }

  // تهيئة خدمة الإشعارات المحلية وطلب التصاريح
  try {
    // طلب تصريح الإشعارات (ضروري لأندرويد 13+)
    await Permission.notification.request();
    
    // طلب تصريح المنبهات الدقيقة (ضروري لعمل الـ Alarms)
    if (await Permission.scheduleExactAlarm.isDenied) {
      await Permission.scheduleExactAlarm.request();
    }

    await LocalNotificationService.init(navigatorKey);
    debugPrint("✅ Local Notifications Initialized");
  } catch (e) {
    debugPrint("❌ Local Notifications Init Failed: $e");
  }

  // تهيئة Supabase
  try {
    await SupabaseStorgeService.initSupabase();
    debugPrint("✅ Supabase Initialized & Buckets Checked");
  } catch (e) {
    debugPrint("❌ Supabase Init Failed: $e");
  }

  // تهيئة المستودعات المحلية وحقن التبعيات
  await Prefs.init();
  await setupGetit();
}

String _getInitialRoute() {
  final bool isOnBoardingSeen = Prefs.getBool(kIsOnBoardingViewSeen) ?? false;
  final user = FirebaseAuth.instance.currentUser;

  if (!isOnBoardingSeen) {
    return AppRoutes.onboarding;
  }

  if (user == null) {
    return AppRoutes.login;
  }
  
  return AppRoutes.home;
}

class PharmaGo extends StatelessWidget {
  final String initialRoute;
  const PharmaGo({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) => GradientBackground(
        child: MaterialApp(
          navigatorKey: navigatorKey,
          theme: ThemeData(
            scaffoldBackgroundColor: AppColors.primaryLight,
            fontFamily: 'Almarai-Regular',
            useMaterial3: true,
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.transparent,
              elevation: 0,
              iconTheme: IconThemeData(color: Colors.black),
            ),
          ),
          localizationsDelegates: const [
            S.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: S.delegate.supportedLocales,
          locale: const Locale('ar'),
          debugShowCheckedModeBanner: false,
          initialRoute: initialRoute,
          onGenerateRoute: generateRoute,
        ),
      ),
    );
  }
}