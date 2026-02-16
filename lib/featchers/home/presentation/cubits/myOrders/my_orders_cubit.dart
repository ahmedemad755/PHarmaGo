import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:e_commerce/core/repos/order_repo/orders_repo.dart';
import 'package:e_commerce/featchers/home/presentation/cubits/myOrders/my_orders_state.dart';

class OrdersCubit extends Cubit<OrdersState> {
  final OrdersRepo ordersRepo;
  StreamSubscription? _ordersSubscription;

  OrdersCubit(this.ordersRepo) : super(OrdersInitial());

  void fetchUserOrders({required String uID}) {
    emit(OrdersLoading());

    // إلغاء أي اشتراك قديم لتجنب تكرار البيانات
    _ordersSubscription?.cancel();

    _ordersSubscription = ordersRepo.fetchOrders(uID: uID).listen(
      (result) {
        result.fold(
          (failure) => emit(OrdersFailure(failure.message)),
          (orders) {
            // ترتيب الطلبات بحيث يظهر الأحدث في الأعلى
            orders.sort((a, b) => b.date.compareTo(a.date));
            emit(OrdersSuccess(orders));
          },
        );
      },
      onError: (e) {
        emit(OrdersFailure(e.toString()));
      },
    );
  }
  Future<void> cancelOrder(String orderId) async {
  // لا نحتاج لعمل emit لـ Loading لأن الـ Stream سيحدث القائمة تلقائياً فور نجاح التعديل في Firebase
  final result = await ordersRepo.cancelOrder(orderId: orderId);
  
  result.fold(
    (failure) => emit(OrdersFailure(failure.message)),
    (success) => null, // النجاح سيظهر لاحقاً عبر الـ listen الخاص بالـ Stream
  );
}

  @override
  Future<void> close() {
    _ordersSubscription?.cancel();
    return super.close();
  }
}