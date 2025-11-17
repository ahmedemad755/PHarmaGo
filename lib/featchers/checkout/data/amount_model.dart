import 'package:e_commerce/core/functions_helper/get_currunce.dart';
import 'package:e_commerce/featchers/checkout/domain/enteteis/order_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'details_model.dart';

part 'amount_model.freezed.dart';
part 'amount_model.g.dart';

@freezed
class AmountModel with _$AmountModel {
  const factory AmountModel({
    required String total,
    required String currency,
    required DetailsModel details,
  }) = _AmountModel;

  factory AmountModel.fromJson(Map<String, dynamic> json) =>
      _$AmountModelFromJson(json);

  factory AmountModel.fromEntity(OrderInputEntity entity) => AmountModel(
    total: entity.calculatetotalpriceAfterDiscountAndDelivery().toString(),
    currency: getcurrency(),
    details: DetailsModel.fromEntity(entity),
  );
}
