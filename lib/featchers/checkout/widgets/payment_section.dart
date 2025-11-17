import 'package:e_commerce/featchers/checkout/widgets/ordersummry_widget.dart';
import 'package:e_commerce/featchers/checkout/widgets/shippingaddress_widgets.dart';
import 'package:flutter/material.dart';

class PaymentSection extends StatelessWidget {
  const PaymentSection({super.key, required this.pageController});

  final PageController pageController;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 24),
          const OrderSummryWidget(),
          const SizedBox(height: 16),
          ShippingAddressWidget(pageController: pageController),
        ],
      ),
    );
  }
}
