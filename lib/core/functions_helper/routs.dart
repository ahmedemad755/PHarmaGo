import 'package:e_commerce/core/di/injection.dart';
import 'package:e_commerce/core/enteties/product_enteti.dart';
import 'package:e_commerce/core/products_cubit/products_cubit.dart';
import 'package:e_commerce/featchers/AUTH/data/repos/auth_repo.dart';
import 'package:e_commerce/featchers/AUTH/data/repos/auth_repo_impl.dart';
import 'package:e_commerce/featchers/AUTH/presentation/cubits/login/login_cubit.dart';
import 'package:e_commerce/featchers/AUTH/presentation/cubits/signup/sugnup_cubit.dart';
import 'package:e_commerce/featchers/AUTH/presentation/cubits/vereficationotp/vereficationotp_cubit.dart';
import 'package:e_commerce/featchers/AUTH/presentation/view/forgot_password_view.dart';
import 'package:e_commerce/featchers/AUTH/presentation/view/login_view.dart';
import 'package:e_commerce/featchers/AUTH/presentation/view/oTPVerificationScreen.dart';
import 'package:e_commerce/featchers/AUTH/presentation/view/reset_Password.dart';
import 'package:e_commerce/featchers/AUTH/presentation/view/signup.view.dart';
import 'package:e_commerce/featchers/best_selling_fruites/presentations/views/best_seliling_fruites_view.dart';
import 'package:e_commerce/featchers/checkout/data/order_model.dart';
import 'package:e_commerce/featchers/checkout/presentation/views/check_out_view.dart';
import 'package:e_commerce/featchers/home/domain/enteties/cart_entety.dart';
import 'package:e_commerce/featchers/home/presentation/cubits/alarm/alarm_cubit.dart';
import 'package:e_commerce/featchers/home/presentation/cubits/banners/banner_cubit.dart';
import 'package:e_commerce/featchers/home/presentation/cubits/cart_cubit/cart_cubit.dart';
import 'package:e_commerce/featchers/home/presentation/cubits/myOrders/my_orders_cubit.dart';
import 'package:e_commerce/featchers/home/presentation/cubits/prescription/prescription_cubit.dart';
import 'package:e_commerce/featchers/home/presentation/views/main_veiw.dart';
import 'package:e_commerce/featchers/home/presentation/views/widgets/ProductDetailsScreen.dart';
import 'package:e_commerce/featchers/home/presentation/views/widgets/alarmpage.dart';
import 'package:e_commerce/featchers/home/presentation/views/widgets/chatboot_body.dart';
import 'package:e_commerce/featchers/home/presentation/views/widgets/myorders_view.dart';
import 'package:e_commerce/featchers/home/presentation/views/widgets/notifecation_app_page.dart';
import 'package:e_commerce/featchers/home/presentation/views/widgets/order_details_view.dart';
import 'package:e_commerce/featchers/home/presentation/views/widgets/pharmacy_home_screen_new.dart';
import 'package:e_commerce/featchers/home/presentation/views/widgets/uploadPrescription.dart';
import 'package:e_commerce/featchers/onboarding/views/onboarding_view.dart';
import 'package:e_commerce/featchers/splash/presentation/views/splash_view.dart';
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
}

// دالة مساعدة لإنشاء مسار تسجيل الدخول
Route<dynamic> _buildLoginRoute() {
  return MaterialPageRoute(
    settings: const RouteSettings(name: AppRoutes.login),
    builder: (_) => BlocProvider(
      create: (context) => LoginCubit(getIt<AuthRepo>()),
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
      return authGuard(MaterialPageRoute(
        settings: const RouteSettings(name: AppRoutes.home),
        builder: (context) => MultiBlocProvider(
          providers: [
            BlocProvider.value(value: getIt<CartCubit>()),
            BlocProvider.value(value: getIt<ProductsCubit>()),
            BlocProvider.value(
              value: getIt<OrdersCubit>()
                ..fetchUserOrders(uID: FirebaseAuth.instance.currentUser?.uid ?? ""),
            ),
          ],
          child: MainVeiw(authRepoImpl: getIt<AuthRepoImpl>()),
        ),
      ));

    case AppRoutes.myordersView:
      return authGuard(MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: getIt<OrdersCubit>()
            ..fetchUserOrders(uID: FirebaseAuth.instance.currentUser?.uid ?? ""),
          child: const OrdersView(),
        ),
      ));

    case AppRoutes.pharmacyHome:
      return authGuard(MaterialPageRoute(
        builder: (_) => MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => getIt<BannersCubit>()..getBanners()),
            BlocProvider.value(
                value: getIt<ProductsCubit>()
                  ..getProducts()
                  ..fetchBestSelling()),
            BlocProvider.value(value: getIt<CartCubit>()),
          ],
          child: const PharmacyHomeScreenNew(),
        ),
      ));

    case AppRoutes.bestFruites:
      return MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (_) => getIt<ProductsCubit>()..fetchBestSelling(topN: 5),
          child: const BestSellingFruitesView(),
        ),
      );

    case AppRoutes.checkout:
      final cartEntity = settings.arguments as CartEntity;
      return authGuard(MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: getIt<CartCubit>(),
          child: CheckOutView(cartEntity: cartEntity),
        ),
      ));

    case AppRoutes.uploadPrescription:
      return authGuard(MaterialPageRoute(
        builder: (_) => MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => getIt<PrescriptionCubit>()),
            BlocProvider.value(value: getIt<CartCubit>()),
          ],
          child: const UploadPrescriptionView(),
        ),
      ));

    case AppRoutes.ChatbootBody:
      return MaterialPageRoute(builder: (_) => const ChatbootBody());

    case AppRoutes.alarmsMain:
      return authGuard(MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: getIt<AlarmsCubit>(),
          child: const MainAlarmsView(),
        ),
      ));

    case AppRoutes.addAlarm:
      return authGuard(MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: getIt<AlarmsCubit>(),
          child: const AddAlarmView(),
        ),
      ));

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
          create: (context) => SugnupCubit(getIt<AuthRepo>()),
          child: const Signup(),
        ),
      );

    case AppRoutes.notificationsView:
      return authGuard(MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: getIt<OrdersCubit>(),
          child: const NotificationsView(),
        ),
      ));

    case AppRoutes.orderDetailsView:
      final order = settings.arguments as OrderModel;
      return authGuard(MaterialPageRoute(
        builder: (_) => MultiBlocProvider(
          providers: [
            BlocProvider.value(value: getIt<OrdersCubit>()),
            BlocProvider.value(value: getIt<CartCubit>()),
          ],
          child: OrderDetailsView(order: order),
        ),
      ));

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