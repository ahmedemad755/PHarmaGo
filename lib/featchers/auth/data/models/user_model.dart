import 'package:e_commerce/featchers/AUTH/domain/entites/user_entity.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserModel extends UserEntity {
  UserModel({
    required super.email,
    required super.name,
    required super.uId,
    required super.address,
    required super.lat,
    required super.lng,
  });

  // من Firebase User (للتسجيل لأول مرة)
  factory UserModel.fromfirebaseUser(User user) {
    return UserModel(
      email: user.email ?? "",
      name: user.displayName ?? '',
      uId: user.uid,
      address: '',
      lat: 0.0,
      lng: 0.0,
    );
  }

  // من Map (Firestore) - مع معالجة الأنواع الرقمية بدقة
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      email: json['email']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      uId: json['uId']?.toString() ?? '',
      address: json['address']?.toString() ?? '',
      // حماية من تعارض الأنواع (int vs double)
      lat: (json['lat'] as num?)?.toDouble() ?? 0.0,
      lng: (json['lng'] as num?)?.toDouble() ?? 0.0,
    );
  }

  // من Entity لـ Model
  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      uId: entity.uId,
      email: entity.email,
      name: entity.name,
      address: entity.address,
      lat: entity.lat,
      lng: entity.lng,
    );
  }

  // تحويل لـ Map للحفظ في Firestore
  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'name': name,
      'uId': uId,
      'address': address,
      'lat': lat,
      'lng': lng,
    };
  }
}
