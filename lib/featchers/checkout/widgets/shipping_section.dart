import 'package:e_commerce/featchers/checkout/domain/enteteis/order_entity.dart';
import 'package:e_commerce/featchers/checkout/widgets/shipping_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ShippingSection extends StatefulWidget {
  const ShippingSection({super.key});

  @override
  State<ShippingSection> createState() => _ShippingSectionState();
}

class _ShippingSectionState extends State<ShippingSection>
    with AutomaticKeepAliveClientMixin {
  
  int selectedIndex = -1;

  @override
  void initState() {
    super.initState();
    // 🔹 استرجاع الحالة السابقة إذا كان المستخدم قد اختار بالفعل
    final currentPayWithCash = context.read<OrderInputEntity>().payWithCash;
    if (currentPayWithCash == true) {
      selectedIndex = 0;
    } else if (currentPayWithCash == false) {
      selectedIndex = 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final order = context.read<OrderInputEntity>();
    final double totalPrice = order.cartEntity.getTotalPrice().toDouble();
    
    // 🚚 تكلفة الكاش (السعر + 50 توصيل) - يفضل جعل الـ 50 متغيراً ثابتاً في الإعدادات لاحقاً
    final double cashOnDeliveryPrice = totalPrice + 50;

    return Column(
      children: [
        ShippingItem(
          title: 'الدفع عند الاستلام',
          subTitle: 'التسليم في العنوان المحدد',
          price: '$cashOnDeliveryPrice جنيه', // 🔹 إضافة العملة لتحسين الشكل
          isSelected: selectedIndex == 0,
          onTap: () {
            setState(() {
              selectedIndex = 0;
            });
            order.payWithCash = true;
          },
        ),
        const SizedBox(height: 16),
        ShippingItem(
          title: 'الدفع اونلاين',
          subTitle: 'PayPal / بطاقة ائتمان',
          price: '$totalPrice جنيه',
          isSelected: selectedIndex == 1,
          onTap: () {
            setState(() {
              selectedIndex = 1;
            });
            order.payWithCash = false;
          },
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}