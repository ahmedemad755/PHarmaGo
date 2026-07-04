
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce/core/drug_engine/services/drug_firestore_service.dart';
import 'package:e_commerce/Features/products/presentation/cubit/products_cubit.dart';
import 'package:e_commerce/core/repos/banner_repo/banners_repo.dart';
import 'package:e_commerce/core/repos/banner_repo/banners_repo_imp.dart';
import 'package:e_commerce/core/repos/cart_repo/cart_repo.dart';
import 'package:e_commerce/core/repos/cart_repo/cart_repo_impl.dart';
import 'package:e_commerce/core/repos/order_repo/orders_repo.dart';
import 'package:e_commerce/core/repos/order_repo/orders_repo_impl.dart';
import 'package:e_commerce/core/repos/pripresetion_repo/prescription_repo.dart';
import 'package:e_commerce/Features/products/data/datasource/remote/products_remote_datasource.dart';
import 'package:e_commerce/Features/products/data/datasource/remote/products_remote_datasource_impl.dart';
import 'package:e_commerce/Features/products/domain/repositories/products_repo.dart';
import 'package:e_commerce/Features/products/data/repositories/products_repo_impl.dart';
import 'package:e_commerce/Features/products/domain/usecases/get_best_selling_products_usecase.dart';
import 'package:e_commerce/Features/products/domain/usecases/get_products_usecase.dart';
import 'package:e_commerce/core/services/auth/account_service.dart';
import 'package:e_commerce/core/services/auth/google_auth_service.dart';
import 'package:e_commerce/core/services/auth/phone_auth_service.dart';
import 'package:e_commerce/core/services/database/cloud_fire_store_service.dart';
import 'package:e_commerce/core/services/database/database_service.dart';
import 'package:e_commerce/core/services/storage/storage_service.dart';
import 'package:e_commerce/core/services/storage/supabase_storage_service.dart';
import 'package:e_commerce/Features/alarm/cubits/alarm/alarm_cubit.dart';
import 'package:e_commerce/Features/auth/data/datasources/local/auth_local_datasource.dart';
import 'package:e_commerce/Features/auth/data/datasources/local/auth_local_datasource_impl.dart';
import 'package:e_commerce/Features/auth/data/datasources/remote/auth_remote_datasource.dart';
import 'package:e_commerce/Features/auth/data/datasources/remote/auth_remote_datasource_impl.dart';
import 'package:e_commerce/Features/auth/data/repositories/auth_repo_impl.dart';
import 'package:e_commerce/Features/auth/domain/repositories/auth_repo.dart';
import 'package:e_commerce/Features/auth/domain/usecases/check_email_exists_usecase.dart';
import 'package:e_commerce/Features/auth/domain/usecases/delete_account_usecase.dart';
import 'package:e_commerce/Features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:e_commerce/Features/auth/domain/usecases/google_login_usecase.dart';
import 'package:e_commerce/Features/auth/domain/usecases/login_usecase.dart';
import 'package:e_commerce/Features/auth/domain/usecases/logout_usecase.dart';
import 'package:e_commerce/Features/auth/domain/usecases/reset_password_usecase.dart';
import 'package:e_commerce/Features/auth/domain/usecases/send_email_verification_usecase.dart';
import 'package:e_commerce/Features/auth/domain/usecases/signup_usecase.dart';
import 'package:e_commerce/Features/auth/domain/usecases/verify_otp_usecase.dart';
import 'package:e_commerce/Features/auth/domain/usecases/verify_phone_usecase.dart';
import 'package:e_commerce/Features/auth/presentation/cubits/login/login_cubit.dart';
import 'package:e_commerce/Features/auth/presentation/cubits/signup/sugnup_cubit.dart';
import 'package:e_commerce/Features/auth/presentation/cubits/vereficationotp/vereficationotp_cubit.dart';
import 'package:e_commerce/Features/cart/domain/enteties/cart_entety.dart';
import 'package:e_commerce/Features/cart/presentation/cubits/cart_cubit/cart_cubit.dart';
import 'package:e_commerce/Features/chatbot/presentation/cubit/chat_cubit.dart';
import 'package:e_commerce/Features/home/presentation/cubits/banners/banner_cubit.dart';
import 'package:e_commerce/Features/orders/presentation/cubits/myOrders/my_orders_cubit.dart';
import 'package:e_commerce/Features/prescription/presentation/cubits/prescription/prescription_cubit.dart';
import 'package:get_it/get_it.dart';


final getIt = GetIt.instance;

Future<void> setupGetit() async {
  // 1. الأساسيات والخدمات (Services)
  getIt.registerLazySingleton<GoogleAuthService>(() => GoogleAuthService());
  getIt.registerLazySingleton<PhoneAuthService>(() => PhoneAuthService());
  getIt.registerLazySingleton<AccountService>(
    () => AccountService(getIt<GoogleAuthService>()),
  );
  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(
      googleAuthService: getIt<GoogleAuthService>(),
      phoneAuthService: getIt<PhoneAuthService>(),
      accountService: getIt<AccountService>(),
    ),
  );
  getIt.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(),
  );

  final fireStoreService = FireStoreService();
  getIt.registerSingleton<FireStoreService>(fireStoreService);
  getIt.registerSingleton<DatabaseService>(fireStoreService);
  // getIt.registerSingleton<GeminiService>(GeminiService());
  // تسجيل خدمة التخزين (Supabase)
  getIt.registerSingleton<StorgeService>(SupabaseStorgeService());

  // 2. المستودعات (Repositories)
  getIt.registerSingleton<AuthRepo>(
    AuthRepoImpl(
      remoteDataSource: getIt<AuthRemoteDataSource>(),
      localDataSource: getIt<AuthLocalDataSource>(),
      databaseService: getIt<DatabaseService>(),
    ),
  );

  // 2.1 حالات الاستخدام (UseCases) — كل واحدة Wrapper رفيع فوق AuthRepo
  getIt.registerLazySingleton<LoginUseCase>(() => LoginUseCase(getIt<AuthRepo>()));
  getIt.registerLazySingleton<SignupUseCase>(
    () => SignupUseCase(getIt<AuthRepo>()),
  );
  getIt.registerLazySingleton<GoogleLoginUseCase>(
    () => GoogleLoginUseCase(getIt<AuthRepo>()),
  );
  getIt.registerLazySingleton<LogoutUseCase>(
    () => LogoutUseCase(getIt<AuthRepo>()),
  );
  getIt.registerLazySingleton<VerifyPhoneUseCase>(
    () => VerifyPhoneUseCase(getIt<AuthRepo>()),
  );
  getIt.registerLazySingleton<VerifyOtpUseCase>(
    () => VerifyOtpUseCase(getIt<AuthRepo>()),
  );
  getIt.registerLazySingleton<ResetPasswordUseCase>(
    () => ResetPasswordUseCase(getIt<AuthRepo>()),
  );
  getIt.registerLazySingleton<DeleteAccountUseCase>(
    () => DeleteAccountUseCase(getIt<AuthRepo>()),
  );
  getIt.registerLazySingleton<CheckEmailExistsUseCase>(
    () => CheckEmailExistsUseCase(getIt<AuthRepo>()),
  );
  getIt.registerLazySingleton<GetCurrentUserUseCase>(
    () => GetCurrentUserUseCase(getIt<AuthRepo>()),
  );
  getIt.registerLazySingleton<SendEmailVerificationUseCase>(
    () => SendEmailVerificationUseCase(getIt<AuthRepo>()),
  );

  getIt.registerLazySingleton<ProductsRemoteDataSource>(
    () => ProductsRemoteDataSourceImpl(getIt<DatabaseService>()),
  );
  getIt.registerSingleton<ProductsRepo>(
    ProductsRepoImpl(getIt<ProductsRemoteDataSource>()),
  );
  getIt.registerLazySingleton(
    () => GetProductsUseCase(getIt<ProductsRepo>()),
  );
  getIt.registerLazySingleton(
    () => GetBestSellingProductsUseCase(getIt<ProductsRepo>()),
  );

  // تحديث OrdersRepo ليدعم خدمة التخزين لرفع الروشتات
  getIt.registerSingleton<OrdersRepo>(
    OrdersRepoImpl(getIt<DatabaseService>(), getIt<StorgeService>()),
  );

  getIt.registerSingleton<CartRepo>(CartRepoImpl());

  // getIt.registerSingleton<PrescriptionRepo>(
  //   PrescriptionRepoImpl(getIt<GeminiService>()),
  // );

  getIt.registerLazySingleton<BannersRepo>(
    () => BannersRepoImpl(databaseService: getIt<DatabaseService>()),
  );

  // 3. الكيوبيتات (Cubits)
  getIt.registerSingleton<AuthRepoImpl>(getIt<AuthRepo>() as AuthRepoImpl);
  getIt.registerFactory<SugnupCubit>(
    () => SugnupCubit(
      signupUseCase: getIt<SignupUseCase>(),
      checkEmailExistsUseCase: getIt<CheckEmailExistsUseCase>(),
    ),
  );
  getIt.registerSingleton<LoginCubit>(
    LoginCubit(
      loginUseCase: getIt<LoginUseCase>(),
      googleLoginUseCase: getIt<GoogleLoginUseCase>(),
      logoutUseCase: getIt<LogoutUseCase>(),
    ),
  );
  getIt.registerFactory<OTPCubit>(
    () => OTPCubit(
      verifyPhoneUseCase: getIt<VerifyPhoneUseCase>(),
      verifyOtpUseCase: getIt<VerifyOtpUseCase>(),
    ),
  );

  getIt.registerSingleton<CartEntity>(CartEntity([]));
  getIt.registerSingleton<CartCubit>(
    CartCubit(getIt<CartEntity>(), getIt<CartRepo>()),
  );

  getIt.registerFactory<ProductsCubit>(
    () => ProductsCubit(
      getProductsUseCase: getIt<GetProductsUseCase>(),
      getBestSellingProductsUseCase: getIt<GetBestSellingProductsUseCase>(),
    ),
  );

  getIt.registerFactory<PrescriptionCubit>(
    () => PrescriptionCubit(getIt<PrescriptionRepo>()),
  );

  getIt.registerSingleton<OrdersCubit>(OrdersCubit(getIt<OrdersRepo>()));

  getIt.registerFactory<BannersCubit>(() => BannersCubit(getIt<BannersRepo>()));

  // داخل ملف injection.dart أو الـ Setup الخاص بالـ DI
  getIt.registerLazySingleton<AlarmsCubit>(() => AlarmsCubit());
  // داخل دالة إعداد الـ GetIt (مثلاً setupServiceLocator)

  getIt.registerLazySingleton(() => FirebaseFirestore.instance);

  // Drug Service
  getIt.registerLazySingleton(
    () => DrugFirestoreService(getIt<FirebaseFirestore>()),
  );

  // Chat Cubit
  getIt.registerFactory(() => ChatCubit(getIt<DrugFirestoreService>()));

  // // 1. Services
  //   getIt.registerLazySingleton<PlacesWebservices>(() => PlacesWebservices());

  //   // 2. Repositories
  //   getIt.registerLazySingleton<MapsRepository>(
  //     () => MapsRepository(getIt<PlacesWebservices>()),
  //   );

  //   // 3. Cubits
  //   getIt.registerFactory<MapsCubit>(
  //     () => MapsCubit(getIt<MapsRepository>()),
  //   );
}
