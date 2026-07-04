import 'package:e_commerce/Features/auth/data/models/user_model.dart';

abstract class AuthLocalDataSource {
  Future<void> cacheUser(UserModel user);

  Future<UserModel?> getCachedUser();

  Future<void> clearCachedUser();

  Future<bool> hasCachedUser();
}
