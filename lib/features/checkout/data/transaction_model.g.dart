// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TransactionModelImpl _$$TransactionModelImplFromJson(
  Map<String, dynamic> json,
) => _$TransactionModelImpl(
  amount: AmountModel.fromJson(json['amount'] as Map<String, dynamic>),
  description: json['description'] as String,
  itemList: ItemListModel.fromJson(json['item_list'] as Map<String, dynamic>),
);

Map<String, dynamic> _$$TransactionModelImplToJson(
  _$TransactionModelImpl instance,
) => <String, dynamic>{
  'amount': instance.amount,
  'description': instance.description,
  'item_list': instance.itemList,
};
