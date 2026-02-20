import 'dart:developer';

import 'package:e_commerce/core/di/injection.dart';
import 'package:e_commerce/core/functions_helper/build_overlay_bar.dart';
import 'package:e_commerce/core/services/paypal_debugger.dart';
import 'package:e_commerce/core/utils/app_key.dart';
import 'package:e_commerce/core/widgets/custom_button.dart';
import 'package:e_commerce/featchers/checkout/data/transaction_model.dart';
import 'package:e_commerce/featchers/checkout/domain/enteteis/order_entity.dart';
import 'package:e_commerce/featchers/checkout/presentation/manger/add_order_cubit/add_order_cubit.dart';
import 'package:e_commerce/featchers/checkout/widgets/check_out_steps_pageview.dart';
import 'package:e_commerce/featchers/checkout/widgets/checkout_steps.dart';
import 'package:e_commerce/featchers/checkout/widgets/thankyou_page.dart';
import 'package:e_commerce/featchers/home/presentation/cubits/cart_cubit/cart_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CheckoutViewBody extends StatefulWidget {
  const CheckoutViewBody({super.key});

  @override
  State<CheckoutViewBody> createState() => _CheckoutViewBodyState();
}

class _CheckoutViewBodyState extends State<CheckoutViewBody> {
  late PageController pageController;
  final formKey = GlobalKey<FormState>();
  final ValueNotifier<AutovalidateMode> valueListenable = ValueNotifier(
    AutovalidateMode.disabled,
  );

  int currentPageIndex = 0;

  @override
  void initState() {
    pageController = PageController();
    pageController.addListener(() {
      if (mounted) {
        setState(() => currentPageIndex = pageController.page!.round());
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();
    valueListenable.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Column(
        children: [
          const SizedBox(height: 20),

          /// الخطوات العلوية
          CheckoutSteps(
            currentIndex: currentPageIndex,
            onTap: (index) {
              pageController.animateToPage(
                index,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            },
            pageController: pageController,
            formKey: formKey,
          ),

          const SizedBox(height: 20),

          /// محتوى الصفحات (الشحن - العنوان - الدفع)
          Expanded(
            child: CheckOutStepsPageView(
              pageController: pageController,
              formKey: formKey,
              valueListenable: valueListenable,
            ),
          ),
          const SizedBox(height: 20),

          /// زر التالي / إتمام الطلب
          CustomButtn(
            text: getNextButtonText(currentPageIndex),
            onPressed: () {
              if (currentPageIndex == 0) {
                _handleShippingSectionValidation(context);
              } else if (currentPageIndex == 1) {
                _handleAddressValidation();
              } else {
                // المرحلة النهائية: التحقق من طريقة الدفع
                var orderEntity = context.read<OrderInputEntity>();
                if (orderEntity.payWithCash == true) {
                  _showOrderConfirmationDialog(context);
                } else {
                  _processPayment(context);
                }
              }
            },
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  /// ------------------------------------------------------------------------

  void _handleShippingSectionValidation(BuildContext context) {
    if (context.read<OrderInputEntity>().payWithCash != null) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      showBar(context, 'يرجي تحديد طريقة الدفع');
    }
  }

  String getNextButtonText(int page) {
    var orderEntity = context.read<OrderInputEntity>();
    if (page == 2) {
      return orderEntity.payWithCash == true ? 'إتمام الطلب' : 'الدفع عبر PayPal';
    }
    return 'التالي';
  }

  void _handleAddressValidation() {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      valueListenable.value = AutovalidateMode.always;
      showBar(context, 'يرجى إكمال بيانات العنوان');
    }
  }

  /// ================== 🔥 Order Confirmation Dialog for Cash ==================
  void _showOrderConfirmationDialog(BuildContext context) {
    var orderEntity = context.read<OrderInputEntity>();
    var addOrderCubit = context.read<AddOrderCubit>();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('تأكيد الطلب',
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('سيتم الدفع نقداً عند الاستلام.',
                style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
            const Divider(),     
            Text('العنوان: ${orderEntity.shippingAddressEntity.address}'),
            Text('المدينة: ${orderEntity.shippingAddressEntity.city}'),
            const SizedBox(height: 8),
            Text('الإجمالي: ${orderEntity.totalPrice} جنيه',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('تعديل', style: TextStyle(color: Colors.red)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // إغلاق الديالوج
              
              // 1. إضافة الطلب لقاعدة البيانات
              addOrderCubit.addOrder(order: orderEntity);

              // 2. تصفير السلة
              getIt<CartCubit>().clearCart();

              // 3. الانتقال لشاشة الشكر
              _navigateToThankYouPage(context);
            },
            child: const Text('تأكيد'),
          ),
        ],
      ),
    );
  }

  /// ================== 🔥 PayPal Payment Logic ==================
  void _processPayment(BuildContext context) {
    var orderEntity = context.read<OrderInputEntity>();
    var addOrderCubit = context.read<AddOrderCubit>();

    TransactionModel transactionModel = TransactionModel.fromEntity(orderEntity);

    PayPalDebugger.checkout(
      context: context,
      clientId: clientPaypalKeyId,
      secretKey: secretpaypalKey,
      transactions: [transactionModel.toJson()],
      onSuccess: (response) {
        addOrderCubit.addOrder(order: orderEntity);
        getIt<CartCubit>().clearCart();
        _navigateToThankYouPage(context);
      },
      onError: (error) {
        showBar(context, "فشلت عملية الدفع!", color: Colors.red);
      },
      onCancel: () {
        showBar(context, "تم إلغاء عملية الدفع");
      },
    );
  }

// داخل CheckoutViewBody
void _navigateToThankYouPage(BuildContext context) {
  // نتحقق أن الشاشة لا تزال موجودة ولم يتم إغلاقها
  if (!mounted) return;

  Navigator.of(context).pushReplacement(
    MaterialPageRoute(
      builder: (context) => BlocProvider.value(
        value: getIt<CartCubit>(),
        child: ThankYouView(key: UniqueKey()),
      ),
    ),
  );
}
}