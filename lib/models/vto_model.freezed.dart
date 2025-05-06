// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'vto_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$VTOCellModel {
  String? get title;
  String? get image;
  String? get desc;

  /// Create a copy of VTOCellModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $VTOCellModelCopyWith<VTOCellModel> get copyWith =>
      _$VTOCellModelCopyWithImpl<VTOCellModel>(
          this as VTOCellModel, _$identity);

  /// Serializes this VTOCellModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is VTOCellModel &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.image, image) || other.image == image) &&
            (identical(other.desc, desc) || other.desc == desc));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, title, image, desc);

  @override
  String toString() {
    return 'VTOCellModel(title: $title, image: $image, desc: $desc)';
  }
}

/// @nodoc
abstract mixin class $VTOCellModelCopyWith<$Res> {
  factory $VTOCellModelCopyWith(
          VTOCellModel value, $Res Function(VTOCellModel) _then) =
      _$VTOCellModelCopyWithImpl;
  @useResult
  $Res call({String? title, String? image, String? desc});
}

/// @nodoc
class _$VTOCellModelCopyWithImpl<$Res> implements $VTOCellModelCopyWith<$Res> {
  _$VTOCellModelCopyWithImpl(this._self, this._then);

  final VTOCellModel _self;
  final $Res Function(VTOCellModel) _then;

  /// Create a copy of VTOCellModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = freezed,
    Object? image = freezed,
    Object? desc = freezed,
  }) {
    return _then(_self.copyWith(
      title: freezed == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      image: freezed == image
          ? _self.image
          : image // ignore: cast_nullable_to_non_nullable
              as String?,
      desc: freezed == desc
          ? _self.desc
          : desc // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _VTOCellModel implements VTOCellModel {
  _VTOCellModel({this.title, this.image, this.desc});
  factory _VTOCellModel.fromJson(Map<String, dynamic> json) =>
      _$VTOCellModelFromJson(json);

  @override
  final String? title;
  @override
  final String? image;
  @override
  final String? desc;

  /// Create a copy of VTOCellModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$VTOCellModelCopyWith<_VTOCellModel> get copyWith =>
      __$VTOCellModelCopyWithImpl<_VTOCellModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$VTOCellModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _VTOCellModel &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.image, image) || other.image == image) &&
            (identical(other.desc, desc) || other.desc == desc));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, title, image, desc);

  @override
  String toString() {
    return 'VTOCellModel(title: $title, image: $image, desc: $desc)';
  }
}

/// @nodoc
abstract mixin class _$VTOCellModelCopyWith<$Res>
    implements $VTOCellModelCopyWith<$Res> {
  factory _$VTOCellModelCopyWith(
          _VTOCellModel value, $Res Function(_VTOCellModel) _then) =
      __$VTOCellModelCopyWithImpl;
  @override
  @useResult
  $Res call({String? title, String? image, String? desc});
}

/// @nodoc
class __$VTOCellModelCopyWithImpl<$Res>
    implements _$VTOCellModelCopyWith<$Res> {
  __$VTOCellModelCopyWithImpl(this._self, this._then);

  final _VTOCellModel _self;
  final $Res Function(_VTOCellModel) _then;

  /// Create a copy of VTOCellModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? title = freezed,
    Object? image = freezed,
    Object? desc = freezed,
  }) {
    return _then(_VTOCellModel(
      title: freezed == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      image: freezed == image
          ? _self.image
          : image // ignore: cast_nullable_to_non_nullable
              as String?,
      desc: freezed == desc
          ? _self.desc
          : desc // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
mixin _$VTOGroupModel {
  String? get name;
  List<VTOCellModel>? get list;

  /// Create a copy of VTOGroupModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $VTOGroupModelCopyWith<VTOGroupModel> get copyWith =>
      _$VTOGroupModelCopyWithImpl<VTOGroupModel>(
          this as VTOGroupModel, _$identity);

  /// Serializes this VTOGroupModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is VTOGroupModel &&
            (identical(other.name, name) || other.name == name) &&
            const DeepCollectionEquality().equals(other.list, list));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, name, const DeepCollectionEquality().hash(list));

  @override
  String toString() {
    return 'VTOGroupModel(name: $name, list: $list)';
  }
}

/// @nodoc
abstract mixin class $VTOGroupModelCopyWith<$Res> {
  factory $VTOGroupModelCopyWith(
          VTOGroupModel value, $Res Function(VTOGroupModel) _then) =
      _$VTOGroupModelCopyWithImpl;
  @useResult
  $Res call({String? name, List<VTOCellModel>? list});
}

/// @nodoc
class _$VTOGroupModelCopyWithImpl<$Res>
    implements $VTOGroupModelCopyWith<$Res> {
  _$VTOGroupModelCopyWithImpl(this._self, this._then);

  final VTOGroupModel _self;
  final $Res Function(VTOGroupModel) _then;

  /// Create a copy of VTOGroupModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = freezed,
    Object? list = freezed,
  }) {
    return _then(_self.copyWith(
      name: freezed == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      list: freezed == list
          ? _self.list
          : list // ignore: cast_nullable_to_non_nullable
              as List<VTOCellModel>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _VTOGroupModel implements VTOGroupModel {
  _VTOGroupModel({this.name, final List<VTOCellModel>? list}) : _list = list;
  factory _VTOGroupModel.fromJson(Map<String, dynamic> json) =>
      _$VTOGroupModelFromJson(json);

  @override
  final String? name;
  final List<VTOCellModel>? _list;
  @override
  List<VTOCellModel>? get list {
    final value = _list;
    if (value == null) return null;
    if (_list is EqualUnmodifiableListView) return _list;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  /// Create a copy of VTOGroupModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$VTOGroupModelCopyWith<_VTOGroupModel> get copyWith =>
      __$VTOGroupModelCopyWithImpl<_VTOGroupModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$VTOGroupModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _VTOGroupModel &&
            (identical(other.name, name) || other.name == name) &&
            const DeepCollectionEquality().equals(other._list, _list));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, name, const DeepCollectionEquality().hash(_list));

  @override
  String toString() {
    return 'VTOGroupModel(name: $name, list: $list)';
  }
}

/// @nodoc
abstract mixin class _$VTOGroupModelCopyWith<$Res>
    implements $VTOGroupModelCopyWith<$Res> {
  factory _$VTOGroupModelCopyWith(
          _VTOGroupModel value, $Res Function(_VTOGroupModel) _then) =
      __$VTOGroupModelCopyWithImpl;
  @override
  @useResult
  $Res call({String? name, List<VTOCellModel>? list});
}

/// @nodoc
class __$VTOGroupModelCopyWithImpl<$Res>
    implements _$VTOGroupModelCopyWith<$Res> {
  __$VTOGroupModelCopyWithImpl(this._self, this._then);

  final _VTOGroupModel _self;
  final $Res Function(_VTOGroupModel) _then;

  /// Create a copy of VTOGroupModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? name = freezed,
    Object? list = freezed,
  }) {
    return _then(_VTOGroupModel(
      name: freezed == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      list: freezed == list
          ? _self._list
          : list // ignore: cast_nullable_to_non_nullable
              as List<VTOCellModel>?,
    ));
  }
}

// dart format on
