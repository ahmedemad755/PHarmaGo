import 'package:e_commerce/core/di/injection.dart';
import 'package:e_commerce/core/functions_helper/build_overlay_bar.dart';
import 'package:e_commerce/core/widgets/custom_button.dart';
import 'package:e_commerce/Features/cart/presentation/cubits/cart_cubit/cart_cubit.dart';
import 'package:e_commerce/Features/checkout/presentation/controllers/checkout_flow_controller.dart';
import 'package:e_commerce/Features/checkout/presentation/manger/add_order_cubit/add_order_cubit.dart';
import 'package:e_commerce/Features/checkout/widgets/check_out_steps_pageview.dart';
import 'package:e_commerce/Features/checkout/widgets/checkout_steps.dart';
import 'package:e_commerce/Features/checkout/widgets/thankyou_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CheckoutViewBody extends StatefulWidget {
  const CheckoutViewBody({super.key});

  @override
  State<CheckoutViewBody> createState() => _CheckoutViewBodyState();
}

class _CheckoutViewBodyState extends State<CheckoutViewBody> {
  late final PageController pageController;
  late final CheckoutFlowController flowController;
  final formKey = GlobalKey<FormState>();
  final ValueNotifier<AutovalidateMode> valueListenable = ValueNotifier(
    AutovalidateMode.disabled,
  );

  int currentPageIndex = 0;

  @override
  void initState() {
    super.initState();
    pageController = PageController();
    pageController.addListener(() {
      if (mounted) {
        setState(() => currentPageIndex = pageController.page!.round());
      }
    });
    flowController = CheckoutFlowController(
      pageController: pageController,
      formKey: formKey,
      valueListenable: valueListenable,
    );
  }

  @override
  void dispose() {
    pageController.dispose();
    valueListenable.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CartCubit>.value(
      value: getIt<CartCubit>(),
      child: BlocListener<AddOrderCubit, AddOrderState>(
        // 🔥 التعديل الجوهري: مراقبة حالة الطلب
        listener: (context, state) {
          if (state is AddOrderSuccess) {
            context.read<CartCubit>().clearCart(); // مسح السلة عند النجاح فقط
            _navigateToThankYouPage(context);
          } else if (state is AddOrderFailure) {
            showBar(context, state.message, color: Colors.red);
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Column(
            children: [
              const SizedBox(height: 20),
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
              BlocBuilder<CartCubit, CartState>(
                builder: (context, state) {
                  return CustomButtn(
                    text: flowController.getNextButtonText(
                      currentPageIndex,
                      context,
                    ),
                    onPressed: () =>
                        flowController.handleNextStep(context, currentPageIndex),
                  );
                },
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToThankYouPage(BuildContext context) {
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => ThankYouView(key: UniqueKey())),
    );
  }
}
