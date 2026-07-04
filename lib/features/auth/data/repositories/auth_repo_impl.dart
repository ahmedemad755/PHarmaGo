import 'dart:developer' as developer;

import 'package:dartz/dartz.dart';
import 'package:e_commerce/core/errors/exceptions.dart';
import 'package:e_commerce/core/errors/faliur.dart';
import 'package:e_commerce/core/services/database/database_service.dart';
import 'package:e_commerce/core/utils/backend_points.dart';
import 'package:e_commerce/Features/auth/data/datasources/local/auth_local_datasource.dart';
import 'package:e_commerce/Features/auth/data/datasources/remote/auth_remote_datasource.dart';
import 'package:e_commerce/Features/auth/data/models/user_model.dart';
import 'package:e_commerce/Features/auth/domain/entites/user_entity.dart';
import 'package:e_commerce/Features/auth/domain/repositories/auth_repo.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthRepoImpl extends AuthRepo {
  AuthRepoImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.databaseService,
  });

  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;
  final DatabaseService databaseService;

  // ---------------------------------------------------------------------
  // Shared error handling — every public method funnels through here so no
  // method has to hand-roll its own try/catch/log/map-to-Faliur boilerplate.
  // ---------------------------------------------------------------------
  Future<Either<Faliur, T>> _guard<T>(
    Future<T> Function() action, {
    Future<void> Function()? onError,
  }) async {
    try {
      return Right(await action());
    } on CustomException catch (e) {
      await onError?.call();
      developer.log('CustomException: ${e.message}', name: 'AuthRepoImpl');
      return Left(ServerFaliur(e.message));
    } catch (e) {
      await onError?.call();
      developer.log('Unexpected error: $e', name: 'AuthRepoImpl');
      return Left(ServerFaliur('حدث خطأ ما. الرجاء المحاولة مرة أخرى.'));
    }
  }

  // ---------------------------------------------------------------------
  // Firestore + local cache plumbing shared by login/signup/googleLogin.
  // ---------------------------------------------------------------------
  Future<UserModel> _fetchProfile(String uid) async {
    final data = await databaseService.getData(
      path: BackendPoints.getUserData,
      docuementId: uid,
    );
    if (data.isEmpty) {
      throw CustomException(message: 'لم يتم العثور على بيانات المستخدم.');
    }
    return UserModel.fromJson(data[0]);
  }

  Future<void> _saveProfile(UserEntity user, {required bool useSet}) async {
    final data = UserModel.fromEntity(user).toMap();
    if (useSet) {
      await databaseService.setData(
        path: BackendPoints.addUserData,
        id: user.uId,
        data: data,
      );
    } else {
      await databaseService.addData(
        path: BackendPoints.addUserData,
        data: data,
        documentId: user.uId,
      );
    }
  }

  Future<void> _cacheUser(UserEntity user) {
    return localDataSource.cacheUser(UserModel.fromEntity(user));
  }

  // ---------------------------------------------------------------------
  // Phase 2 — login / signup / googleLogin
  // ---------------------------------------------------------------------
  @override
  Future<Either<Faliur, UserEntity>> login({
    required String email,
    required String password,
  }) {
    return _guard(() async {
      final user = await remoteDataSource.login(email: email, password: password);
      final profile = await _fetchProfile(user.uid);
      await _cacheUser(profile);
      return profile;
    });
  }

  @override
  Future<Either<Faliur, UserEntity>> signup({
    required String email,
    required String password,
    required String name,
    required String address,
    required double lat,
    required double lng,
  }) {
    User? createdUser;
    return _guard(
      () async {
        createdUser = await remoteDataSource.createUser(
          email: email,
          password: password,
        );
        final profile = UserEntity(
          email: email,
          name: name,
          uId: createdUser!.uid,
          address: address,
          lat: lat,
          lng: lng,
        );
        await _saveProfile(profile, useSet: false);
        await _cacheUser(profile);
        return profile;
      },
      onError: () async {
        if (createdUser != null) await remoteDataSource.deleteCurrentUser();
      },
    );
  }

  @override
  Future<Either<Faliur, UserEntity>> googleLogin() {
    User? user;
    return _guard(
      () async {
        final credential = await remoteDataSource.signInWithGoogle();
        user = credential.user!;

        final alreadyRegistered = await databaseService.checkIfDataExists(
          documentId: user!.uid,
          path: BackendPoints.isUserexist,
        );

        final UserEntity profile;
        if (alreadyRegistered) {
          profile = await _fetchProfile(user!.uid);
        } else {
          profile = UserModel.fromfirebaseUser(user!);
          await _saveProfile(profile, useSet: true);
        }

        await _cacheUser(profile);
        return profile;
      },
      onError: () async {
        if (user != null) await remoteDataSource.deleteCurrentUser();
      },
    );
  }

  // ---------------------------------------------------------------------
  // Phase 3 — logout / deleteAccount / resetPassword
  // ---------------------------------------------------------------------
  @override
  Future<Either<Faliur, void>> logout() {
    return _guard(() async {
      await remoteDataSource.logout();
      await localDataSource.clearCachedUser();
    });
  }

  @override
  Future<Either<Faliur, void>> deleteAccount({String? storedPassword}) {
    return _guard(() async {
      await remoteDataSource.deleteCurrentUserWithReauthentication(
        storedPassword: storedPassword,
      );
      await localDataSource.clearCachedUser();
    });
  }

  @override
  Future<Either<Faliur, void>> resetPassword({required String email}) {
    return _guard(() => remoteDataSource.sendPasswordResetEmail(email: email));
  }

  // ---------------------------------------------------------------------
  // Phase 4 — phone/OTP/email verification, current user, email existence
  // ---------------------------------------------------------------------
  @override
  Future<void> verifyPhoneNumber({
    required String phoneNumber,
    required void Function(String verificationId) onCodeSent,
    required void Function(FirebaseAuthException error) onVerificationFailed,
    required void Function(PhoneAuthCredential credential)
    onVerificationCompleted,
    required void Function(String verificationId) onAutoRetrievalTimeout,
  }) {
    return remoteDataSource.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      onCodeSent: onCodeSent,
      onVerificationFailed: onVerificationFailed,
      onVerificationCompleted: onVerificationCompleted,
      onAutoRetrievalTimeout: onAutoRetrievalTimeout,
    );
  }

  @override
  Future<Either<Faliur, UserCredential>> verifyOtp({
    required String verificationId,
    required String smsCode,
  }) {
    return _guard(
      () => remoteDataSource.verifySmsCode(
        verificationId: verificationId,
        smsCode: smsCode,
      ),
    );
  }

  @override
  Future<Either<Faliur, void>> sendEmailVerification() {
    return _guard(() => remoteDataSource.sendEmailVerification());
  }

  @override
  Future<Either<Faliur, UserEntity?>> getCurrentUser() {
    return _guard(() async {
      final cached = await localDataSource.getCachedUser();
      if (cached != null) return cached;

      final firebaseUser = remoteDataSource.currentUser;
      if (firebaseUser == null) return null;

      final profile = await _fetchProfile(firebaseUser.uid);
      await _cacheUser(profile);
      return profile;
    });
  }

  @override
  Future<Either<Faliur, bool>> checkEmailExists({required String email}) {
    return _guard(
      () => databaseService.checkIfFieldExists(
        path: BackendPoints.isUserexist,
        field: 'email',
        value: email,
      ),
    );
  }
}
