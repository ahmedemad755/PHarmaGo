class CacheKeys {
  // Same physical SharedPreferences key as the legacy `kUserData` constant
  // (lib/constants.dart), still read by lib/core/functions_helper/get_user_data.dart
  // and lib/featchers/profile/presentation/widgets/ProfileBody.dart.
  // Keep the value in sync until those call sites are migrated to this class.
  static const cachedUser = 'userData';
}
