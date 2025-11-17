// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'details_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

DetailsModel _$DetailsModelFromJson(Map<String, dynamic> json) {
  return _DetailsModel.fromJson(json);
}

/// @nodoc
mixin _$DetailsModel {
  String get subtotal => throw _privateConstructorUsedError;
  String get shipping => throw _privateConstructorUsedError;
  @JsonKey(name: 'shipping_discount')
  int get shippingDiscount => throw _privateConstructorUsedError;

  /// Serializes this DetailsModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DetailsModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DetailsModelCopyWith<DetailsModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DetailsModelCopyWith<$Res> {
  factory $DetailsModelCopyWith(
    DetailsModel value,
    $Res Function(DetailsModel) then,
  ) = _$DetailsModelCopyWithImpl<$Res, DetailsModel>;
  @useResult
  $Res call({
    String subtotal,
    String shipping,
    @JsonKey(name: 'shipping_discount') int shippingDiscount,
  });
}

/// @nodoc
class _$DetailsModelCopyWithImpl<$Res, $Val extends DetailsModel>
    implements $DetailsModelCopyWith<$Res> {
  _$DetailsModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DetailsModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? subtotal = null,
    Object? shipping = null,
    Object? shippingDiscount = null,
  }) {
    return _then(
      _value.copyWith(
            subtotal: null == subtotal
                ? _value.subtotal
                : subtotal // ignore: cast_nullable_to_non_nullable
                      as String,
            shipping: null == shipping
                ? _value.shipping
                : shipping // ignore: cast_nullable_to_non_nullable
                      as String,
            shippingDiscount: null == shippingDiscount
                ? _value.shippingDiscount
                : shippingDiscount // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$DetailsModelImplCopyWith<$Res>
    implements $DetailsModelCopyWith<$Res> {
  factory _$$DetailsModelImplCopyWith(
    _$DetailsModelImpl value,
    $Res Function(_$DetailsModelImpl) then,
  ) = __$$DetailsModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String subtotal,
    String shipping,
    @JsonKey(name: 'shipping_discount') int shippingDiscount,
  });
}

/// @nodoc
class __$$DetailsModelImplCopyWithImpl<$Res>
    extends _$DetailsModelCopyWithImpl<$Res, _$DetailsModelImpl>
    implements _$$DetailsModelImplCopyWith<$Res> {
  __$$DetailsModelImplCopyWithImpl(
    _$DetailsModelImpl _value,
    $Res Function(_$DetailsModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DetailsModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? subtotal = null,
    Object? shipping = null,
    Object? shippingDiscount = null,
  }) {
    return _then(
      _$DetailsModelImpl(
        subtotal: null == subtotal
            ? _value.subtotal
            : subtotal // ignore: cast_nullable_to_non_nullable
                  as String,
        shipping: null == shipping
            ? _value.shipping
            : shipping // ignore: cast_nullable_to_non_nullable
                  as String,
        shippingDiscount: null == shippingDiscount
            ? _value.shippingDiscount
            : shippingDiscount // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$DetailsModelImpl implements _DetailsModel {
  const _$DetailsModelImpl({
    required this.subtotal,
    required this.shipping,
    @JsonKey(name: 'shipping_discount') required this.shippingDiscount,
  });

  factory _$DetailsModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$DetailsModelImplFromJson(json);

  @override
  final String subtotal;
  @override
  final String shipping;
  @override
  @JsonKey(name: 'shipping_discount')
  final int shippingDiscount;

  @override
  String toString() {
    return 'DetailsModel(subtotal: $subtotal, shipping: $shipping, shippingDiscount: $shippingDiscount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DetailsModelImpl &&
            (identical(other.subtotal, subtotal) ||
                other.subtotal == subtotal) &&
            (identical(other.shipping, shipping) ||
                other.shipping == shipping) &&
            (identical(other.shippingDiscount, shippingDiscount) ||
                other.shippingDiscount == shippingDiscount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, subtotal, shipping, shippingDiscount);

  /// Create a copy of DetailsModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DetailsModelImplCopyWith<_$DetailsModelImpl> get copyWith =>
      __$$DetailsModelImplCopyWithImpl<_$DetailsModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DetailsModelImplToJson(this);
  }
}

abstract class _DetailsModel implements DetailsModel {
  const factory _DetailsModel({
    required final String subtotal,
    required final String shipping,
    @JsonKey(name: 'shipping_discount') required final int shippingDiscount,
  }) = _$DetailsModelImpl;

  factory _DetailsModel.fromJson(Map<String, dynamic> json) =
      _$DetailsModelImpl.fromJson;

  @override
  String get subtotal;
  @override
  String get shipping;
  @override
  @JsonKey(name: 'shipping_discount')
  int get shippingDiscount;

  /// Create a copy of DetailsModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DetailsModelImplCopyWith<_$DetailsModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
