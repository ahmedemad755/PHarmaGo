import 'dart:async';
import 'dart:convert';

import 'package:e_commerce/core/repos/order_repo/orders_repo.dart';
import 'package:e_commerce/core/services/local_notification_service.dart';
import 'package:e_commerce/featchers/checkout/data/order_model.dart';
import 'package:e_commerce/featchers/home/presentation/cubits/myOrders/my_orders_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrdersCubit extends Cubit<OrdersState> {
  final OrdersRepo ordersRepo;
  StreamSubscription? _ordersSubscription;

  OrdersCubit(this.ordersRepo) : super(OrdersInitial());

  void fetchUserOrders({required String uID}) {
    emit(OrdersLoading());

    _ordersSubscription?.cancel();

    _ordersSubscription = ordersRepo.fetchOrders(uID: uID).listen(
      (result) {
        result.fold(
          (failure) => emit(OrdersFailure(failure.message)),
          (newOrders) {
            newOrders.sort((a, b) => b.date.compareTo(a.date));

            // --- المنطق الجديد للإشعارات يبدأ هنا ---
            bool showBadge = false;

            if (state is OrdersSuccess) {
              final oldOrders = (state as OrdersSuccess).orders;
              _checkAndNotifyStatusChange(oldOrders, newOrders);
              // بنقارن القائمة القديمة بالجديدة باستخدام الدالة اللي أنت كاتبها تحت
              if (newOrders.length > oldOrders.length || _hasStatusChanged(oldOrders, newOrders)) {
                showBadge = true; 
              } else {
                // لو مفيش جديد، بنحافظ على حالة الجرس زي ما هي (لو كان منور يفضل منور)
                showBadge = (state as OrdersSuccess).hasNotification;
              }
            }
            // بنبعث الحالة الجديدة ومعاها قرار "الجرس ينور ولا لأ"
            emit(OrdersSuccess(newOrders, hasNotification: showBadge));
            // --- المنطق الجديد للإشعارات ينتهي هنا ---
          },
        );
      },
      onError: (e) => emit(OrdersFailure(e.toString())),
    );
  }

  // دالة الإلغاء (موجودة وسليمة)
  Future<void> cancelOrder(String orderId) async {
    final result = await ordersRepo.cancelOrder(orderId: orderId);
    result.fold(
      (failure) => emit(OrdersFailure(failure.message)),
      (success) => null, 
    );
  }

  // دالتك اللي بتقارن الحالات (موجودة وسليمة)
  bool _hasStatusChanged(List<OrderModel> oldList, List<OrderModel> newList) {
    for (var newOrder in newList) {
      final oldOrder = oldList.firstWhere(
        (o) => o.orderId == newOrder.orderId, 
        orElse: () => newOrder
      );
      if (oldOrder.status != newOrder.status) return true;
    }
    return false;
  }

  // دالة تصفير العداد (موجودة وسليمة)
  void clearNotificationBadge() {
    if (state is OrdersSuccess) {
      final currentOrders = (state as OrdersSuccess).orders;
      emit(OrdersSuccess(currentOrders, hasNotification: false));
    }
  }
  void _checkAndNotifyStatusChange(List<OrderModel> oldList, List<OrderModel> newList) {
    for (var newOrder in newList) {
      final oldOrder = oldList.firstWhere(
        (o) => o.orderId == newOrder.orderId, 
        orElse: () => newOrder
      );
      
// داخل دالة _checkAndNotifyStatusChange في الـ Cubit
if (oldOrder.status != newOrder.status) {
// داخل OrdersCubit
LocalNotificationService.showInstantNotification(
  title: "تحديث الطلب 📦",
  body: "طلبك رقم ${newOrder.orderId.substring(0,8)} أصبح الآن: ${newOrder.status}",
  payload: jsonEncode({
    'source': 'PHARMA_GO_APP', // إضافة علامة مميزة للتطبيق
    'type': 'order_update',
    'orderId': newOrder.orderId,
  }),
);
}
    }
  }

  @override
  Future<void> close() {
    _ordersSubscription?.cancel();
    return super.close();
  }
}