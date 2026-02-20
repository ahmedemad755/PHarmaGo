import 'package:bloc/bloc.dart';
import 'package:e_commerce/core/repos/order_repo/orders_repo.dart';
import 'package:e_commerce/featchers/checkout/domain/enteteis/order_entity.dart';
import 'package:equatable/equatable.dart';

part 'add_order_state.dart';

class AddOrderCubit extends Cubit<AddOrderState> {
  final OrdersRepo ordersRepo;
  AddOrderCubit(this.ordersRepo) : super(AddOrderInitial());

  Future<void> addOrder({required OrderInputEntity order}) async {
    // التأكد من عدم محاولة إرسال حالة إذا تم إغلاق الكيوبت مسبقاً
    if (isClosed) return;

    emit(AddOrderLoading());

    final result = await ordersRepo.addOrder(order: order);

    // حماية (Safe Guard): نفحص إذا كان الكيوبت قد أُغلق أثناء انتظار الرد من السيرفر
    // هذا يمنع خطأ "Cannot emit new states after calling close"
    if (isClosed) return;

    result.fold(
      (failure) {
        emit(AddOrderFailure(failure.message));
      },
      (success) {
        emit(AddOrderSuccess());
      },
    );
  }

  @override
  Future<void> close() {
    // يمكنك إضافة أي عمليات تنظيف هنا إذا لزم الأمر
    return super.close();
  }
}