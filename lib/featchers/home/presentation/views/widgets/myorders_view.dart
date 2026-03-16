import 'package:e_commerce/core/functions_helper/routs.dart';
import 'package:e_commerce/featchers/checkout/data/order_model.dart';
import 'package:e_commerce/featchers/home/presentation/cubits/myOrders/my_orders_cubit.dart';
import 'package:e_commerce/featchers/home/presentation/cubits/myOrders/my_orders_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrdersView extends StatelessWidget {
  const OrdersView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFB),
      appBar: AppBar(
        title: const Text(
          'طلباتي',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocBuilder<OrdersCubit, OrdersState>(
        // ✅ نعتمد على الـ Context القادم من الـ Router لضمان التحديث اللحظي
        builder: (context, state) {
          if (state is OrdersLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is OrdersSuccess) {
            if (state.orders.isEmpty) {
              return _buildEmptyState();
            }
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.orders.length,
              itemBuilder: (context, index) => OrderCard(order: state.orders[index]),
            );
          } else if (state is OrdersFailure) {
            debugPrint("❌ Orders Error: ${state.errMessage}");
            return Center(child: Text(state.errMessage));
          }
          return const SizedBox();
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_bag_outlined, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 16),
          const Text(
            'لا توجد طلبات حالياً',
            style: TextStyle(color: Colors.grey, fontSize: 16),
          ),
        ],
      ),
    );
  }
}

class OrderCard extends StatelessWidget {
  final OrderModel order;
  const OrderCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    // استخدام نفس منطق الألوان والأيقونات من كود الإشعارات لتوحيد الـ UI
    final statusConfig = _getStatusConfig(order.status);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'طلب رقم #${order.orderId.substring(0, 8).toUpperCase()}',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              _buildStatusBadge(statusConfig),
            ],
          ),
          const Divider(height: 32, thickness: 0.5),
          Row(
            children: [
              Icon(Icons.calendar_today_outlined, size: 16, color: Colors.grey[600]),
              const SizedBox(width: 8),
              Text(
                order.date.split(' ')[0],
                style: TextStyle(color: Colors.grey[600], fontSize: 13),
              ),
              const Spacer(),
              const Icon(Icons.sell_outlined, size: 16, color: Colors.grey),
              const SizedBox(width: 4),
              Text(
                '${order.totalPrice} جنيه',
                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  AppRoutes.orderDetailsView,
                  arguments: order,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.withOpacity(0.05),
                foregroundColor: Colors.blue,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('تفاصيل الطلب', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildStatusBadge(_StatusConfig config) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: config.color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(config.icon, color: config.color, size: 14),
          const SizedBox(width: 6),
          Text(
            config.label,
            style: TextStyle(
              color: config.color,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  _StatusConfig _getStatusConfig(String status) {
    // توحيد الحالات بناءً على الـ Repo والـ Notifications
    switch (status.toLowerCase()) {
      case 'pending':
        return _StatusConfig('قيد المراجعة', Colors.orange, Icons.timer_outlined);
      case 'processing':
        return _StatusConfig('جاري التجهيز', Colors.blue, Icons.inventory_2_outlined);
      case 'shipping':
      case 'shipped':
        return _StatusConfig('جاري التوصيل', Colors.purple, Icons.local_shipping_outlined);
      case 'delivered':
        return _StatusConfig('تم الاستلام', Colors.green, Icons.check_circle_outline);
      case 'cancelled':
      case 'canceled': // الحالتين عشان لو حصل لخبطة في الـ Repo
        return _StatusConfig('ملغي', Colors.red, Icons.cancel_outlined);
      default:
        return _StatusConfig('تحديث جديد', Colors.grey, Icons.notifications_none);
    }
  }
}

class _StatusConfig {
  final String label;
  final Color color;
  final IconData icon;
  _StatusConfig(this.label, this.color, this.icon);
}