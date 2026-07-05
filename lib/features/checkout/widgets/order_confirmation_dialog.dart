import 'package:e_commerce/Features/checkout/domain/enteteis/order_entity.dart';
import 'package:flutter/material.dart';

class OrderConfirmationDialog extends StatelessWidget {
  const OrderConfirmationDialog({
    super.key,
    required this.orderEntity,
    required this.onConfirm,
  });

  final OrderInputEntity orderEntity;
  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text('تأكيد الطلب', textAlign: TextAlign.center),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'سيتم الدفع نقداً عند الاستلام.',
            style: TextStyle(color: Colors.green),
          ),
          const Divider(),
          Text('العنوان: ${orderEntity.shippingAddressEntity.address}'),
          Text(
            'الإجمالي: ${orderEntity.calculatetotalpriceAfterDiscountAndDelivery()} جنيه',
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('تعديل'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
            onConfirm();
          },
          child: const Text('تأكيد'),
        ),
      ],
    );
  }
}
