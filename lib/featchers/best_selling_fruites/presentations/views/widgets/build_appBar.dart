import 'package:e_commerce/core/utils/app_text_styles.dart';
import 'package:e_commerce/featchers/best_selling_fruites/presentations/views/widgets/notifecation_widgets.dart';
import 'package:flutter/material.dart';

AppBar build_App_Bar(BuildContext context, {required String title}) {
  return AppBar(
    backgroundColor: Colors.transparent,
    elevation: 0,
    centerTitle: true,
    title: Text(title, textAlign: TextAlign.center, style: TextStyles.bold16),
    leading: IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        Navigator.pop(context);
      },
    ),
    actions: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: NotifecationWidgets(notificationCount: 0,),
      ),
    ],
  );
}
