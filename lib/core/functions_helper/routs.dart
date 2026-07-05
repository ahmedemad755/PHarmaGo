import 'package:e_commerce/Features/alarm/presentation/widgets/add_alarm_view.dart';
import 'package:e_commerce/Features/products/domain/entityes/product_enteti.dart';
import 'package:e_commerce/Features/products/presentation/cubit/products_cubit.dart';
import 'package:e_commerce/core/di/injection.dart';
import 'package:e_commerce/Features/auth/data/repositories/auth_repo_impl.dart';
import 'package:e_commerce/Features/auth/presentation/cubits/login/login_cubit.dart';
import 'package:e_commerce/Features/auth/presentation/cubits/signup/sugnup_cubit.dart';
import 'package:e_commerce/Features/auth/presentation/cubits/vereficationotp/vereficationotp_cubit.dart';
import 'package:e_commerce/Features/auth/presentation/view/forgot_password_view.dart';
import 'package:e_commerce/Features/auth/presentation/view/login_view.dart';
import 'package:e_commerce/Features/auth/presentation/view/oTPVerificationScreen.dart';
import 'package:e_commerce/Features/auth/presentation/view/reset_Password.dart';
import 'package:e_commerce/Features/auth/presentation/view/signup.view.dart';
import 'package:e_commerce/Features/alarm/presentation/cubits/alarm/alarm_cubit.dart';
import 'package:e_commerce/Features/cart/domain/enteties/cart_entety.dart';
import 'package:e_commerce/Features/cart/presentation/cubits/cart_cubit/cart_cubit.dart';
import 'package:e_commerce/Features/chatbot/presentation/cubit/chat_cubit.dart';
import 'package:e_commerce/Features/chatbot/presentation/views/chat_screen.dart';
import 'package:e_commerce/Features/orders/domain/entities/order_entity.dart';
import 'package:e_commerce/Features/checkout/presentation/views/check_out_view.dart';
import 'package:e_commerce/Features/home/presentation/cubits/banners/banner_cubit.dart';
import 'package:e_commerce/Features/alarm/presentation/views/alarmpage.dart';
import 'package:e_commerce/Features/home/presentation/view/main_veiw.dart';
import 'package:e_commerce/Features/orders/presentation/view/myorders_view.dart';
import 'package:e_commerce/Features/home/presentation/view/notifecation_app_page.dart';
import 'package:e_commerce/Features/orders/presentation/view/order_details_view.dart';
import 'package:e_commerce/Features/home/presentation/view/pharmacy_home_screen_body.dart';
import 'package:e_commerce/Features/prescription/presentation/view/uploadPrescription.dart';
import 'package:e_commerce/Features/onboarding/views/onboarding_view.dart';
import 'package:e_commerce/Features/orders/presentation/cubits/myOrders/my_orders_cubit.dart';
import 'package:e_commerce/Features/prescription/presentation/cubits/prescription/prescription_cubit.dart';
import 'package:e_commerce/Features/products/presentation/view/product_details_view.dart';
import 'package:e_commerce/Features/splash/presentation/views/splash_view.dart';
import 'package:e_commerce/maps/business_logic/cubit/maps/maps_cubit.dart';
import 'package:e_commerce/maps/data/repo/place_repo.dart';
import 'package:e_commerce/maps/data/web/place_web_servises.dart';
import 'package:e_commerce/maps/presentation/screens/map_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppRoutes {
  static const String splash = 'splash';
  static const String onboarding = 'onboarding';
  static const String login = 'login';
  static const String signup = 'signup';
  static const String home = 'home';
  static const String forgotPassword = 'forgotPassword';
  static const String otp = 'otp';
  static const String sendResetPassword = 'sendResetPassword';
  static const String bestFruites = 'bestFruites';
  static const String checkout = 'checkout';
  static const String pharmacyHome = 'pharmacyHome';
  static const String productDetails = 'productDetails';
  static const String uploadPrescription = 'uploadPrescription';
  static const String ChatbootBody = "ChatbootBody";
  static const String alarmsMain = 'alarmsMain';
  static const String addAlarm = 'addAlarm';
  static const String notificationsView = 'notificationsView';
  static const String myordersView = 'myordersView';
  static const String orderDetailsView = 'orderDetailsView';
  static const String mapScreen = 'mapScreen';
}

// دالة مساعدة لإنشاء مسار تسجيل الدخول
Route<dynamic> _buildLoginRoute() {
  return MaterialPageRoute(
    settings: const RouteSettings(name: AppRoutes.login),
    builder: (_) => BlocProvider.value(
      value: getIt<LoginCubit>(),
      child: const LoginView(),
    ),
  );
}

// Auth Guard Wrapper: دالة لفحص حالة تسجيل الدخول قبل الانتقال
Route<dynamic> authGuard(Route<dynamic> route) {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    return _buildLoginRoute();
  }
  return route;
}

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case AppRoutes.splash:
      return MaterialPageRoute(builder: (_) => const SplashView());

    case AppRoutes.onboarding:
      return MaterialPageRoute(builder: (_) => const OnboardingView());

    case AppRoutes.login:
      return _buildLoginRoute();

    case AppRoutes.home:
      return authGuard(
        MaterialPageRoute(
          settings: const RouteSettings(name: AppRoutes.home),
          builder: (context) => MultiBlocProvider(
            providers: [
              BlocProvider.value(value: getIt<CartCubit>()),
              BlocProvider.value(value: getIt<ProductsCubit>()),
              // ✅ أضفنا lazy: false لضمان أن الكيوبيت جاهز قبل بناء أي صفحة داخلية
              // BlocProvider<AlarmsCubit>(
              //   create: (context) => getIt<AlarmsCubit>(),
              //   lazy: false,
              // ),
              BlocProvider.value(
                value: getIt<OrdersCubit>()
                  ..fetchUserOrders(
                    uID: FirebaseAuth.instance.currentUser?.uid ?? "",
                  ),
              ),
            ],
            // ✅ استخدم Builder هنا لإنشاء Context جديد "تحت" الـ Providers
            child: Builder(
              builder: (innerContext) =>
                  MainVeiw(authRepoImpl: getIt<AuthRepoImpl>()),
            ),
          ),
        ),
      );

    case AppRoutes.mapScreen:
      return MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (BuildContext context) =>
              MapsCubit(MapsRepository(PlacesWebservices())),
          child: MapScreen(),
        ),
      );

    case AppRoutes.myordersView:
      return authGuard(
        MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: getIt<OrdersCubit>()
              ..fetchUserOrders(
                uID: FirebaseAuth.instance.currentUser?.uid ?? "",
              ),
            child: const OrdersView(),
          ),
        ),
      );
    case AppRoutes.pharmacyHome:
      return authGuard(
        MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => getIt<BannersCubit>()..getBanners()),
              BlocProvider.value(
                value: getIt<ProductsCubit>()
                  ..getProducts()
                  ..fetchBestSelling(),
              ),
              BlocProvider.value(value: getIt<CartCubit>()),
            ],
            child: const PharmacyHomeScreenNew(),
          ),
        ),
      );

    // case AppRoutes.bestFruites:
    //   return MaterialPageRoute(
    //     builder: (_) => BlocProvider(
    //       create: (_) => getIt<ProductsCubit>()..fetchBestSelling(topN: 5),
    //       child: const BestSellingFruitesView(),
    //     ),
    //   );

    case AppRoutes.checkout:
      final cartEntity = settings.arguments as CartEntity;
      return authGuard(
        MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: getIt<CartCubit>(),
            child: CheckOutView(cartEntity: cartEntity),
          ),
        ),
      );

    case AppRoutes.uploadPrescription:
      return authGuard(
        MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => getIt<PrescriptionCubit>()),
              BlocProvider.value(value: getIt<CartCubit>()),
            ],
            child: const UploadPrescriptionView(),
          ),
        ),
      );

    case AppRoutes.ChatbootBody:
      return authGuard(
        MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => getIt<ChatCubit>(),
            child: ChatScreen(),
          ),
        ),
      );

    case AppRoutes.alarmsMain:
      return authGuard(
        MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: getIt<AlarmsCubit>(), // ✅ هنا قمت بتوفيره لـ MainAlarmsView
            child: const MainAlarmsView(),
          ),
        ),
      );

    case AppRoutes.addAlarm:
      return authGuard(
        MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: getIt<AlarmsCubit>(),
            child: const AddAlarmView(),
          ),
        ),
      );

    case AppRoutes.productDetails:
      if (settings.arguments is AddProductIntety) {
        final product = settings.arguments as AddProductIntety;
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: getIt<CartCubit>(),
            child: DetailsScreen(product: product),
          ),
        );
      }
      return _errorRoute();

    case AppRoutes.forgotPassword:
      return MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (context) => getIt<OTPCubit>(),
          child: const ForgotPasswordScreen(),
        ),
      );

    case AppRoutes.otp:
      final args = settings.arguments as Map<String, dynamic>;
      final otpCubit = args['cubit'] as OTPCubit;
      final phoneNumber = args['phone'] as String?;
      return MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: otpCubit,
          child: OTPVerificationScreen(phoneNumber: phoneNumber),
        ),
      );

    case AppRoutes.sendResetPassword:
      return MaterialPageRoute(builder: (_) => const SendResetPassword());

    case AppRoutes.signup:
      return MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (context) => getIt<SugnupCubit>(),
          child: const Signup(),
        ),
      );

    case AppRoutes.notificationsView:
      return authGuard(
        MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: getIt<OrdersCubit>(),
            child: const NotificationsView(),
          ),
        ),
      );

    case AppRoutes.orderDetailsView:
      final order = settings.arguments as OrderEntity;
      return authGuard(
        MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider.value(value: getIt<OrdersCubit>()),
              BlocProvider.value(value: getIt<CartCubit>()),
            ],
            child: OrderDetailsView(order: order),
          ),
        ),
      );

    default:
      return _errorRoute();
  }
}

Route<dynamic> _errorRoute() {
  return MaterialPageRoute(
    builder: (_) => Scaffold(
      appBar: AppBar(title: const Text("خطأ في المسار")),
      body: const Center(child: Text("عذراً، هذا المسار غير موجود!")),
    ),
  );
}
