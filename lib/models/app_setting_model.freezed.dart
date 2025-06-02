// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_setting_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AppSettingModel {
  List<AboutAppModel>? get abouts;
  List<XpEarnModel>? get xpEarn;
  List<XpInSoModel>? get xpInso;
  List<UserLevelModel>? get userLevel;

  /// Create a copy of AppSettingModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AppSettingModelCopyWith<AppSettingModel> get copyWith =>
      _$AppSettingModelCopyWithImpl<AppSettingModel>(
          this as AppSettingModel, _$identity);

  /// Serializes this AppSettingModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AppSettingModel &&
            const DeepCollectionEquality().equals(other.abouts, abouts) &&
            const DeepCollectionEquality().equals(other.xpEarn, xpEarn) &&
            const DeepCollectionEquality().equals(other.xpInso, xpInso) &&
            const DeepCollectionEquality().equals(other.userLevel, userLevel));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(abouts),
      const DeepCollectionEquality().hash(xpEarn),
      const DeepCollectionEquality().hash(xpInso),
      const DeepCollectionEquality().hash(userLevel));

  @override
  String toString() {
    return 'AppSettingModel(abouts: $abouts, xpEarn: $xpEarn, xpInso: $xpInso, userLevel: $userLevel)';
  }
}

/// @nodoc
abstract mixin class $AppSettingModelCopyWith<$Res> {
  factory $AppSettingModelCopyWith(
          AppSettingModel value, $Res Function(AppSettingModel) _then) =
      _$AppSettingModelCopyWithImpl;
  @useResult
  $Res call(
      {List<AboutAppModel>? abouts,
      List<XpEarnModel>? xpEarn,
      List<XpInSoModel>? xpInso,
      List<UserLevelModel>? userLevel});
}

/// @nodoc
class _$AppSettingModelCopyWithImpl<$Res>
    implements $AppSettingModelCopyWith<$Res> {
  _$AppSettingModelCopyWithImpl(this._self, this._then);

  final AppSettingModel _self;
  final $Res Function(AppSettingModel) _then;

  /// Create a copy of AppSettingModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? abouts = freezed,
    Object? xpEarn = freezed,
    Object? xpInso = freezed,
    Object? userLevel = freezed,
  }) {
    return _then(_self.copyWith(
      abouts: freezed == abouts
          ? _self.abouts
          : abouts // ignore: cast_nullable_to_non_nullable
              as List<AboutAppModel>?,
      xpEarn: freezed == xpEarn
          ? _self.xpEarn
          : xpEarn // ignore: cast_nullable_to_non_nullable
              as List<XpEarnModel>?,
      xpInso: freezed == xpInso
          ? _self.xpInso
          : xpInso // ignore: cast_nullable_to_non_nullable
              as List<XpInSoModel>?,
      userLevel: freezed == userLevel
          ? _self.userLevel
          : userLevel // ignore: cast_nullable_to_non_nullable
              as List<UserLevelModel>?,
    ));
  }
}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _AppSettingModel implements AppSettingModel {
  _AppSettingModel(
      {final List<AboutAppModel>? abouts,
      final List<XpEarnModel>? xpEarn,
      final List<XpInSoModel>? xpInso,
      final List<UserLevelModel>? userLevel})
      : _abouts = abouts,
        _xpEarn = xpEarn,
        _xpInso = xpInso,
        _userLevel = userLevel;
  factory _AppSettingModel.fromJson(Map<String, dynamic> json) =>
      _$AppSettingModelFromJson(json);

  final List<AboutAppModel>? _abouts;
  @override
  List<AboutAppModel>? get abouts {
    final value = _abouts;
    if (value == null) return null;
    if (_abouts is EqualUnmodifiableListView) return _abouts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<XpEarnModel>? _xpEarn;
  @override
  List<XpEarnModel>? get xpEarn {
    final value = _xpEarn;
    if (value == null) return null;
    if (_xpEarn is EqualUnmodifiableListView) return _xpEarn;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<XpInSoModel>? _xpInso;
  @override
  List<XpInSoModel>? get xpInso {
    final value = _xpInso;
    if (value == null) return null;
    if (_xpInso is EqualUnmodifiableListView) return _xpInso;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<UserLevelModel>? _userLevel;
  @override
  List<UserLevelModel>? get userLevel {
    final value = _userLevel;
    if (value == null) return null;
    if (_userLevel is EqualUnmodifiableListView) return _userLevel;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  /// Create a copy of AppSettingModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$AppSettingModelCopyWith<_AppSettingModel> get copyWith =>
      __$AppSettingModelCopyWithImpl<_AppSettingModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$AppSettingModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _AppSettingModel &&
            const DeepCollectionEquality().equals(other._abouts, _abouts) &&
            const DeepCollectionEquality().equals(other._xpEarn, _xpEarn) &&
            const DeepCollectionEquality().equals(other._xpInso, _xpInso) &&
            const DeepCollectionEquality()
                .equals(other._userLevel, _userLevel));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_abouts),
      const DeepCollectionEquality().hash(_xpEarn),
      const DeepCollectionEquality().hash(_xpInso),
      const DeepCollectionEquality().hash(_userLevel));

  @override
  String toString() {
    return 'AppSettingModel(abouts: $abouts, xpEarn: $xpEarn, xpInso: $xpInso, userLevel: $userLevel)';
  }
}

/// @nodoc
abstract mixin class _$AppSettingModelCopyWith<$Res>
    implements $AppSettingModelCopyWith<$Res> {
  factory _$AppSettingModelCopyWith(
          _AppSettingModel value, $Res Function(_AppSettingModel) _then) =
      __$AppSettingModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {List<AboutAppModel>? abouts,
      List<XpEarnModel>? xpEarn,
      List<XpInSoModel>? xpInso,
      List<UserLevelModel>? userLevel});
}

/// @nodoc
class __$AppSettingModelCopyWithImpl<$Res>
    implements _$AppSettingModelCopyWith<$Res> {
  __$AppSettingModelCopyWithImpl(this._self, this._then);

  final _AppSettingModel _self;
  final $Res Function(_AppSettingModel) _then;

  /// Create a copy of AppSettingModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? abouts = freezed,
    Object? xpEarn = freezed,
    Object? xpInso = freezed,
    Object? userLevel = freezed,
  }) {
    return _then(_AppSettingModel(
      abouts: freezed == abouts
          ? _self._abouts
          : abouts // ignore: cast_nullable_to_non_nullable
              as List<AboutAppModel>?,
      xpEarn: freezed == xpEarn
          ? _self._xpEarn
          : xpEarn // ignore: cast_nullable_to_non_nullable
              as List<XpEarnModel>?,
      xpInso: freezed == xpInso
          ? _self._xpInso
          : xpInso // ignore: cast_nullable_to_non_nullable
              as List<XpInSoModel>?,
      userLevel: freezed == userLevel
          ? _self._userLevel
          : userLevel // ignore: cast_nullable_to_non_nullable
              as List<UserLevelModel>?,
    ));
  }
}

/// @nodoc
mixin _$AboutAppModel {
  String? get title;
  String? get description;

  /// Create a copy of AboutAppModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AboutAppModelCopyWith<AboutAppModel> get copyWith =>
      _$AboutAppModelCopyWithImpl<AboutAppModel>(
          this as AboutAppModel, _$identity);

  /// Serializes this AboutAppModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AboutAppModel &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, title, description);

  @override
  String toString() {
    return 'AboutAppModel(title: $title, description: $description)';
  }
}

/// @nodoc
abstract mixin class $AboutAppModelCopyWith<$Res> {
  factory $AboutAppModelCopyWith(
          AboutAppModel value, $Res Function(AboutAppModel) _then) =
      _$AboutAppModelCopyWithImpl;
  @useResult
  $Res call({String? title, String? description});
}

/// @nodoc
class _$AboutAppModelCopyWithImpl<$Res>
    implements $AboutAppModelCopyWith<$Res> {
  _$AboutAppModelCopyWithImpl(this._self, this._then);

  final AboutAppModel _self;
  final $Res Function(AboutAppModel) _then;

  /// Create a copy of AboutAppModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = freezed,
    Object? description = freezed,
  }) {
    return _then(_self.copyWith(
      title: freezed == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _AboutAppModel implements AboutAppModel {
  _AboutAppModel({this.title, this.description});
  factory _AboutAppModel.fromJson(Map<String, dynamic> json) =>
      _$AboutAppModelFromJson(json);

  @override
  final String? title;
  @override
  final String? description;

  /// Create a copy of AboutAppModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$AboutAppModelCopyWith<_AboutAppModel> get copyWith =>
      __$AboutAppModelCopyWithImpl<_AboutAppModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$AboutAppModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _AboutAppModel &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, title, description);

  @override
  String toString() {
    return 'AboutAppModel(title: $title, description: $description)';
  }
}

/// @nodoc
abstract mixin class _$AboutAppModelCopyWith<$Res>
    implements $AboutAppModelCopyWith<$Res> {
  factory _$AboutAppModelCopyWith(
          _AboutAppModel value, $Res Function(_AboutAppModel) _then) =
      __$AboutAppModelCopyWithImpl;
  @override
  @useResult
  $Res call({String? title, String? description});
}

/// @nodoc
class __$AboutAppModelCopyWithImpl<$Res>
    implements _$AboutAppModelCopyWith<$Res> {
  __$AboutAppModelCopyWithImpl(this._self, this._then);

  final _AboutAppModel _self;
  final $Res Function(_AboutAppModel) _then;

  /// Create a copy of AboutAppModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? title = freezed,
    Object? description = freezed,
  }) {
    return _then(_AboutAppModel(
      title: freezed == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
mixin _$XpEarnModel {
  String? get key;
  String? get name;
  String? get bonusDecription;
  int? get reward;
  double? get bonus;

  /// Create a copy of XpEarnModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $XpEarnModelCopyWith<XpEarnModel> get copyWith =>
      _$XpEarnModelCopyWithImpl<XpEarnModel>(this as XpEarnModel, _$identity);

  /// Serializes this XpEarnModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is XpEarnModel &&
            (identical(other.key, key) || other.key == key) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.bonusDecription, bonusDecription) ||
                other.bonusDecription == bonusDecription) &&
            (identical(other.reward, reward) || other.reward == reward) &&
            (identical(other.bonus, bonus) || other.bonus == bonus));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, key, name, bonusDecription, reward, bonus);

  @override
  String toString() {
    return 'XpEarnModel(key: $key, name: $name, bonusDecription: $bonusDecription, reward: $reward, bonus: $bonus)';
  }
}

/// @nodoc
abstract mixin class $XpEarnModelCopyWith<$Res> {
  factory $XpEarnModelCopyWith(
          XpEarnModel value, $Res Function(XpEarnModel) _then) =
      _$XpEarnModelCopyWithImpl;
  @useResult
  $Res call(
      {String? key,
      String? name,
      String? bonusDecription,
      int? reward,
      double? bonus});
}

/// @nodoc
class _$XpEarnModelCopyWithImpl<$Res> implements $XpEarnModelCopyWith<$Res> {
  _$XpEarnModelCopyWithImpl(this._self, this._then);

  final XpEarnModel _self;
  final $Res Function(XpEarnModel) _then;

  /// Create a copy of XpEarnModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? key = freezed,
    Object? name = freezed,
    Object? bonusDecription = freezed,
    Object? reward = freezed,
    Object? bonus = freezed,
  }) {
    return _then(_self.copyWith(
      key: freezed == key
          ? _self.key
          : key // ignore: cast_nullable_to_non_nullable
              as String?,
      name: freezed == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      bonusDecription: freezed == bonusDecription
          ? _self.bonusDecription
          : bonusDecription // ignore: cast_nullable_to_non_nullable
              as String?,
      reward: freezed == reward
          ? _self.reward
          : reward // ignore: cast_nullable_to_non_nullable
              as int?,
      bonus: freezed == bonus
          ? _self.bonus
          : bonus // ignore: cast_nullable_to_non_nullable
              as double?,
    ));
  }
}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _XpEarnModel implements XpEarnModel {
  _XpEarnModel(
      {this.key, this.name, this.bonusDecription, this.reward, this.bonus});
  factory _XpEarnModel.fromJson(Map<String, dynamic> json) =>
      _$XpEarnModelFromJson(json);

  @override
  final String? key;
  @override
  final String? name;
  @override
  final String? bonusDecription;
  @override
  final int? reward;
  @override
  final double? bonus;

  /// Create a copy of XpEarnModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$XpEarnModelCopyWith<_XpEarnModel> get copyWith =>
      __$XpEarnModelCopyWithImpl<_XpEarnModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$XpEarnModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _XpEarnModel &&
            (identical(other.key, key) || other.key == key) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.bonusDecription, bonusDecription) ||
                other.bonusDecription == bonusDecription) &&
            (identical(other.reward, reward) || other.reward == reward) &&
            (identical(other.bonus, bonus) || other.bonus == bonus));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, key, name, bonusDecription, reward, bonus);

  @override
  String toString() {
    return 'XpEarnModel(key: $key, name: $name, bonusDecription: $bonusDecription, reward: $reward, bonus: $bonus)';
  }
}

/// @nodoc
abstract mixin class _$XpEarnModelCopyWith<$Res>
    implements $XpEarnModelCopyWith<$Res> {
  factory _$XpEarnModelCopyWith(
          _XpEarnModel value, $Res Function(_XpEarnModel) _then) =
      __$XpEarnModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String? key,
      String? name,
      String? bonusDecription,
      int? reward,
      double? bonus});
}

/// @nodoc
class __$XpEarnModelCopyWithImpl<$Res> implements _$XpEarnModelCopyWith<$Res> {
  __$XpEarnModelCopyWithImpl(this._self, this._then);

  final _XpEarnModel _self;
  final $Res Function(_XpEarnModel) _then;

  /// Create a copy of XpEarnModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? key = freezed,
    Object? name = freezed,
    Object? bonusDecription = freezed,
    Object? reward = freezed,
    Object? bonus = freezed,
  }) {
    return _then(_XpEarnModel(
      key: freezed == key
          ? _self.key
          : key // ignore: cast_nullable_to_non_nullable
              as String?,
      name: freezed == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      bonusDecription: freezed == bonusDecription
          ? _self.bonusDecription
          : bonusDecription // ignore: cast_nullable_to_non_nullable
              as String?,
      reward: freezed == reward
          ? _self.reward
          : reward // ignore: cast_nullable_to_non_nullable
              as int?,
      bonus: freezed == bonus
          ? _self.bonus
          : bonus // ignore: cast_nullable_to_non_nullable
              as double?,
    ));
  }
}

/// @nodoc
mixin _$XpInSoModel {
  int? get min;
  int? get max;
  int? get rate;

  /// Create a copy of XpInSoModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $XpInSoModelCopyWith<XpInSoModel> get copyWith =>
      _$XpInSoModelCopyWithImpl<XpInSoModel>(this as XpInSoModel, _$identity);

  /// Serializes this XpInSoModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is XpInSoModel &&
            (identical(other.min, min) || other.min == min) &&
            (identical(other.max, max) || other.max == max) &&
            (identical(other.rate, rate) || other.rate == rate));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, min, max, rate);

  @override
  String toString() {
    return 'XpInSoModel(min: $min, max: $max, rate: $rate)';
  }
}

/// @nodoc
abstract mixin class $XpInSoModelCopyWith<$Res> {
  factory $XpInSoModelCopyWith(
          XpInSoModel value, $Res Function(XpInSoModel) _then) =
      _$XpInSoModelCopyWithImpl;
  @useResult
  $Res call({int? min, int? max, int? rate});
}

/// @nodoc
class _$XpInSoModelCopyWithImpl<$Res> implements $XpInSoModelCopyWith<$Res> {
  _$XpInSoModelCopyWithImpl(this._self, this._then);

  final XpInSoModel _self;
  final $Res Function(XpInSoModel) _then;

  /// Create a copy of XpInSoModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? min = freezed,
    Object? max = freezed,
    Object? rate = freezed,
  }) {
    return _then(_self.copyWith(
      min: freezed == min
          ? _self.min
          : min // ignore: cast_nullable_to_non_nullable
              as int?,
      max: freezed == max
          ? _self.max
          : max // ignore: cast_nullable_to_non_nullable
              as int?,
      rate: freezed == rate
          ? _self.rate
          : rate // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _XpInSoModel implements XpInSoModel {
  _XpInSoModel({this.min, this.max, this.rate});
  factory _XpInSoModel.fromJson(Map<String, dynamic> json) =>
      _$XpInSoModelFromJson(json);

  @override
  final int? min;
  @override
  final int? max;
  @override
  final int? rate;

  /// Create a copy of XpInSoModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$XpInSoModelCopyWith<_XpInSoModel> get copyWith =>
      __$XpInSoModelCopyWithImpl<_XpInSoModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$XpInSoModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _XpInSoModel &&
            (identical(other.min, min) || other.min == min) &&
            (identical(other.max, max) || other.max == max) &&
            (identical(other.rate, rate) || other.rate == rate));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, min, max, rate);

  @override
  String toString() {
    return 'XpInSoModel(min: $min, max: $max, rate: $rate)';
  }
}

/// @nodoc
abstract mixin class _$XpInSoModelCopyWith<$Res>
    implements $XpInSoModelCopyWith<$Res> {
  factory _$XpInSoModelCopyWith(
          _XpInSoModel value, $Res Function(_XpInSoModel) _then) =
      __$XpInSoModelCopyWithImpl;
  @override
  @useResult
  $Res call({int? min, int? max, int? rate});
}

/// @nodoc
class __$XpInSoModelCopyWithImpl<$Res> implements _$XpInSoModelCopyWith<$Res> {
  __$XpInSoModelCopyWithImpl(this._self, this._then);

  final _XpInSoModel _self;
  final $Res Function(_XpInSoModel) _then;

  /// Create a copy of XpInSoModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? min = freezed,
    Object? max = freezed,
    Object? rate = freezed,
  }) {
    return _then(_XpInSoModel(
      min: freezed == min
          ? _self.min
          : min // ignore: cast_nullable_to_non_nullable
              as int?,
      max: freezed == max
          ? _self.max
          : max // ignore: cast_nullable_to_non_nullable
              as int?,
      rate: freezed == rate
          ? _self.rate
          : rate // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
mixin _$UserLevelModel {
  int? get level;
  String? get title;
  int? get mix;
  int? get max;
  List<String>? get feature;

  /// Create a copy of UserLevelModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $UserLevelModelCopyWith<UserLevelModel> get copyWith =>
      _$UserLevelModelCopyWithImpl<UserLevelModel>(
          this as UserLevelModel, _$identity);

  /// Serializes this UserLevelModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is UserLevelModel &&
            (identical(other.level, level) || other.level == level) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.mix, mix) || other.mix == mix) &&
            (identical(other.max, max) || other.max == max) &&
            const DeepCollectionEquality().equals(other.feature, feature));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, level, title, mix, max,
      const DeepCollectionEquality().hash(feature));

  @override
  String toString() {
    return 'UserLevelModel(level: $level, title: $title, mix: $mix, max: $max, feature: $feature)';
  }
}

/// @nodoc
abstract mixin class $UserLevelModelCopyWith<$Res> {
  factory $UserLevelModelCopyWith(
          UserLevelModel value, $Res Function(UserLevelModel) _then) =
      _$UserLevelModelCopyWithImpl;
  @useResult
  $Res call(
      {int? level, String? title, int? mix, int? max, List<String>? feature});
}

/// @nodoc
class _$UserLevelModelCopyWithImpl<$Res>
    implements $UserLevelModelCopyWith<$Res> {
  _$UserLevelModelCopyWithImpl(this._self, this._then);

  final UserLevelModel _self;
  final $Res Function(UserLevelModel) _then;

  /// Create a copy of UserLevelModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? level = freezed,
    Object? title = freezed,
    Object? mix = freezed,
    Object? max = freezed,
    Object? feature = freezed,
  }) {
    return _then(_self.copyWith(
      level: freezed == level
          ? _self.level
          : level // ignore: cast_nullable_to_non_nullable
              as int?,
      title: freezed == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      mix: freezed == mix
          ? _self.mix
          : mix // ignore: cast_nullable_to_non_nullable
              as int?,
      max: freezed == max
          ? _self.max
          : max // ignore: cast_nullable_to_non_nullable
              as int?,
      feature: freezed == feature
          ? _self.feature
          : feature // ignore: cast_nullable_to_non_nullable
              as List<String>?,
    ));
  }
}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _UserLevelModel implements UserLevelModel {
  _UserLevelModel(
      {this.level, this.title, this.mix, this.max, final List<String>? feature})
      : _feature = feature;
  factory _UserLevelModel.fromJson(Map<String, dynamic> json) =>
      _$UserLevelModelFromJson(json);

  @override
  final int? level;
  @override
  final String? title;
  @override
  final int? mix;
  @override
  final int? max;
  final List<String>? _feature;
  @override
  List<String>? get feature {
    final value = _feature;
    if (value == null) return null;
    if (_feature is EqualUnmodifiableListView) return _feature;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  /// Create a copy of UserLevelModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$UserLevelModelCopyWith<_UserLevelModel> get copyWith =>
      __$UserLevelModelCopyWithImpl<_UserLevelModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$UserLevelModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _UserLevelModel &&
            (identical(other.level, level) || other.level == level) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.mix, mix) || other.mix == mix) &&
            (identical(other.max, max) || other.max == max) &&
            const DeepCollectionEquality().equals(other._feature, _feature));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, level, title, mix, max,
      const DeepCollectionEquality().hash(_feature));

  @override
  String toString() {
    return 'UserLevelModel(level: $level, title: $title, mix: $mix, max: $max, feature: $feature)';
  }
}

/// @nodoc
abstract mixin class _$UserLevelModelCopyWith<$Res>
    implements $UserLevelModelCopyWith<$Res> {
  factory _$UserLevelModelCopyWith(
          _UserLevelModel value, $Res Function(_UserLevelModel) _then) =
      __$UserLevelModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {int? level, String? title, int? mix, int? max, List<String>? feature});
}

/// @nodoc
class __$UserLevelModelCopyWithImpl<$Res>
    implements _$UserLevelModelCopyWith<$Res> {
  __$UserLevelModelCopyWithImpl(this._self, this._then);

  final _UserLevelModel _self;
  final $Res Function(_UserLevelModel) _then;

  /// Create a copy of UserLevelModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? level = freezed,
    Object? title = freezed,
    Object? mix = freezed,
    Object? max = freezed,
    Object? feature = freezed,
  }) {
    return _then(_UserLevelModel(
      level: freezed == level
          ? _self.level
          : level // ignore: cast_nullable_to_non_nullable
              as int?,
      title: freezed == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      mix: freezed == mix
          ? _self.mix
          : mix // ignore: cast_nullable_to_non_nullable
              as int?,
      max: freezed == max
          ? _self.max
          : max // ignore: cast_nullable_to_non_nullable
              as int?,
      feature: freezed == feature
          ? _self._feature
          : feature // ignore: cast_nullable_to_non_nullable
              as List<String>?,
    ));
  }
}

// dart format on
