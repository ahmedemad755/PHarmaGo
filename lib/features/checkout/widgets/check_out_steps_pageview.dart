import 'package:e_commerce/Features/checkout/widgets/payment_section.dart';
import 'package:e_commerce/Features/checkout/widgets/address_input_section.dart';
import 'package:e_commerce/Features/checkout/widgets/shipping_section.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CheckOutStepsPageView extends StatelessWidget {
  const CheckOutStepsPageView({
    super.key,
    required this.pageController,
    required this.formKey,
    required this.valueListenable,
  });

  final PageController pageController;
  final GlobalKey<FormState> formKey;
  final ValueListenable<AutovalidateMode> valueListenable;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: PageView.builder(
        controller: pageController,
        physics: NeverScrollableScrollPhysics(),
        itemCount: getpages().length,
        itemBuilder: (context, index) {
          return getpages()[index];
        },
      ),
    );
  }

  List<Widget> getpages() {
    return [
      ShippingSection(),
      AddressInputSection(formKey: formKey, valueListenable: valueListenable),
      PaymentSection(pageController: pageController),
      const SizedBox(),
    ];
  }
}
