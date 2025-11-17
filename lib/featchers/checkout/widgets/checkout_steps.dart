import 'package:e_commerce/core/functions_helper/build_overlay_bar.dart';
import 'package:e_commerce/featchers/checkout/domain/enteteis/order_entity.dart';
import 'package:e_commerce/featchers/checkout/widgets/step_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ignore: must_be_immutable
class CheckoutSteps extends StatelessWidget {
  const CheckoutSteps({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.pageController,
    required this.formKey,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;
  final PageController pageController;
  final GlobalKey<FormState> formKey;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(getsteps().length, (index) {
        return Expanded(
          child: GestureDetector(
            onTap: () {
              // 1. السماح بالتنقل للخلف أو إلى الخطوة الحالية بدون تحقق
              if (index <= currentIndex) {
                _navigateToPage(index);
                return;
              }

              // 2. منع القفز لأكثر من خطوة واحدة للأمام (e.g., من 0 إلى 2)
              if (index > currentIndex + 1) {
                showBar(context, "يجب إكمال الخطوات بالترتيب.");
                return;
              }
              // 3. التحقق من صحة الخطوة الحالية (currentIndex) قبل الانتقال للخطوة التالية (index)
              // التحقق الخاص بصفحة الشحن (Index 0)
              if (currentIndex == 0) {
                if (context.read<OrderInputEntity>().payWithCash == null) {
                  showBar(context, "يرجى اختيار طريقة الدفع");
                  return;
                }
              }
              // التحقق الخاص بصفحة العنوان (Index 1) - هذا كان يسبب المشكلة
              else if (currentIndex == 1) {
                // يتم التحقق من الـ formKey فقط إذا كنا على صفحة العنوان ونريد الانتقال للأمام
                final formState = formKey.currentState;
                if (formState == null || !formState.validate()) {
                  showBar(context, "يرجى ملء جميع حقول العنوان");
                  return;
                }
                // 💡 الحل: حفظ البيانات المدخلة قبل الانتقال إلى الخطوة التالية (الدفع)
                formState.save();
              }
              // 4. إذا مر التحقق بنجاح، انتقل إلى الصفحة المطلوبة
              _navigateToPage(index);
            },
            child: StepItem(
              isActive: index <= currentIndex, // الخطوات اللي خلصت
              index: (index + 1).toString(),
              text: getsteps()[index],
            ),
          ),
        );
      }),
    );
  }

  void _navigateToPage(int index) {
    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    onTap(index);
  }
}

List<String> getsteps() {
  return ["الشحن", "العنوان", "الدفع"];
}
