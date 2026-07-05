import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:e_commerce/Features/orders/domain/usecases/cancel_order_usecase.dart';
import 'package:e_commerce/Features/orders/domain/usecases/create_order_usecase.dart';
import 'package:e_commerce/Features/orders/domain/usecases/fetch_orders_usecase.dart';
import 'package:e_commerce/Features/orders/domain/usecases/upload_prescription_usecase.dart';
import 'package:e_commerce/core/services/notification/local_notification_service.dart';
import 'package:e_commerce/Features/orders/domain/entities/order_entity.dart';
import 'package:e_commerce/Features/orders/domain/entities/order_status.dart';
import 'package:e_commerce/Features/checkout/domain/enteteis/order_entity.dart';
import 'package:e_commerce/Features/orders/presentation/cubits/myOrders/my_orders_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrdersCubit extends Cubit<OrdersState> {
  OrdersCubit({
    required FetchOrdersUseCase fetchOrdersUseCase,
    required CancelOrderUseCase cancelOrderUseCase,
    required UploadPrescriptionUseCase uploadPrescriptionUseCase,
    required CreateOrderUseCase createOrderUseCase,
  }) : _fetchOrdersUseCase = fetchOrdersUseCase,
       _cancelOrderUseCase = cancelOrderUseCase,
       _uploadPrescriptionUseCase = uploadPrescriptionUseCase,
       _createOrderUseCase = createOrderUseCase,
       super(OrdersInitial());

  final FetchOrdersUseCase _fetchOrdersUseCase;
  final CancelOrderUseCase _cancelOrderUseCase;
  final UploadPrescriptionUseCase _uploadPrescriptionUseCase;
  final CreateOrderUseCase _createOrderUseCase;

  StreamSubscription? _ordersSubscription;

  void fetchUserOrders({required String uID}) {
    emit(OrdersLoading());

    _ordersSubscription?.cancel();

    _ordersSubscription = _fetchOrdersUseCase(uID: uID).listen((result) {
      result.fold((failure) => emit(OrdersFailure(failure.message)), (
        newOrders,
      ) {
        newOrders.sort((a, b) => b.createdAt.compareTo(a.createdAt));

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
    final result = await _cancelOrderUseCase(orderId: orderId);
    result.fold(
      (failure) => emit(OrdersFailure(failure.message)),
      (success) => null,
    );
  }

  Future<void> sendPrescriptionOrder({required OrderInputEntity order}) async {
    emit(OrdersLoading()); // ممكن تستخدم State مخصص للرفع لو حبيت

    // 1. رفع الصورة أولاً
    final uploadResult = await _uploadPrescriptionUseCase(
      File(order.prescriptionFile!.path),
    );

    await uploadResult.fold(
      (failure) async => emit(OrdersFailure(failure.message)),
      (imageUrl) async {
        // 2. تحديث الـ Entity بالرابط والحالة
        order.prescriptionImageUrl = imageUrl;

        // 3. إرسال الأوردر لـ Firestore
        final result = await _createOrderUseCase(order: order);
        result.fold(
          (failure) => emit(OrdersFailure(failure.message)),
          (success) => emit(OrdersSuccess([], hasNotification: false)),
          // ملاحظة: الـ Success هنا ممكن يرجعك لصفحة الطلبات
        );
      },
    );
  }

  // دالتك اللي بتقارن الحالات (موجودة وسليمة)
  bool _hasStatusChanged(List<OrderEntity> oldList, List<OrderEntity> newList) {
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
    List<OrderEntity> oldList,
    List<OrderEntity> newList,
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
              "طلبك رقم ${newOrder.orderId.substring(0, 8)} أصبح الآن: ${_arabicStatusLabel(newOrder.status)}",
          payload: jsonEncode({
            'source': 'PHARMA_GO_APP', // إضافة علامة مميزة للتطبيق
            'type': 'order_update',
            'orderId': newOrder.orderId,
          }),
        );
      }
    }
  }

  String _arabicStatusLabel(OrderStatus status) {
    switch (status) {
      case OrderStatus.awaitingPricing:
        return "في انتظار تسعير الصيدلية";
      case OrderStatus.pending:
        return "قيد المراجعة";
      case OrderStatus.accepted:
        return "تم القبول";
      case OrderStatus.preparing:
        return "جاري التجهيز";
      case OrderStatus.delivering:
        return "جاري التوصيل";
      case OrderStatus.delivered:
        return "تم الاستلام";
      case OrderStatus.cancelled:
        return "ملغي";
    }
  }

  @override
  Future<void> close() {
    _ordersSubscription?.cancel();
    return super.close();
  }
}
