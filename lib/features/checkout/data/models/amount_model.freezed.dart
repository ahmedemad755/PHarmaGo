// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'amount_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

AmountModel _$AmountModelFromJson(Map<String, dynamic> json) {
  return _AmountModel.fromJson(json);
}

/// @nodoc
mixin _$AmountModel {
  String get total => throw _privateConstructorUsedError;
  String get currency => throw _privateConstructorUsedError;
  DetailsModel get details => throw _privateConstructorUsedError;

  /// Serializes this AmountModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AmountModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AmountModelCopyWith<AmountModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AmountModelCopyWith<$Res> {
  factory $AmountModelCopyWith(
    AmountModel value,
    $Res Function(AmountModel) then,
  ) = _$AmountModelCopyWithImpl<$Res, AmountModel>;
  @useResult
  $Res call({String total, String currency, DetailsModel details});

  $DetailsModelCopyWith<$Res> get details;
}

/// @nodoc
class _$AmountModelCopyWithImpl<$Res, $Val extends AmountModel>
    implements $AmountModelCopyWith<$Res> {
  _$AmountModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AmountModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? total = null,
    Object? currency = null,
    Object? details = null,
  }) {
    return _then(
      _value.copyWith(
            total: null == total
                ? _value.total
                : total // ignore: cast_nullable_to_non_nullable
                      as String,
            currency: null == currency
                ? _value.currency
                : currency // ignore: cast_nullable_to_non_nullable
                      as String,
            details: null == details
                ? _value.details
                : details // ignore: cast_nullable_to_non_nullable
                      as DetailsModel,
          )
          as $Val,
    );
  }

  /// Create a copy of AmountModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $DetailsModelCopyWith<$Res> get details {
    return $DetailsModelCopyWith<$Res>(_value.details, (value) {
      return _then(_value.copyWith(details: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$AmountModelImplCopyWith<$Res>
    implements $AmountModelCopyWith<$Res> {
  factory _$$AmountModelImplCopyWith(
    _$AmountModelImpl value,
    $Res Function(_$AmountModelImpl) then,
  ) = __$$AmountModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String total, String currency, DetailsModel details});

  @override
  $DetailsModelCopyWith<$Res> get details;
}

/// @nodoc
class __$$AmountModelImplCopyWithImpl<$Res>
    extends _$AmountModelCopyWithImpl<$Res, _$AmountModelImpl>
    implements _$$AmountModelImplCopyWith<$Res> {
  __$$AmountModelImplCopyWithImpl(
    _$AmountModelImpl _value,
    $Res Function(_$AmountModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AmountModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? total = null,
    Object? currency = null,
    Object? details = null,
  }) {
    return _then(
      _$AmountModelImpl(
        total: null == total
            ? _value.total
            : total // ignore: cast_nullable_to_non_nullable
                  as String,
        currency: null == currency
            ? _value.currency
            : currency // ignore: cast_nullable_to_non_nullable
                  as String,
        details: null == details
            ? _value.details
            : details // ignore: cast_nullable_to_non_nullable
                  as DetailsModel,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AmountModelImpl implements _AmountModel {
  const _$AmountModelImpl({
    required this.total,
    required this.currency,
    required this.details,
  });

  factory _$AmountModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$AmountModelImplFromJson(json);

  @override
  final String total;
  @override
  final String currency;
  @override
  final DetailsModel details;

  @override
  String toString() {
    return 'AmountModel(total: $total, currency: $currency, details: $details)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AmountModelImpl &&
            (identical(other.total, total) || other.total == total) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.details, details) || other.details == details));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, total, currency, details);

  /// Create a copy of AmountModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AmountModelImplCopyWith<_$AmountModelImpl> get copyWith =>
      __$$AmountModelImplCopyWithImpl<_$AmountModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AmountModelImplToJson(this);
  }
}

abstract class _AmountModel implements AmountModel {
  const factory _AmountModel({
    required final String total,
    required final String currency,
    required final DetailsModel details,
  }) = _$AmountModelImpl;

  factory _AmountModel.fromJson(Map<String, dynamic> json) =
      _$AmountModelImpl.fromJson;

  @override
  String get total;
  @override
  String get currency;
  @override
  DetailsModel get details;

  /// Create a copy of AmountModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AmountModelImplCopyWith<_$AmountModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
