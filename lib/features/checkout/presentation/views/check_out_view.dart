import 'package:e_commerce/Features/auth/widgets/build_app_bar.dart';
import 'package:e_commerce/core/di/injection.dart';
import 'package:e_commerce/core/functions_helper/BlocStateHandler.dart';
import 'package:e_commerce/core/functions_helper/get_user_data.dart';

import 'package:e_commerce/Features/cart/domain/enteties/cart_entety.dart';
import 'package:e_commerce/Features/checkout/domain/enteteis/order_entity.dart'
    show OrderInputEntity;
import 'package:e_commerce/Features/checkout/domain/enteteis/shipping_address_entity.dart';
import 'package:e_commerce/Features/checkout/presentation/manger/add_order_cubit/add_order_cubit.dart';
import 'package:e_commerce/Features/checkout/widgets/checkout_view_body.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class CheckOutView extends StatefulWidget {
  const CheckOutView({super.key, required this.cartEntity});
  final CartEntity cartEntity;

  @override
  State<CheckOutView> createState() => _CheckOutViewState();
}

class _CheckOutViewState extends State<CheckOutView> {
  late OrderInputEntity orderInputEntity;

  @override
  void initState() {
    super.initState();

    // 🔹 استخراج pharmacyId من أول منتج في السلة لربط الطلب بصيدلية معينة
    // نستخدم 'unknown' كقيمة احتياطية لتجنب الـ null
    String pharmacyId = widget.cartEntity.cartItems.isNotEmpty
        ? widget.cartEntity.cartItems.first.pharmacyId ?? 'unknown'
        : 'unknown';

    orderInputEntity = OrderInputEntity(
      widget.cartEntity,
      uID: getUser().uId,

      pharmacyId: pharmacyId, // ✅ التعديل الجديد لتمرير المعرف
      shippingAddressEntity: ShippingAddressEntity(),
      userName: getUser().name,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<AddOrderCubit>(),
      child: Scaffold(
        appBar: buildAppBar(context, title: 'الشحن', showNotification: false),
        body: Provider.value(
          value: orderInputEntity,
          child: BlocStateHandler(child: CheckoutViewBody()),
        ),
      ),
    );
  }
}
