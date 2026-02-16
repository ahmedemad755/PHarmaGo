import 'package:flutter/material.dart';

class NotifecationWidgets extends StatelessWidget {
  const NotifecationWidgets({
    super.key,
    this.onTap,
    this.notificationCount = 0, // إضافة عداد الإشعارات
    this.iconColor = Colors.black,
    this.backgroundColor = const Color(0xFFEEF8ED),
  });

  final VoidCallback? onTap;
  final int notificationCount; // الرقم اللي هيظهر
  final Color iconColor;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: backgroundColor,
            ),
            child: Icon(
              Icons.notifications_outlined,
              color: iconColor,
              size: 24,
            ),
          ),
          
          // عرض الدائرة الحمراء والرقم فقط إذا كان العدد أكبر من 0
          if (notificationCount > 0)
            Positioned(
              right: -2, // تحريكها قليلاً للخارج لتظهر بوضوح
              top: -2,
              child: Container(
                padding: const EdgeInsets.all(4), // مساحة حول الرقم
                constraints: const BoxConstraints(
                  minWidth: 18,
                  minHeight: 18,
                ),
                decoration: BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 1.5),
                ),
                child: Center(
                  child: Text(
                    // لو الرقم أكبر من 9 ظهر +9 عشان الشكل ميبوظش
                    notificationCount > 9 ? '+9' : notificationCount.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}