// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'amount_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AmountModelImpl _$$AmountModelImplFromJson(Map<String, dynamic> json) =>
    _$AmountModelImpl(
      total: json['total'] as String,
      currency: json['currency'] as String,
      details: DetailsModel.fromJson(json['details'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$AmountModelImplToJson(_$AmountModelImpl instance) =>
    <String, dynamic>{
      'total': instance.total,
      'currency': instance.currency,
      'details': instance.details,
    };
