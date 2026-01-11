import 'package:e_commerce/core/functions_helper/get_user_data.dart';
import 'package:e_commerce/core/utils/app_text_styles.dart';
import 'package:e_commerce/featchers/best_selling_fruites/presentations/views/widgets/notifecation_widgets.dart';
import 'package:flutter/material.dart';

class CustomHomeAppBar extends StatelessWidget {
  const CustomHomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      trailing: NotifecationWidgets(),
      // leading: Image.asset(Assets.profileimage),
      title: Text(
        'صباح الخير !..',
        textAlign: TextAlign.right,
        style: TextStyles.regular16.copyWith(color: const Color(0xFF949D9E)),
      ),
      subtitle: Text(
        getUser().name,
        textAlign: TextAlign.right,
        style: TextStyles.bold16,
      ),
    );
  }
}
