import 'dart:convert';
import 'package:e_commerce/constants.dart';
import 'package:e_commerce/core/services/shared_prefs_singelton.dart';
import 'package:e_commerce/featchers/auth/data/models/user_model.dart';

UserModel getUser() {
  var jsonString = Prefs.getString(kUserData);

  // التأكد من أن النص ليس فارغاً وليس null قبل فك التشفير
  if (jsonString != null && jsonString.isNotEmpty) {
    try {
      var userMap = jsonDecode(jsonString);
      return UserModel.fromJson(userMap);
    } catch (e) {
      // في حال وجود خطأ في صيغة الـ JSON نفسه
      print("Error decoding user data: $e");
    }
  }

  // إرجاع كائن افتراضي أو فارغ لتجنب توقف التطبيق (Crash)
  return UserModel(
    name: '',
    email: '',
    uId: '',
  );
}