import 'package:e_commerce/core/enteties/cart_item_entety.dart';
import 'package:e_commerce/core/functions_helper/get_currunce.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'item_model.freezed.dart';
part 'item_model.g.dart';

@freezed
class ItemModel with _$ItemModel {
  const factory ItemModel({
    required String name,
    required int quantity,
    required String price,
    required String currency,
  }) = _ItemModel;

  factory ItemModel.fromJson(Map<String, dynamic> json) =>
      _$ItemModelFromJson(json);

  factory ItemModel.fromEntity(CartItemEntity itemEntity) => ItemModel(
    name: itemEntity.productIntety.name,
    quantity: itemEntity.quantty,
    price: itemEntity.productIntety.price.toString(),
    currency: getcurrency(),
  );
}
