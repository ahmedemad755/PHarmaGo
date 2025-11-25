import 'package:e_commerce/constants.dart';
import 'package:e_commerce/core/di/injection.dart';
import 'package:e_commerce/core/functions_helper/routs.dart';
import 'package:e_commerce/core/services/custom_bloc_observer.dart';
import 'package:e_commerce/core/services/firebase_auth_service.dart';
import 'package:e_commerce/core/services/shared_prefs_singelton.dart';
import 'package:e_commerce/firebase_options.dart';
import 'package:e_commerce/generated/l10n.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize dependency injection
  Bloc.observer = CustomBlocObserver();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Prefs.init();
  setupGetit();
  // تحديد البداية بناءً على الحالة
  final isOnBoardingSeen = Prefs.getBool(kIsOnBoardingViewSeen);
  var isLoggedIn = getIt<FirebaseAuthService>().isLoggedIn();
  String initialRoute;
  if (!isOnBoardingSeen) {
    initialRoute = AppRoutes.onboarding;
  } else if (isLoggedIn) {
    initialRoute = AppRoutes.home;
  } else {
    initialRoute = AppRoutes.login;
  }
  runApp(FuitHub(initialRoute: initialRoute));
}

class FuitHub extends StatelessWidget {
  final String initialRoute;
  const FuitHub({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        fontFamily:
            'Almarai-Regular', // ← اسم الفونت اللي عرفته في pubspec.yaml
      ),
      localizationsDelegates: [
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
    );
  }
}
