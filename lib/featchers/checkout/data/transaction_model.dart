import 'package:e_commerce/featchers/checkout/data/item_model.dart';
import 'package:e_commerce/featchers/checkout/domain/enteteis/order_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'amount_model.dart';
import 'item_list_model.dart';

part 'transaction_model.freezed.dart';
part 'transaction_model.g.dart';

@freezed
class TransactionModel with _$TransactionModel {
  const factory TransactionModel({
    required AmountModel amount,
    required String description,
    @JsonKey(name: 'item_list') required ItemListModel itemList,
  }) = _TransactionModel;

  factory TransactionModel.fromJson(Map<String, dynamic> json) =>
      _$TransactionModelFromJson(json);

  factory TransactionModel.fromEntity(OrderInputEntity entity) =>
      TransactionModel(
        amount: AmountModel.fromEntity(entity),
        description: "payment descreption",
        itemList: ItemListModel(
          items: entity.cartEntity.cartItems
              .map((item) => ItemModel.fromEntity(item))
              .toList(),
        ),
      );
}
