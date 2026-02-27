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
  // ✅ نقوم بتغليف الصفحة بالكامل بـ BlocProvider.value
  // ونعطيه القيمة مباشرة من getIt
  return BlocProvider<CartCubit>.value(
    value: getIt<CartCubit>(),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Column(
        children: [
          const SizedBox(height: 20),
          // الآن أي وجت داخل هذه الشجرة (حتى لو كان CheckoutSteps)
          // سيجد الـ CartCubit في الـ context بنجاح
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
          Expanded(
            child: CheckOutStepsPageView(
              pageController: pageController,
              formKey: formKey,
              valueListenable: valueListenable,
            ),
          ),
          const SizedBox(height: 20),
          CustomButtn(
            text: getNextButtonText(currentPageIndex, context),
            onPressed: () {
              if (currentPageIndex == 0) {
                _handleShippingSectionValidation(context);
              } else if (currentPageIndex == 1) {
                _handleAddressValidation();
              } else {
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
    ),
  );
}

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

String getNextButtonText(int page, BuildContext context) {
    // نقرأ من الـ context الممرر للدالة وهو context الخاص بـ build
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

void _showOrderConfirmationDialog(BuildContext parentContext) {
    // نقرأ القيم من الـ parentContext (context الصفحة) قبل الدخول للـ Dialog
    var orderEntity = parentContext.read<OrderInputEntity>();
    var addOrderCubit = parentContext.read<AddOrderCubit>();
    var cartCubit = getIt<CartCubit>();

    String detectedPharmacyId = 'unknown';
    if (cartCubit.currentCart.cartItems.isNotEmpty) {
      detectedPharmacyId = cartCubit.currentCart.cartItems.first.pharmacyId ?? 'unknown';
    }

    showDialog(
      context: parentContext,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog( // نستخدم dialogContext هنا للـ UI فقط
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('تأكيد الطلب', textAlign: TextAlign.center),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('سيتم الدفع نقداً عند الاستلام.', style: TextStyle(color: Colors.green)),
            const Divider(),
            Text('العنوان: ${orderEntity.shippingAddressEntity.address}'),
            Text('الإجمالي: ${orderEntity.calculatetotalpriceAfterDiscountAndDelivery()} جنيه'),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('تعديل')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              orderEntity.pharmacyId = detectedPharmacyId;
              addOrderCubit.addOrder(order: orderEntity);
              cartCubit.clearCart();
              _navigateToThankYouPage(parentContext); // نستخدم الـ parentContext
            },
            child: const Text('تأكيد'),
          ),
        ],
      ),
    );
  }

  void _processPayment(BuildContext context) {
    var orderEntity = context.read<OrderInputEntity>();
    var addOrderCubit = context.read<AddOrderCubit>();
    var cartCubit = getIt<CartCubit>();

    if (cartCubit.currentCart.cartItems.isNotEmpty) {
      orderEntity.pharmacyId = cartCubit.currentCart.cartItems.first.pharmacyId ?? 'unknown';
    }

    TransactionModel transactionModel = TransactionModel.fromEntity(orderEntity);

    PayPalDebugger.checkout(
      context: context,
      clientId: clientPaypalKeyId,
      secretKey: secretpaypalKey,
      transactions: [transactionModel.toJson()],
      onSuccess: (response) {
        addOrderCubit.addOrder(order: orderEntity);
        cartCubit.clearCart();
        _navigateToThankYouPage(context);
      },
      onError: (error) => showBar(context, "فشلت عملية الدفع!", color: Colors.red),
      onCancel: () => showBar(context, "تم إلغاء عملية الدفع"),
    );
  }

void _navigateToThankYouPage(BuildContext context) {
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        // لا داعي لـ BlocProvider هنا لأن ThankYouView يمكنها نداء getIt مباشرة
        builder: (context) => ThankYouView(key: UniqueKey()),
      ),
    );
  }
}