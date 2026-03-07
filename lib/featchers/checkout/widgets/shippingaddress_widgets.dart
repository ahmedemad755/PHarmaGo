import 'package:e_commerce/featchers/checkout/domain/enteteis/order_entity.dart';
import 'package:e_commerce/featchers/checkout/widgets/payment_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/utils/app_text_styles.dart';

class ShippingAddressWidget extends StatelessWidget {
  const ShippingAddressWidget({super.key, required this.pageController});

  final PageController pageController;

  @override
  Widget build(BuildContext context) {
    // استخدمنا watch هنا لأننا نريد تحديث الواجهة إذا تغير العنوان
    final order = context.watch<OrderInputEntity>();
    final shippingAddress = order.shippingAddressEntity;

    return PaymentItem(
      tile: 'عنوان التوصيل',
      child: Row(
        children: [
          const Icon(Icons.location_pin, color: Color(0xFF1B5E37)),
          const SizedBox(width: 8),
          Expanded( // أضفنا Expanded لمنع Overflow إذا كان العنوان طويلاً
            child: Text(
              shippingAddress.toStrings(),
              textAlign: TextAlign.right,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyles.regular13.copyWith(
                color: const Color(0xFF4E5556),
              ),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () {
              pageController.animateToPage(
                1,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeIn,
              );
            },
            child: Row(
              children: [
                const Icon(Icons.edit, size: 18, color: Color(0xFF949D9E)),
                const SizedBox(width: 4),
                Text(
                  'تعديل',
                  style: TextStyles.semiBold13.copyWith(
                    color: const Color(0xFF949D9E),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}