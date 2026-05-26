import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:e_commerce/core/repos/order_repo/orders_repo.dart';
import 'package:e_commerce/core/services/notification_service_local_push/local_notification_service.dart';
import 'package:e_commerce/featchers/checkout/data/order_model.dart';
import 'package:e_commerce/featchers/checkout/domain/enteteis/order_entity.dart';
import 'package:e_commerce/featchers/home/presentation/cubits/myOrders/my_orders_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrdersCubit extends Cubit<OrdersState> {
  final OrdersRepo ordersRepo;
  StreamSubscription? _ordersSubscription;

  OrdersCubit(this.ordersRepo) : super(OrdersInitial());

  void fetchUserOrders({required String uID}) {
    emit(OrdersLoading());

    _ordersSubscription?.cancel();

    _ordersSubscription = ordersRepo.fetchOrders(uID: uID).listen((result) {
      result.fold((failure) => emit(OrdersFailure(failure.message)), (
        newOrders,
      ) {
        newOrders.sort((a, b) => b.date.compareTo(a.date));

        // --- المنطق الجديد للإشعارات يبدأ هنا ---
        bool showBadge = false;

        if (state is OrdersSuccess) {
          final oldOrders = (state as OrdersSuccess).orders;
          _checkAndNotifyStatusChange(oldOrders, newOrders);
          // بنقارن القائمة القديمة بالجديدة باستخدام الدالة اللي أنت كاتبها تحت
          if (newOrders.length > oldOrders.length ||
              _hasStatusChanged(oldOrders, newOrders)) {
            showBadge = true;
          } else {
            // لو مفيش جديد، بنحافظ على حالة الجرس زي ما هي (لو كان منور يفضل منور)
            showBadge = (state as OrdersSuccess).hasNotification;
          }
        }
        // بنبعث الحالة الجديدة ومعاها قرار "الجرس ينور ولا لأ"
        emit(OrdersSuccess(newOrders, hasNotification: showBadge));
        // --- المنطق الجديد للإشعارات ينتهي هنا ---
      });
    }, onError: (e) => emit(OrdersFailure(e.toString())));
  }

  // دالة الإلغاء (موجودة وسليمة)
  Future<void> cancelOrder(String orderId) async {
    final result = await ordersRepo.cancelOrder(orderId: orderId);
    result.fold(
      (failure) => emit(OrdersFailure(failure.message)),
      (success) => null,
    );
  }

  Future<void> sendPrescriptionOrder({required OrderInputEntity order}) async {
    emit(OrdersLoading()); // ممكن تستخدم State مخصص للرفع لو حبيت

    // 1. رفع الصورة أولاً
    final uploadResult = await ordersRepo.uploadPrescription(
      File(order.prescriptionFile!.path),
    );

    await uploadResult.fold(
      (failure) async => emit(OrdersFailure(failure.message)),
      (imageUrl) async {
        // 2. تحديث الـ Entity بالرابط والحالة
        order.prescriptionImageUrl = imageUrl;

        // 3. إرسال الأوردر لـ Firestore
        final result = await ordersRepo.addOrder(order: order);
        result.fold(
          (failure) => emit(OrdersFailure(failure.message)),
          (success) => emit(OrdersSuccess([], hasNotification: false)),
          // ملاحظة: الـ Success هنا ممكن يرجعك لصفحة الطلبات
        );
      },
    );
  }

  // دالتك اللي بتقارن الحالات (موجودة وسليمة)
  bool _hasStatusChanged(List<OrderModel> oldList, List<OrderModel> newList) {
    for (var newOrder in newList) {
      final oldOrder = oldList.firstWhere(
        (o) => o.orderId == newOrder.orderId,
        orElse: () => newOrder,
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

  void _checkAndNotifyStatusChange(
    List<OrderModel> oldList,
    List<OrderModel> newList,
  ) {
    for (var newOrder in newList) {
      final oldOrder = oldList.firstWhere(
        (o) => o.orderId == newOrder.orderId,
        orElse: () => newOrder,
      );

      // داخل دالة _checkAndNotifyStatusChange في الـ Cubit
      if (oldOrder.status != newOrder.status) {
        // داخل OrdersCubit
        LocalNotificationService.showInstantNotification(
          title: "تحديث الطلب 📦",
          body:
              "طلبك رقم ${newOrder.orderId.substring(0, 8)} أصبح الآن: ${newOrder.status}",
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
