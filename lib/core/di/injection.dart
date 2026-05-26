import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce/core/drug_engine/services/drug_firestore_service.dart';
import 'package:e_commerce/core/products_cubit/products_cubit.dart';
import 'package:e_commerce/core/repos/banner_repo/banners_repo.dart';
import 'package:e_commerce/core/repos/banner_repo/banners_repo_imp.dart';
import 'package:e_commerce/core/repos/cart_repo/cart_repo.dart';
import 'package:e_commerce/core/repos/cart_repo/cart_repo_impl.dart';
import 'package:e_commerce/core/repos/order_repo/orders_repo.dart';
import 'package:e_commerce/core/repos/order_repo/orders_repo_impl.dart';
import 'package:e_commerce/core/repos/pripresetion_repo/prescription_repo.dart';
import 'package:e_commerce/core/repos/products_repo/products_repo.dart';
import 'package:e_commerce/core/repos/products_repo/products_repo_impl.dart';
import 'package:e_commerce/core/services/cloud_fire_store_service.dart';
import 'package:e_commerce/core/services/database_service.dart';
import 'package:e_commerce/core/services/firebase_auth_service.dart';
import 'package:e_commerce/core/services/storge_service.dart'; // تأكد من المسار الصحيح
import 'package:e_commerce/core/services/supabase_storge.dart';
import 'package:e_commerce/featchers/AUTH/data/repos/auth_repo.dart';
import 'package:e_commerce/featchers/AUTH/data/repos/auth_repo_impl.dart';
import 'package:e_commerce/featchers/AUTH/presentation/cubits/login/login_cubit.dart';
import 'package:e_commerce/featchers/AUTH/presentation/cubits/signup/sugnup_cubit.dart';
import 'package:e_commerce/featchers/AUTH/presentation/cubits/vereficationotp/vereficationotp_cubit.dart';
import 'package:e_commerce/featchers/alarm/cubits/alarm/alarm_cubit.dart';
import 'package:e_commerce/featchers/chatbot/data/datasource/anthropic_datasource.dart';
import 'package:e_commerce/featchers/chatbot/data/repos/chat_repo_impl.dart';
import 'package:e_commerce/featchers/chatbot/domain/repos/chat_repo.dart';
import 'package:e_commerce/featchers/chatbot/domain/usecases/send_message.dart';
import 'package:e_commerce/featchers/chatbot/presentation/cubit/chat_cubit.dart';
import 'package:e_commerce/featchers/home/domain/enteties/cart_entety.dart'
    show CartEntity;
import 'package:e_commerce/featchers/home/presentation/cubits/banners/banner_cubit.dart';
import 'package:e_commerce/featchers/home/presentation/cubits/cart_cubit/cart_cubit.dart';
import 'package:e_commerce/featchers/home/presentation/cubits/myOrders/my_orders_cubit.dart';
import 'package:e_commerce/featchers/home/presentation/cubits/prescription/prescription_cubit.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

Future<void> setupGetit() async {
  // 1. الأساسيات والخدمات (Services)
  getIt.registerSingleton<FirebaseAuthService>(FirebaseAuthService());

  final fireStoreService = FireStoreService();
  getIt.registerSingleton<FireStoreService>(fireStoreService);
  getIt.registerSingleton<DatabaseService>(fireStoreService);
  // getIt.registerSingleton<GeminiService>(GeminiService());

  // تسجيل خدمة التخزين (Supabase)
  getIt.registerSingleton<StorgeService>(SupabaseStorgeService());

  // 2. المستودعات (Repositories)
  getIt.registerSingleton<AuthRepo>(
    AuthRepoImpl(
      firebaseAuthService: getIt<FirebaseAuthService>(),
      databaseservice: getIt<DatabaseService>(),
      fireStoreService: getIt<FireStoreService>(),
    ),
  );

  getIt.registerSingleton<ProductsRepo>(
    ProductsRepoImpl(getIt<DatabaseService>()),
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
  getIt.registerFactory<SugnupCubit>(() => SugnupCubit(getIt()));
  getIt.registerSingleton<LoginCubit>(LoginCubit(getIt()));
  getIt.registerFactory<OTPCubit>(() => OTPCubit(getIt<AuthRepo>()));

  getIt.registerSingleton<CartEntity>(CartEntity([]));
  getIt.registerSingleton<CartCubit>(
    CartCubit(getIt<CartEntity>(), getIt<CartRepo>()),
  );

  getIt.registerFactory<ProductsCubit>(
    () => ProductsCubit(getIt<ProductsRepo>()),
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


getIt.registerLazySingleton<AnthropicDataSource>(
  () => AnthropicDataSource(
    const String.fromEnvironment('ANTHROPIC_API_KEY'), // 👈 هنا بنقول للكومبايلر اقرأ المتغير اللي اسمه كده من البيئة
  ),
);

  getIt.registerLazySingleton<ChatRepo>(
    () => ChatRepoImpl(
      anthropicDataSource: getIt<AnthropicDataSource>(),
      firestoreService: getIt<DrugFirestoreService>(),
    ),
  );

  getIt.registerLazySingleton<SendMessage>(
    () => SendMessage(getIt<ChatRepo>()),
  );

  getIt.registerFactory<ChatCubit>(
    () => ChatCubit(getIt<SendMessage>()),
  );
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