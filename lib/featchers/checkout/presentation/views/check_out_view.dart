import 'package:e_commerce/core/di/injection.dart';
import 'package:e_commerce/core/functions_helper/BlocStateHandler.dart';
import 'package:e_commerce/core/functions_helper/get_user_data.dart';
import 'package:e_commerce/core/repos/order_repo/orders_repo.dart';
import 'package:e_commerce/featchers/AUTH/widgets/build_app_bar.dart'
    show buildAppBar;
import 'package:e_commerce/featchers/checkout/domain/enteteis/order_entity.dart'
    show OrderInputEntity;
import 'package:e_commerce/featchers/checkout/domain/enteteis/shipping_address_entity.dart';
import 'package:e_commerce/featchers/checkout/presentation/manger/add_order_cubit/add_order_cubit.dart';
import 'package:e_commerce/featchers/checkout/widgets/checkout_view_body.dart';
import 'package:e_commerce/featchers/home/domain/enteties/cart_entety.dart'
    show CartEntity;
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
    orderInputEntity = OrderInputEntity(
      widget.cartEntity,
      uID: getUser().uId,
      shippingAddressEntity: ShippingAddressEntity(),
    );
  }

  @override
  Widget build(BuildContext context){
    return BlocProvider(
      create: (context) => AddOrderCubit(getIt.get<OrdersRepo>()),
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
