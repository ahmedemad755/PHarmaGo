import 'dart:async';
import 'package:e_commerce/core/di/injection.dart';
import 'package:e_commerce/core/functions_helper/routs.dart';
import 'package:e_commerce/core/services/custom_bloc_observer.dart';
import 'package:e_commerce/core/services/push_notification_service.dart';
import 'package:e_commerce/core/services/shared_prefs_singelton.dart';
import 'package:e_commerce/core/services/supabase_storge.dart';
import 'package:e_commerce/core/services/local_notification_service.dart';
import 'package:e_commerce/core/utils/app_colors.dart';
import 'package:e_commerce/core/utils/gradient_background.dart';
import 'package:e_commerce/firebase_options.dart';
import 'package:e_commerce/generated/l10n.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:timezone/data/latest_all.dart' as tz;

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  runZonedGuarded(
    () async {
      // 1. ضمان جاهزية المحرك
      WidgetsFlutterBinding.ensureInitialized();

      // 2. تهيئة التوقيت (مهمة للمنبهات)
      tz.initializeTimeZones();

      // 3. تهيئة الخدمات الأساسية
      await _initServices();

      runApp(const PharmaGo(initialRoute: AppRoutes.splash));
    },
    (error, stack) {
      debugPrint("🔥 GLOBAL CRASH: $error \n $stack");
    },
  );
}

Future<void> _initServices() async {
  // مراقب الـ Bloc
  Bloc.observer = CustomBlocObserver();

  // تهيئة Firebase (ضروري قبل أي عملية Auth)
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    // تهيئة الإشعارات في الخلفية لعدم تعطيل الـ Main Thread
    unawaited(PushNotificationService.init(navigatorKey));
  } catch (e) {
    debugPrint("❌ Firebase Init Failed: $e");
  }

  // تهيئة Supabase
  try {
    await SupabaseStorgeService.initSupabase();
  } catch (e) {
    debugPrint("❌ Supabase Init Failed: $e");
  }

  // تهيئة الإشعارات المحلية (بدون طلب تصاريح هنا لمنع التهنيج)
  try {
    await LocalNotificationService.init(navigatorKey);
  } catch (e) {
    debugPrint("❌ Local Notifications Init Failed: $e");
  }

  // تهيئة البيانات المحلية وحقن التبعيات
  await Prefs.init();
  await setupGetit();
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
