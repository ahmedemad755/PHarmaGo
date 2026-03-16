import 'package:e_commerce/core/di/injection.dart';
import 'package:e_commerce/featchers/AUTH/data/repos/auth_repo_impl.dart';
import 'package:e_commerce/featchers/home/presentation/cubits/alarm/alarm_cubit.dart';
import 'package:e_commerce/featchers/home/presentation/views/CustomBottomNavigationBar.dart';
import 'package:e_commerce/featchers/home/presentation/views/widgets/main_view_body_bloc_consumer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainVeiw extends StatefulWidget {
  // إضافة الكلمة المفتاحية final للمتغير الممرر في الـ Constructor
  final AuthRepoImpl authRepoImpl;

  const MainVeiw({super.key, required this.authRepoImpl});

  @override
  State<MainVeiw> createState() => _MainVeiwState();
}

class _MainVeiwState extends State<MainVeiw> {
  int currentViewIndex = 0;

  @override
  void initState() {
    super.initState();
    // فحص التنبيهات التي تم الضغط عليها والتطبيق مغلق
    _checkPendingNotificationTaps();
  }

  Future<void> _checkPendingNotificationTaps() async {
    // تأخير بسيط لضمان أن الـ Bloc والـ UI استقروا تماماً
    await Future.delayed(const Duration(milliseconds: 800));

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? tappedAlarms = prefs.getStringList('tapped_alarms_list');

    if (tappedAlarms != null && tappedAlarms.isNotEmpty) {
      debugPrint("🔔 إشعارات معلقة مكتشفة: $tappedAlarms");

      // 1. الانتقال لتبويب المنبهات (افترضنا أن رقمه 2)
      setState(() {
        currentViewIndex = 2;
      });

      // 2. إظهار رسالة ترحيبية أو تنبيه للمستخدم
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              "تم نقلك لمراجعة مواعيد الأدوية الأخيرة",
              style: TextStyle(fontFamily: 'Almarai-Regular'),
            ),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }

      // 3. تنظيف القائمة فوراً لمنع تكرار الانتقال عند عمل Rebuild
      await prefs.remove('tapped_alarms_list');
    }
  }

  @override
  Widget build(BuildContext context) {
    // ✅ تم إزالة الـ MultiBlocProvider لأن الـ Cubits تأتي الآن من AppRouter
    return BlocProvider(
      create: (context) => getIt<AlarmsCubit>(),
      child: Scaffold(
        backgroundColor: const Color(0xFFFBFBFB),
        extendBody: true,

        bottomNavigationBar: SafeArea(
          child: BottomNavPage(
            currentIndex: currentViewIndex,
            onTap: (index) {
              setState(() {
                currentViewIndex = index;
              });
            },
          ),
        ),

        // الـ BlocConsumer الداخلي سيعمل الآن بدون Error لأنه يقع تحت الـ Router Provider
        body: MainViewBodyBlocConsumer(currentViewIndex: currentViewIndex),
      ),
    );
  }
}
