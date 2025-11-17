import 'package:e_commerce/featchers/checkout/domain/enteteis/order_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'details_model.freezed.dart';
part 'details_model.g.dart';

@freezed
class DetailsModel with _$DetailsModel {
  const factory DetailsModel({
    required String subtotal,
    required String shipping,
    @JsonKey(name: 'shipping_discount') required int shippingDiscount,
  }) = _DetailsModel;

  factory DetailsModel.fromJson(Map<String, dynamic> json) =>
      _$DetailsModelFromJson(json);
  factory DetailsModel.fromEntity(OrderInputEntity entity) => DetailsModel(
    subtotal: entity.cartEntity.getTotalPrice().toString(),
    shipping: entity.deliveryPrice.toString(),
    shippingDiscount: entity.shippingdescount(),
  );
}
