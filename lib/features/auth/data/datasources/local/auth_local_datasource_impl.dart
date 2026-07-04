import 'dart:convert';

import 'package:e_commerce/core/services/preferences/shared_prefs_service.dart';
import 'package:e_commerce/Features/auth/data/datasources/local/auth_local_datasource.dart';
import 'package:e_commerce/Features/auth/data/datasources/local/cache_keys.dart';
import 'package:e_commerce/Features/auth/data/models/user_model.dart';

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  @override
  Future<void> cacheUser(UserModel user) async {
    await Prefs.setString(CacheKeys.cachedUser, jsonEncode(user.toJson()));
  }

  @override
  Future<UserModel?> getCachedUser() async {
    final jsonString = Prefs.getString(CacheKeys.cachedUser);
    if (jsonString.isEmpty) return null;

    return UserModel.fromJson(jsonDecode(jsonString));
  }

  @override
  Future<void> clearCachedUser() async {
    await Prefs.remove(CacheKeys.cachedUser);
  }

  @override
  Future<bool> hasCachedUser() async {
    return Prefs.containsKey(CacheKeys.cachedUser);
  }
}
