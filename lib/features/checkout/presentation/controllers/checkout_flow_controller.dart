import 'package:e_commerce/core/functions_helper/build_overlay_bar.dart';
import 'package:e_commerce/core/services/payment/paypal_debugger.dart';
import 'package:e_commerce/core/utils/app_key.dart';
import 'package:e_commerce/Features/cart/presentation/cubits/cart_cubit/cart_cubit.dart';
import 'package:e_commerce/Features/checkout/data/models/transaction_model.dart';
import 'package:e_commerce/Features/checkout/domain/enteteis/order_entity.dart';
import 'package:e_commerce/Features/checkout/presentation/manger/add_order_cubit/add_order_cubit.dart';
import 'package:e_commerce/Features/checkout/widgets/order_confirmation_dialog.dart';
import 'package:e_commerce/Features/checkout/widgets/prescription_required_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

/// يدير منطق التنقل بين خطوات الدفع (الشحن -> العنوان -> الدفع)، التحقق من
/// كل خطوة قبل الانتقال للي بعدها، ومعالجة الدفع - بعيداً عن الـ Widget.
class CheckoutFlowController {
  CheckoutFlowController({
    required this.pageController,
    required this.formKey,
    required this.valueListenable,
  });

  final PageController pageController;
  final GlobalKey<FormState> formKey;
  final ValueNotifier<AutovalidateMode> valueListenable;

  void handleNextStep(BuildContext context, int currentPageIndex) {
    if (currentPageIndex == 0) {
      _handleShippingSectionValidation(context);
    } else if (currentPageIndex == 1) {
      _handleAddressValidation(context);
    } else {
      _handleFinalStepValidation(context);
    }
  }

  String getNextButtonText(int page, BuildContext context) {
    final orderEntity = context.read<OrderInputEntity>();
    if (page == 2) {
      return orderEntity.payWithCash == true
          ? 'إتمام الطلب'
          : 'الدفع عبر PayPal';
    }
    return 'التالي';
  }

  void _handleShippingSectionValidation(BuildContext context) {
    final cartCubit = context.read<CartCubit>();
    final orderEntity = context.read<OrderInputEntity>();

    if (orderEntity.payWithCash != null) {
      if (cartCubit.isPrescriptionRequired &&
          cartCubit.prescriptionImage == null) {
        _showPrescriptionRequiredDialog(context);
        return;
      }
      _animateToNextPage();
    } else {
      showBar(context, 'يرجي تحديد طريقة الدفع');
    }
  }

  void _showPrescriptionRequiredDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => PrescriptionRequiredDialog(
        onUploadPressed: () => _pickPrescriptionImage(context),
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
      _animateToNextPage();
    } else {
      if (!context.mounted) return;
      showBar(context, 'يجب رفع الصورة للمتابعة', color: Colors.orange);
    }
  }

  void _handleAddressValidation(BuildContext context) {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      _animateToNextPage();
    } else {
      valueListenable.value = AutovalidateMode.always;
      showBar(context, 'يرجى إكمال بيانات العنوان');
    }
  }

  void _handleFinalStepValidation(BuildContext context) {
    final cartCubit = context.read<CartCubit>();
    final orderEntity = context.read<OrderInputEntity>();

    if (cartCubit.isPrescriptionRequired &&
        cartCubit.prescriptionImage == null) {
      showBar(
        context,
        'عذراً، الروشتة مفقودة. تم إرجاعك لرفعها.',
        color: Colors.orange,
      );
      pageController.animateToPage(
        0,
        duration: const Duration(milliseconds: 500),
        curve: Curves.ease,
      );
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
      detectedPharmacyId =
          cartCubit.currentCart.cartItems.first.pharmacyId ?? 'unknown';
    }

    showDialog(
      context: parentContext,
      barrierDismissible: false,
      builder: (dialogContext) => OrderConfirmationDialog(
        orderEntity: orderEntity,
        onConfirm: () {
          if (cartCubit.isPrescriptionRequired &&
              cartCubit.prescriptionImage == null) {
            showBar(
              parentContext,
              'خطأ: لم يتم العثور على صورة الروشتة!',
              color: Colors.red,
            );
            pageController.jumpToPage(0);
            return;
          }

          orderEntity.pharmacyId = detectedPharmacyId;
          orderEntity.prescriptionFile = cartCubit.prescriptionImage;
          addOrderCubit.addOrder(order: orderEntity);
        },
      ),
    );
  }

  void _processPayment(BuildContext context) {
    final orderEntity = context.read<OrderInputEntity>();
    final addOrderCubit = context.read<AddOrderCubit>();
    final cartCubit = context.read<CartCubit>();

    if (cartCubit.currentCart.cartItems.isNotEmpty) {
      orderEntity.pharmacyId =
          cartCubit.currentCart.cartItems.first.pharmacyId ?? 'unknown';
    }

    orderEntity.prescriptionFile = cartCubit.prescriptionImage;

    final transactionModel = TransactionModel.fromEntity(orderEntity);

    PayPalDebugger.checkout(
      context: context,
      clientId: clientPaypalKeyId,
      secretKey: secretpaypalKey,
      transactions: [transactionModel.toJson()],
      onSuccess: (response) => addOrderCubit.addOrder(order: orderEntity),
      onError: (error) =>
          showBar(context, "فشلت عملية الدفع!", color: Colors.red),
      onCancel: () => showBar(context, "تم إلغاء عملية الدفع"),
    );
  }

  void _animateToNextPage() {
    pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }
}
