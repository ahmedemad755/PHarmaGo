import 'package:e_commerce/core/functions_helper/get_user_data.dart';
import 'package:e_commerce/core/functions_helper/routs.dart';
import 'package:e_commerce/core/utils/app_text_styles.dart';
import 'package:e_commerce/featchers/best_selling_fruites/presentations/views/widgets/notifecation_widgets.dart';
import 'package:e_commerce/featchers/home/presentation/cubits/myOrders/my_orders_cubit.dart';
import 'package:e_commerce/featchers/home/presentation/cubits/myOrders/my_orders_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomHomeAppBar extends StatelessWidget {
  const CustomHomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      trailing: BlocBuilder<OrdersCubit, OrdersState>(
        builder: (context, state) {
          int count = 0;
          if (state is OrdersSuccess) {
            // منطق العد: الطلبات التي حالتها ليست Delivered
            count = state.orders
                .where((o) => o.status.toLowerCase() != 'delivered')
                .length;
          }
          return NotifecationWidgets(
            notificationCount: count,
            onTap: () {
              // نمرر الـ Cubit لصفحة الإشعارات عبر الـ arguments
              Navigator.pushNamed(
                context, 
                AppRoutes.notificationsView, 
                arguments: context.read<OrdersCubit>(),
              );
            },
          );
        },
      ),
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