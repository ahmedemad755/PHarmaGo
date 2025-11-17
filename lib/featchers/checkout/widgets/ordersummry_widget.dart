import 'package:e_commerce/featchers/checkout/domain/enteteis/order_entity.dart'
    show OrderInputEntity;
import 'package:e_commerce/featchers/checkout/widgets/payment_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/utils/app_text_styles.dart';

class OrderSummryWidget extends StatelessWidget {
  const OrderSummryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // final order = context.read<OrderInputEntity>();
    // final double totalPrice = order.cartEntity.getTotalPrice().toDouble();

    // /// ✅ لو الدفع كاش = 50 توصيل، لو اونلاين = 0
    // final double deliveryPrice = order.payWithCash == true ? 50 : 0;

    // /// الإجمالي النهائي
    // final double finalPrice = totalPrice + deliveryPrice;
    final order = context.read<OrderInputEntity>();
    return PaymentItem(
      tile: 'ملخص الطلب',
      child: Column(
        children: [
          Row(
            children: [
              Text(
                'المجموع الفرعي :',
                style: TextStyles.regular13.copyWith(
                  color: const Color(0xFF4E5556),
                ),
              ),
              const Spacer(),
              Text(
                '${order.totalPrice} جنيه',
                textAlign: TextAlign.right,
                style: TextStyles.semiBold16,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                'التوصيل  :',
                style: TextStyles.regular13.copyWith(
                  color: const Color(0xFF4E5556),
                ),
              ),
              const Spacer(),
              Text(
                '${order.deliveryPrice} جنيه',
                textAlign: TextAlign.right,
                style: TextStyles.regular13.copyWith(
                  color: const Color(0xFF4E5556),
                ),
              ),
            ],
          ),
          const SizedBox(height: 9),
          const Divider(thickness: .5, color: Color(0xFFCACECE)),
          const SizedBox(height: 9),
          Row(
            children: [
              const Text('الكلي', style: TextStyles.bold16),
              const Spacer(),
              Text('${order.finalPrice} جنيه', style: TextStyles.bold16),
            ],
          ),
        ],
      ),
    );
  }

  /// 🔹 دالة لحساب تكلفة التوصيل فقط
  double getDeliveryPrice({
    required double totalPrice,
    required double finalPrice,
  }) {
    return finalPrice - totalPrice;
  }
}
