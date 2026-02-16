import 'package:e_commerce/core/di/injection.dart';
import 'package:e_commerce/core/functions_helper/routs.dart';
import 'package:e_commerce/featchers/home/presentation/cubits/myOrders/my_orders_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart'; // ستحتاج لإضافته في pubspec لضبط التاريخ

// استيرادات من مشروعك
import 'package:e_commerce/featchers/checkout/data/order_model.dart';
import 'package:e_commerce/featchers/home/presentation/cubits/myOrders/my_orders_cubit.dart';

class NotificationsView extends StatelessWidget {
  const NotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(context),
      body: BlocBuilder<OrdersCubit, OrdersState>(
        bloc: getIt<OrdersCubit>(),
        builder: (context, state) {
          if (state is OrdersLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is OrdersSuccess) {
            final orders = state.orders;

            if (orders.isEmpty) {
              return _buildEmptyState();
            }

            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: orders.length,
              separatorBuilder: (context, index) => const Divider(height: 32, thickness: 0.5),
              itemBuilder: (context, index) {
                return NotificationItem(order: orders[index]);
              },
            );
          } else if (state is OrdersFailure) {
            return Center(child: Text(state.errMessage));
          }
          return const SizedBox();
        },
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text(
        'الإشعارات',
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
      ),
      centerTitle: true,
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 20),
        onPressed: () => Navigator.pop(context),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.notifications_off_outlined, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 16),
          const Text(
            'لا توجد إشعارات حالياً',
            style: TextStyle(color: Colors.grey, fontSize: 16),
          ),
        ],
      ),
    );
  }
}

class NotificationItem extends StatelessWidget {
  final OrderModel order;

  const NotificationItem({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final config = _getNotificationConfig(order.status);

    return InkWell(
      onTap: () {
        // الانتقال لصفحة تفاصيل الطلب مع تمرير الموديل
        Navigator.pushNamed(
          context,
          AppRoutes.orderDetailsView,
          arguments: order,
        );
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // الأيقونة الديناميكية حسب الحالة
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: config.color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(config.icon, color: config.color, size: 24),
          ),
          const SizedBox(width: 16),
          // تفاصيل الإشعار
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'تحديث الطلب #${order.orderId.substring(0, 8).toUpperCase()}',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                const SizedBox(height: 6),
                Text(
                  config.message,
                  style: TextStyle(color: Colors.grey[700], fontSize: 13, height: 1.4),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _formatOrderDate(order.date),
                      style: const TextStyle(color: Colors.grey, fontSize: 11),
                    ),
                    const Text(
                      'تتبع الطلب >',
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _NotificationConfig _getNotificationConfig(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return _NotificationConfig(
          Icons.timer_outlined,
          Colors.orange,
          'طلبك قيد المراجعة الآن، سنقوم بتحديثك قريباً.',
        );
      case 'processing':
        return _NotificationConfig(
          Icons.inventory_2_outlined,
          Colors.blue,
          'جاري تجهيز طلبك وتغليفه بكل حب في مخازننا.',
        );
      case 'shipped':
        return _NotificationConfig(
          Icons.local_shipping_outlined,
          Colors.purple,
          'طلبك الآن في الطريق إليك مع مندوب الشحن.',
        );
      case 'delivered':
        return _NotificationConfig(
          Icons.check_circle_outline,
          Colors.green,
          'تم تسليم طلبك بنجاح. نأمل أن تنال المنتجات إعجابك!',
        );
      default:
        return _NotificationConfig(
          Icons.notifications_none,
          Colors.grey,
          'هناك تحديث جديد بخصوص حالة طلبك.',
        );
    }
  }

  String _formatOrderDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('yyyy/MM/dd - hh:mm a').format(date);
    } catch (e) {
      return dateStr;
    }
  }
}

class _NotificationConfig {
  final IconData icon;
  final Color color;
  final String message;
  _NotificationConfig(this.icon, this.color, this.message);
}