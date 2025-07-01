// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transfer_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TransferModel {
  String? get id;
  String? get userId;
  String? get fromCurrency;
  String? get toCurrency;
  double? get fromBalance;
  double? get toBalance;
  DateTime? get updateDate;
  DateTime? get timestamp;

  /// Create a copy of TransferModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $TransferModelCopyWith<TransferModel> get copyWith =>
      _$TransferModelCopyWithImpl<TransferModel>(
          this as TransferModel, _$identity);

  /// Serializes this TransferModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is TransferModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.fromCurrency, fromCurrency) ||
                other.fromCurrency == fromCurrency) &&
            (identical(other.toCurrency, toCurrency) ||
                other.toCurrency == toCurrency) &&
            (identical(other.fromBalance, fromBalance) ||
                other.fromBalance == fromBalance) &&
            (identical(other.toBalance, toBalance) ||
                other.toBalance == toBalance) &&
            (identical(other.updateDate, updateDate) ||
                other.updateDate == updateDate) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, userId, fromCurrency,
      toCurrency, fromBalance, toBalance, updateDate, timestamp);

  @override
  String toString() {
    return 'TransferModel(id: $id, userId: $userId, fromCurrency: $fromCurrency, toCurrency: $toCurrency, fromBalance: $fromBalance, toBalance: $toBalance, updateDate: $updateDate, timestamp: $timestamp)';
  }
}

/// @nodoc
abstract mixin class $TransferModelCopyWith<$Res> {
  factory $TransferModelCopyWith(
          TransferModel value, $Res Function(TransferModel) _then) =
      _$TransferModelCopyWithImpl;
  @useResult
  $Res call(
      {String? id,
      String? userId,
      String? fromCurrency,
      String? toCurrency,
      double? fromBalance,
      double? toBalance,
      DateTime? updateDate,
      DateTime? timestamp});
}

/// @nodoc
class _$TransferModelCopyWithImpl<$Res>
    implements $TransferModelCopyWith<$Res> {
  _$TransferModelCopyWithImpl(this._self, this._then);

  final TransferModel _self;
  final $Res Function(TransferModel) _then;

  /// Create a copy of TransferModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? userId = freezed,
    Object? fromCurrency = freezed,
    Object? toCurrency = freezed,
    Object? fromBalance = freezed,
    Object? toBalance = freezed,
    Object? updateDate = freezed,
    Object? timestamp = freezed,
  }) {
    return _then(_self.copyWith(
      id: freezed == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      userId: freezed == userId
          ? _self.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String?,
      fromCurrency: freezed == fromCurrency
          ? _self.fromCurrency
          : fromCurrency // ignore: cast_nullable_to_non_nullable
              as String?,
      toCurrency: freezed == toCurrency
          ? _self.toCurrency
          : toCurrency // ignore: cast_nullable_to_non_nullable
              as String?,
      fromBalance: freezed == fromBalance
          ? _self.fromBalance
          : fromBalance // ignore: cast_nullable_to_non_nullable
              as double?,
      toBalance: freezed == toBalance
          ? _self.toBalance
          : toBalance // ignore: cast_nullable_to_non_nullable
              as double?,
      updateDate: freezed == updateDate
          ? _self.updateDate
          : updateDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      timestamp: freezed == timestamp
          ? _self.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _TransferModel implements TransferModel {
  _TransferModel(
      {this.id,
      this.userId,
      this.fromCurrency,
      this.toCurrency,
      this.fromBalance,
      this.toBalance,
      this.updateDate,
      this.timestamp});
  factory _TransferModel.fromJson(Map<String, dynamic> json) =>
      _$TransferModelFromJson(json);

  @override
  final String? id;
  @override
  final String? userId;
  @override
  final String? fromCurrency;
  @override
  final String? toCurrency;
  @override
  final double? fromBalance;
  @override
  final double? toBalance;
  @override
  final DateTime? updateDate;
  @override
  final DateTime? timestamp;

  /// Create a copy of TransferModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$TransferModelCopyWith<_TransferModel> get copyWith =>
      __$TransferModelCopyWithImpl<_TransferModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$TransferModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _TransferModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.fromCurrency, fromCurrency) ||
                other.fromCurrency == fromCurrency) &&
            (identical(other.toCurrency, toCurrency) ||
                other.toCurrency == toCurrency) &&
            (identical(other.fromBalance, fromBalance) ||
                other.fromBalance == fromBalance) &&
            (identical(other.toBalance, toBalance) ||
                other.toBalance == toBalance) &&
            (identical(other.updateDate, updateDate) ||
                other.updateDate == updateDate) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, userId, fromCurrency,
      toCurrency, fromBalance, toBalance, updateDate, timestamp);

  @override
  String toString() {
    return 'TransferModel(id: $id, userId: $userId, fromCurrency: $fromCurrency, toCurrency: $toCurrency, fromBalance: $fromBalance, toBalance: $toBalance, updateDate: $updateDate, timestamp: $timestamp)';
  }
}

/// @nodoc
abstract mixin class _$TransferModelCopyWith<$Res>
    implements $TransferModelCopyWith<$Res> {
  factory _$TransferModelCopyWith(
          _TransferModel value, $Res Function(_TransferModel) _then) =
      __$TransferModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String? id,
      String? userId,
      String? fromCurrency,
      String? toCurrency,
      double? fromBalance,
      double? toBalance,
      DateTime? updateDate,
      DateTime? timestamp});
}

/// @nodoc
class __$TransferModelCopyWithImpl<$Res>
    implements _$TransferModelCopyWith<$Res> {
  __$TransferModelCopyWithImpl(this._self, this._then);

  final _TransferModel _self;
  final $Res Function(_TransferModel) _then;

  /// Create a copy of TransferModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = freezed,
    Object? userId = freezed,
    Object? fromCurrency = freezed,
    Object? toCurrency = freezed,
    Object? fromBalance = freezed,
    Object? toBalance = freezed,
    Object? updateDate = freezed,
    Object? timestamp = freezed,
  }) {
    return _then(_TransferModel(
      id: freezed == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      userId: freezed == userId
          ? _self.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String?,
      fromCurrency: freezed == fromCurrency
          ? _self.fromCurrency
          : fromCurrency // ignore: cast_nullable_to_non_nullable
              as String?,
      toCurrency: freezed == toCurrency
          ? _self.toCurrency
          : toCurrency // ignore: cast_nullable_to_non_nullable
              as String?,
      fromBalance: freezed == fromBalance
          ? _self.fromBalance
          : fromBalance // ignore: cast_nullable_to_non_nullable
              as double?,
      toBalance: freezed == toBalance
          ? _self.toBalance
          : toBalance // ignore: cast_nullable_to_non_nullable
              as double?,
      updateDate: freezed == updateDate
          ? _self.updateDate
          : updateDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      timestamp: freezed == timestamp
          ? _self.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

// dart format on
