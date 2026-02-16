import 'package:e_commerce/core/di/injection.dart';
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
      appBar: AppBar(
        title: const Text('طلباتي', style: TextStyle(color: Colors.black)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: BlocBuilder<OrdersCubit, OrdersState>(
        bloc: getIt<OrdersCubit>(),
        builder: (context, state) {
          if (state is OrdersLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is OrdersSuccess) {
            if (state.orders.isEmpty) {
              return const Center(child: Text('لا توجد طلبات حالياً'));
            }
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.orders.length,
              itemBuilder: (context, index) => OrderCard(order: state.orders[index]),
            );
       } else if (state is OrdersFailure) {
  // 💡 السطر ده هيقولنا "بالظبط" إيه اللي ناقص أو ضارب
  debugPrint("❌ Orders Error: ${state.errMessage}"); 
  return Center(child: Text(state.errMessage));
}
          return const SizedBox();
        },
      ),
    );
  }
}

// 💡 إضافة كلاس OrderCard هنا ليتعرف عليه الـ OrdersView
class OrderCard extends StatelessWidget {
  final OrderModel order;
  const OrderCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
          )
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // عرض أول 8 أرقام من الـ ID فقط لشكل أجمل
              Text('طلب رقم #${order.orderId.substring(0, 8)}', 
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              _buildStatusBadge(order.status),
            ],
          ),
          const Divider(height: 24),
          Row(
            children: [
              const Icon(Icons.calendar_today, size: 14, color: Colors.grey),
              const SizedBox(width: 8),
              // عرض التاريخ بشكل مبسط
              Text(order.date.split(' ')[0], 
                  style: const TextStyle(color: Colors.grey, fontSize: 13)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('الإجمالي: ${order.totalPrice} جنيه', 
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.orderDetailsView, arguments: order);

                },
                child: const Text('التفاصيل'),
              )
            ],
          )
        ],
      ),
    );
  }

  // ودجت صغيرة لعرض حالة الطلب بلون مختلف حسب الحالة القادمة من الداش بورد
  Widget _buildStatusBadge(String status) {
    Color color;
    String label;

    switch (status) {
      case 'shipping':
        color = Colors.blue;
        label = 'جاري التوصيل';
        break;
      case 'delivered':
        color = Colors.green;
        label = 'تم الاستلام';
        break;
      case 'cancelled':
        color = Colors.red;
        label = 'ملغي';
        break;
      default:
        color = Colors.orange;
        label = 'قيد المراجعة';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.bold),
      ),
    );
  }
}