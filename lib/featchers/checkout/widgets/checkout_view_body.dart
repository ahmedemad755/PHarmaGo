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
import 'package:image_picker/image_picker.dart';

class CheckoutViewBody extends StatefulWidget {
  const CheckoutViewBody({super.key});

  @override
  State<CheckoutViewBody> createState() => _CheckoutViewBodyState();
}

class _CheckoutViewBodyState extends State<CheckoutViewBody> {
  late PageController pageController;
  final formKey = GlobalKey<FormState>();
  final ValueNotifier<AutovalidateMode> valueListenable =
      ValueNotifier(AutovalidateMode.disabled);

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
                    text: getNextButtonText(currentPageIndex, context),
                    onPressed: () => _handleNextStep(context),
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

  void _handleNextStep(BuildContext context) {
    if (currentPageIndex == 0) {
      _handleShippingSectionValidation(context);
    } else if (currentPageIndex == 1) {
      _handleAddressValidation();
    } else {
      _handleFinalStepValidation(context);
    }
  }

  void _handleShippingSectionValidation(BuildContext context) {
    final cartCubit = context.read<CartCubit>();
    final orderEntity = context.read<OrderInputEntity>();

    if (orderEntity.payWithCash != null) {
      if (cartCubit.isPrescriptionRequired && cartCubit.prescriptionImage == null) {
        _showPrescriptionRequiredDialog(context);
        return;
      }

      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      showBar(context, 'يرجي تحديد طريقة الدفع');
    }
  }

void _showPrescriptionRequiredDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row( // تم إزالة const هنا لاستخدام Expanded بالداخل
          children: [
            const Icon(Icons.medical_information, color: Colors.red),
            const SizedBox(width: 8),
            // ✅ تغليف النص بـ Expanded لمنع الـ Overflow في العناوين الطويلة
            Expanded(
              child: Text(
                'مطلوب روشتة طبية',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis, // يضع نقاط إذا كان النص طويلاً جداً
                maxLines: 1,
              ),
            ),
          ],
        ),
        content: const Text(
          'هذا الدواء يتطلب روشتة طبية وإرشاداً طبياً موثوقاً. يرجى رفع صورة الروشتة للمتابعة.',
          style: TextStyle(fontSize: 15),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('إلغاء', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () async {
              Navigator.pop(dialogContext);
              await _pickPrescriptionImage(context);
            },
            child: const FittedBox( // ✅ حماية إضافية لنص الزر
              child: Text(
                'رفع الروشتة الآن',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickPrescriptionImage(BuildContext context) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      if (!context.mounted) return;
      context.read<CartCubit>().setPrescriptionImage(image);
      showBar(context, 'تم رفع الروشتة بنجاح', color: Colors.green);
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      if (!context.mounted) return;
      showBar(context, 'يجب رفع الصورة للمتابعة', color: Colors.orange);
    }
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

  void _handleFinalStepValidation(BuildContext context) {
    final cartCubit = context.read<CartCubit>();
    final orderEntity = context.read<OrderInputEntity>();

    if (cartCubit.isPrescriptionRequired && cartCubit.prescriptionImage == null) {
      showBar(context, 'عذراً، الروشتة مفقودة. تم إرجاعك لرفعها.', color: Colors.orange);
      pageController.animateToPage(0, duration: const Duration(milliseconds: 500), curve: Curves.ease);
      return;
    }

    orderEntity.prescriptionFile = cartCubit.prescriptionImage;

    if (orderEntity.payWithCash == true) {
      _showOrderConfirmationDialog(context);
    } else {
      _processPayment(context);
    }
  }

  void _showOrderConfirmationDialog(BuildContext parentContext) {
    final orderEntity = parentContext.read<OrderInputEntity>();
    final addOrderCubit = parentContext.read<AddOrderCubit>();
    final cartCubit = parentContext.read<CartCubit>();

    String detectedPharmacyId = 'unknown';
    if (cartCubit.currentCart.cartItems.isNotEmpty) {
      detectedPharmacyId = cartCubit.currentCart.cartItems.first.pharmacyId ?? 'unknown';
    }

    showDialog(
      context: parentContext,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
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
              if (cartCubit.isPrescriptionRequired && cartCubit.prescriptionImage == null) {
                Navigator.pop(dialogContext);
                showBar(parentContext, 'خطأ: لم يتم العثور على صورة الروشتة!', color: Colors.red);
                pageController.jumpToPage(0);
                return;
              }

              Navigator.pop(dialogContext);
              orderEntity.pharmacyId = detectedPharmacyId;
              orderEntity.prescriptionFile = cartCubit.prescriptionImage; 
              
              // 🔥 التعديل: إرسال الطلب فقط وانتظار النتيجة في الـ Listener
              addOrderCubit.addOrder(order: orderEntity);
            },
            child: const Text('تأكيد'),
          ),
        ],
      ),
    );
  }

  void _processPayment(BuildContext context) {
    final orderEntity = context.read<OrderInputEntity>();
    final addOrderCubit = context.read<AddOrderCubit>();
    final cartCubit = context.read<CartCubit>();

    if (cartCubit.currentCart.cartItems.isNotEmpty) {
      orderEntity.pharmacyId = cartCubit.currentCart.cartItems.first.pharmacyId ?? 'unknown';
    }
    
    orderEntity.prescriptionFile = cartCubit.prescriptionImage;

    TransactionModel transactionModel = TransactionModel.fromEntity(orderEntity);

    PayPalDebugger.checkout(
      context: context,
      clientId: clientPaypalKeyId,
      secretKey: secretpaypalKey,
      transactions: [transactionModel.toJson()],
      onSuccess: (response) {
        // 🔥 التعديل: إرسال الطلب فقط وانتظار النتيجة في الـ Listener
        addOrderCubit.addOrder(order: orderEntity);
      },
      onError: (error) => showBar(context, "فشلت عملية الدفع!", color: Colors.red),
      onCancel: () => showBar(context, "تم إلغاء عملية الدفع"),
    );
  }

  void _navigateToThankYouPage(BuildContext context) {
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => ThankYouView(key: UniqueKey()),
      ),
    );
  }

  String getNextButtonText(int page, BuildContext context) {
    var orderEntity = context.read<OrderInputEntity>();
    if (page == 2) {
      return orderEntity.payWithCash == true ? 'إتمام الطلب' : 'الدفع عبر PayPal';
    }
    return 'التالي';
  }
}