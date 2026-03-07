import 'package:bloc/bloc.dart';
import 'package:e_commerce/core/repos/order_repo/orders_repo.dart';
import 'package:e_commerce/featchers/checkout/domain/enteteis/order_entity.dart';
import 'package:equatable/equatable.dart';

part 'add_order_state.dart';

class AddOrderCubit extends Cubit<AddOrderState> {
  final OrdersRepo ordersRepo;

  AddOrderCubit(this.ordersRepo) : super(AddOrderInitial());

  Future<void> addOrder({required OrderInputEntity order}) async {
    if (isClosed) return;
    emit(AddOrderLoading());

    try {
      // نرسل الأوردر فوراً والـ Repo هو من سيتولى رفع الصورة لو وجدت
      final result = await ordersRepo.addOrder(order: order);

      if (isClosed) return;

      result.fold(
        (failure) => emit(AddOrderFailure(failure.message)),
        (success) => emit(AddOrderSuccess()),
      );
    } catch (e) {
      if (!isClosed) emit(AddOrderFailure("حدث خطأ غير متوقع: $e"));
    }
  }
}