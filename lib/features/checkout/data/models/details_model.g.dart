// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'details_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DetailsModelImpl _$$DetailsModelImplFromJson(Map<String, dynamic> json) =>
    _$DetailsModelImpl(
      subtotal: json['subtotal'] as String,
      shipping: json['shipping'] as String,
      shippingDiscount: (json['shipping_discount'] as num).toInt(),
    );

Map<String, dynamic> _$$DetailsModelImplToJson(_$DetailsModelImpl instance) =>
    <String, dynamic>{
      'subtotal': instance.subtotal,
      'shipping': instance.shipping,
      'shipping_discount': instance.shippingDiscount,
    };
