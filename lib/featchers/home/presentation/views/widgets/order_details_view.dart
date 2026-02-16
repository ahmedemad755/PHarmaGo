import 'package:e_commerce/featchers/checkout/data/order_model.dart';
import 'package:e_commerce/featchers/home/presentation/cubits/myOrders/my_orders_cubit.dart';
import 'package:e_commerce/featchers/home/presentation/cubits/myOrders/my_orders_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrderDetailsView extends StatelessWidget {
  final OrderModel order;
  const OrderDetailsView({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrdersCubit, OrdersState>(
      builder: (context, state) {
        OrderModel currentOrder = order;
        if (state is OrdersSuccess) {
          try {
            currentOrder = state.orders.firstWhere(
              (o) => o.orderId == order.orderId,
              orElse: () => order,
            );
          } catch (e) {
            currentOrder = order;
          }
        }

        return Scaffold(
          backgroundColor: const Color(0xFFF8F9FA),
          appBar: AppBar(
            title: Text(
              'تفاصيل الطلب #${currentOrder.orderId.substring(0, 8)}',
              style: const TextStyle(color: Colors.black, fontSize: 16),
            ),
            centerTitle: true,
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildOrderStepIndicator(currentOrder.status),
                const SizedBox(height: 24),
                const Text(
                  'المنتجات',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 12),
                _buildProductsList(currentOrder),
                const SizedBox(height: 24),
                _buildAddressCard(currentOrder),
                const SizedBox(height: 24),
                _buildPaymentSummary(currentOrder),
                const SizedBox(height: 32),
                if (currentOrder.status == 'pending')
                  _buildCancelButton(context, currentOrder),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildProductsList(OrderModel currentOrder) {
    return Column(
      children: currentOrder.orderProducts.map((product) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  product.imageUrl,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.store,
                          size: 14,
                          color: Colors.blueGrey,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          product.pharmacyName ?? 'صيدلية عامة',
                          style: const TextStyle(
                            color: Colors.blueGrey,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      'الكمية: ${product.quantity}',
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
              ),
              Text(
                '${product.price} ج.م',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildOrderStepIndicator(String status) {
    int currentStep = 1;
    if (status == 'shipping' || status == 'shipped') currentStep = 2;
    if (status == 'delivered') currentStep = 3;
    if (status == 'cancelled') currentStep = 0;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildStep(
            Icons.receipt_long,
            "تم الطلب",
            currentStep >= 1 || status == 'cancelled',
          ),
          _buildLine(currentStep >= 2),
          _buildStep(Icons.local_shipping, "شحن", currentStep >= 2),
          _buildLine(currentStep >= 3),
          _buildStep(Icons.check_circle, "استلام", currentStep >= 3),
        ],
      ),
    );
  }

  Widget _buildStep(IconData icon, String label, bool isActive) {
    return Column(
      children: [
        Icon(icon, color: isActive ? Colors.green : Colors.grey[300], size: 28),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: isActive ? Colors.black : Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildLine(bool isActive) {
    return Expanded(
      child: Container(
        height: 2,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        color: isActive ? Colors.green : Colors.grey[300],
      ),
    );
  }

  Widget _buildAddressCard(OrderModel currentOrder) {
    final addr = currentOrder.shippingAddressModel;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'عنوان التوصيل',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                addr.name ?? '',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text('${addr.city ?? ''}, ${addr.address ?? ''}'),
              Text('الدور: ${addr.floor ?? ''}'),
              Text(
                addr.phone ?? '',
                style: const TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentSummary(OrderModel currentOrder) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('الإجمالي المستحق', style: TextStyle(color: Colors.grey)),
          Text(
            '${currentOrder.totalPrice} ج.م',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.green,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCancelButton(BuildContext context, OrderModel currentOrder) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Colors.red),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          foregroundColor: Colors.red,
        ),
        onPressed: () {
          context.read<OrdersCubit>().cancelOrder(currentOrder.orderId);
          Navigator.pop(context);
        },
        child: const Text('إلغاء الطلب'),
      ),
    );
  }
}
