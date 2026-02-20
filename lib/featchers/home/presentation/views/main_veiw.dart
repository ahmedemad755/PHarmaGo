import 'package:e_commerce/featchers/AUTH/data/repos/auth_repo_impl.dart';
// تأكد من استيراد الكيوبت
import 'package:e_commerce/featchers/home/presentation/views/CustomBottomNavigationBar.dart';
import 'package:e_commerce/featchers/home/presentation/views/widgets/main_view_body_bloc_consumer.dart';
// لإحضار الـ uID
import 'package:flutter/material.dart';

class MainVeiw extends StatefulWidget {
  const MainVeiw({super.key, required AuthRepoImpl authRepoImpl});

  @override
  State<MainVeiw> createState() => _MainVeiwState();
}

class _MainVeiwState extends State<MainVeiw> {
  int currentViewIndex = 0;

  @override
  Widget build(BuildContext context) {
    // ❌ احذف الـ MultiBlocProvider من هنا
    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFB),
      extendBody: true,
      bottomNavigationBar: SafeArea(
        child: BottomNavPage(
          currentIndex: currentViewIndex,
          onTap: (index) {
            setState(() {
              currentViewIndex = index;
            });
          },
        ),
      ),
      // سيعمل هذا الـ Widget بنجاح لأنه سيتعرف على الـ Cubit الممرر من الـ Route
      body: MainViewBodyBlocConsumer(currentViewIndex: currentViewIndex),
    );
  }
}