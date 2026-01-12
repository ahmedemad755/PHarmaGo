import 'package:e_commerce/core/products_cubit/products_cubit.dart';
import 'package:e_commerce/core/repos/cart_repo/cart_repo.dart';
import 'package:e_commerce/core/repos/cart_repo/cart_repo_impl.dart';
import 'package:e_commerce/core/repos/order_repo/orders_repo.dart';
import 'package:e_commerce/core/repos/order_repo/orders_repo_impl.dart';
import 'package:e_commerce/core/repos/products_repo/products_repo.dart';
import 'package:e_commerce/core/repos/products_repo/products_repo_impl.dart';
import 'package:e_commerce/core/services/cloud_fire_store_service.dart';
import 'package:e_commerce/core/services/database_service.dart';
import 'package:e_commerce/core/services/firebase_auth_service.dart';
import 'package:e_commerce/featchers/AUTH/data/repos/auth_repo.dart';
import 'package:e_commerce/featchers/AUTH/data/repos/auth_repo_impl.dart';
import 'package:e_commerce/featchers/AUTH/presentation/cubits/login/login_cubit.dart';
import 'package:e_commerce/featchers/AUTH/presentation/cubits/signup/sugnup_cubit.dart';
import 'package:e_commerce/featchers/AUTH/presentation/cubits/vereficationotp/vereficationotp_cubit.dart';
import 'package:e_commerce/featchers/home/domain/enteties/cart_entety.dart'
    show CartEntity;
import 'package:e_commerce/featchers/home/presentation/cubits/curt_cubit/cart_cubit.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void setupGetit() {
  getIt.registerSingleton<FirebaseAuthService>(FirebaseAuthService());

  final fireStoreService = FireStoreService();
  getIt.registerSingleton<FireStoreService>(fireStoreService);
  getIt.registerSingleton<DatabaseService>(fireStoreService);

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

  getIt.registerSingleton<AuthRepoImpl>(getIt<AuthRepo>() as AuthRepoImpl);
  getIt.registerFactory<SugnupCubit>(() => SugnupCubit(getIt()));
  getIt.registerSingleton<LoginCubit>(LoginCubit(getIt()));
  getIt.registerFactory<OTPCubit>(() => OTPCubit(getIt<AuthRepo>()));
  getIt.registerSingleton<OrdersRepo>(OrdersRepoImpl(getIt<DatabaseService>()));

  getIt.registerSingleton<CartRepo>(CartRepoImpl());
  getIt.registerLazySingleton<CartEntity>(() => CartEntity([]));

  getIt.registerLazySingleton<CartCubit>(
    () => CartCubit(getIt<CartEntity>(), getIt<CartRepo>()),
  );

  getIt.registerFactory<ProductsCubit>(
    () => ProductsCubit(getIt<ProductsRepo>()),
  );
}
