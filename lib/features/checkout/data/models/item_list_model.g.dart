// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item_list_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ItemListModelImpl _$$ItemListModelImplFromJson(Map<String, dynamic> json) =>
    _$ItemListModelImpl(
      items: (json['items'] as List<dynamic>)
          .map((e) => ItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$ItemListModelImplToJson(_$ItemListModelImpl instance) =>
    <String, dynamic>{'items': instance.items};
