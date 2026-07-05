import 'package:bloc/bloc.dart';
import 'package:e_commerce/Features/orders/domain/usecases/create_order_usecase.dart';
import 'package:e_commerce/Features/checkout/domain/enteteis/order_entity.dart';
import 'package:equatable/equatable.dart';

part 'add_order_state.dart';

class AddOrderCubit extends Cubit<AddOrderState> {
  AddOrderCubit(this._createOrderUseCase) : super(AddOrderInitial());

  final CreateOrderUseCase _createOrderUseCase;

  Future<void> addOrder({required OrderInputEntity order}) async {
    if (isClosed) return;
    emit(AddOrderLoading());

    try {
      // نرسل الأوردر فوراً والـ UseCase هو من سيتولى رفع الصورة لو وجدت
      final result = await _createOrderUseCase(order: order);

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
