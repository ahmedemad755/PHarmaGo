import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce/constants.dart';
import 'package:e_commerce/core/functions_helper/get_user_data.dart';
import 'package:e_commerce/core/functions_helper/routs.dart';
import 'package:e_commerce/core/services/preferences/shared_prefs_service.dart';
import 'package:e_commerce/core/utils/app_colors.dart';
import 'package:e_commerce/core/utils/backend_points.dart';
import 'package:e_commerce/Features/auth/data/models/user_model.dart';
import 'package:e_commerce/Features/auth/presentation/cubits/login/login_cubit.dart';
import 'package:e_commerce/Features/auth/presentation/cubits/login/login_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
// مهم جداً للوصول لـ navigatorKey
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFF4A90E2);
  static const Color accentColor = Color(0xFF50E3C2);
  static const Color backgroundColor = Color(0xFFF5F5F5);
  static const Color cardColor = Colors.white;
  static const Color textColor = Color(0xFF333333);
}

class ProfileBody extends StatelessWidget {
  const ProfileBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state is LogoutSuccess) {
          // استخدم pushNamedAndRemoveUntil لضمان مسح كل الصفحات القديمة
          Navigator.pushNamedAndRemoveUntil(
            context,
            AppRoutes.login,
            (route) => false,
          );
        }
      },
      // أضف buildWhen لمنع إعادة البناء عند تسجيل الخروج
      buildWhen: (previous, current) =>
          current is! LogoutSuccess && current is! LogoutLoading,
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppTheme.backgroundColor,
          appBar: AppBar(
            toolbarHeight: 0,
            elevation: 0,
            backgroundColor: Colors.transparent,
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                _buildHeader(context),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      _buildSectionTitle("عام"),
                      _buildOptionCard([
                        _ProfileOption(
                          icon: Icons.notifications_none,
                          title: "الإشعارات",
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              AppRoutes.notificationsView,
                            );
                          },
                        ),
                        _ProfileOption(
                          icon: Icons.shopping_bag_outlined,
                          title: "طلباتي",
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              AppRoutes.myordersView,
                            );
                          },
                        ),
                        _ProfileOption(
                          icon: Icons.language,
                          title: "تغيير اللغة",
                          onTap: () {},
                        ),

                        _ProfileOption(
                          icon: Icons.location_on_outlined,
                          title: "تغيير عنوان التوصيل",
                          onTap: () async {
                            // 1. فتح الخريطة واستقبال الإحداثيات الجديدة
                            final result = await Navigator.pushNamed(
                              context,
                              AppRoutes.mapScreen,
                            );

                            if (result != null &&
                                result is Map<String, dynamic>) {
                              // 2. تحديث البيانات في الفايربيز (نحتاج ميثود في الكيوبت أو ميثود سريعة)
                              _updateUserLocation(context, result);
                            }
                          },
                        ),
                        _ProfileOption(
                          icon: Icons.security,
                          title: "الأمان والخصوصية",
                          onTap: () {},
                        ),
                      ]),
                      const SizedBox(height: 20),
                      _buildSectionTitle("الدعم والمساعدة"),
                      _buildOptionCard([
                        _ProfileOption(
                          icon: Icons.help_outline,
                          title: "مركز المساعدة",
                          onTap: () {},
                        ),
                        _ProfileOption(
                          icon: Icons.info_outline,
                          title: "حول التطبيق",
                          onTap: () {},
                        ),
                      ]),
                      const SizedBox(height: 30),
                      _buildLogoutButton(context, state),
                      const SizedBox(height: 120),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.grey.shade700,
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(bottom: 24, top: 40, left: 24, right: 24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [
            AppColors.primaryDark,
            AppColors.primaryMid,
            AppColors.primaryLight,
          ],
          stops: const [0.0, 0.5, 1.0],
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "الملف الشخصي",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.settings_outlined, color: Colors.white),
                onPressed: () {},
              ),
            ],
          ),
          const SizedBox(height: 30),
          Text(
            getUser().name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            getUser().email,
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionCard(List<_ProfileOption> options) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: options.length,
        separatorBuilder: (_, __) => const Divider(height: 0, indent: 60),
        itemBuilder: (context, index) {
          final option = options[index];
          return ListTile(
            leading: Icon(option.icon, color: AppTheme.primaryColor),
            title: Text(
              option.title,
              style: const TextStyle(
                color: AppTheme.textColor,
                fontWeight: FontWeight.w500,
              ),
            ),
            trailing: const Icon(
              Icons.arrow_forward_ios,
              size: 18,
              color: Colors.grey,
            ),
            onTap: option.onTap,
          );
        },
      ),
    );
  }

  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Text("تسجيل الخروج", textAlign: TextAlign.right),
        content: const Text("هل أنت متأكد؟", textAlign: TextAlign.right),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text("إلغاء"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              Navigator.of(dialogContext, rootNavigator: true).pop();
              // استخدام addPostFrameCallback يحل مشكلة Dirty Widget
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (context.mounted) {
                  context.read<LoginCubit>().logout();
                }
              });
            },
            child: const Text("خروج", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context, LoginState state) {
    return Center(
      child: state is LogoutLoading
          ? const CircularProgressIndicator(color: Colors.red)
          : Builder(
              builder: (buttonContext) => ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 15,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () => _showLogoutConfirmation(buttonContext),
                icon: const Icon(Icons.logout),
                label: const Text("تسجيل الخروج الآن"),
              ),
            ),
    );
  }

  Future<void> _updateUserLocation(
    BuildContext context,
    Map<String, dynamic> locationData,
  ) async {
    final uId = getUser().uId; // هنجيب الـ ID من Helper اللي عندك

    final authUId = FirebaseAuth.instance.currentUser?.uid;
    final documentId = authUId?.isNotEmpty == true ? authUId! : uId;
    final address = locationData['address']?.toString() ?? '';
    final lat = (locationData['lat'] as num?)?.toDouble() ?? 0.0;
    final lng = (locationData['lng'] as num?)?.toDouble() ?? 0.0;

    if (documentId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تعذر تحديد المستخدم الحالي')),
      );
      return;
    }

    try {
      await FirebaseFirestore.instance
          .collection(BackendPoints.addUserData)
          .doc(documentId)
          .set({
            'address': address,
            'lat': lat,
            'lng': lng,
            'uId': documentId,
          }, SetOptions(merge: true));

      final currentUser = getUser();
      final updatedUser = UserModel(
        email: currentUser.email,
        name: currentUser.name,
        uId: documentId,
        address: address,
        lat: lat,
        lng: lng,
      );

      await Prefs.setString(kUserData, jsonEncode(updatedUser.toMap()));

      // تنبيه المستخدم
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم تحديث عنوانك المفضل بنجاح')),
      );

      // يفضل تعمل Re-fetch لبيانات المستخدم عشان الـ Header يتحدث
    } catch (e) {
      debugPrint("Update Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تعذر تحديث العنوان، حاول مرة أخرى')),
      );
    }
  }
}

class _ProfileOption {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  _ProfileOption({
    required this.icon,
    required this.title,
    required this.onTap,
  });
}
