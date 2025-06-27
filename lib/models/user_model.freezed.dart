// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserModel {
  String? get id;
  String? get uid;
  String? get walletAddress;
  String? get avatar;
  String? get firstName;
  String? get lastName;
  String? get email;
  String? get password;
  String? get city;
  String? get country;
  String? get website;
  String? get desc;
  String? get discovery;
  String? get nickId;
  double? get lat;
  double? get lon;
  String? get ipAddress;
  DateTime? get updateDate;
  DateTime? get timestamp;
  String? get status;
  bool? get hasVotePost;
  bool? get freeStyle;
  bool? get isPremium;
  int? get rewardDate;
  int? get transferedXP;
  int? get transferedInSo;
  List<String>? get likes;
  List<String>? get follows;
  List<String>? get userActions;
  List<UserActionModel>? get actions;

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $UserModelCopyWith<UserModel> get copyWith =>
      _$UserModelCopyWithImpl<UserModel>(this as UserModel, _$identity);

  /// Serializes this UserModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is UserModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.uid, uid) || other.uid == uid) &&
            (identical(other.walletAddress, walletAddress) ||
                other.walletAddress == walletAddress) &&
            (identical(other.avatar, avatar) || other.avatar == avatar) &&
            (identical(other.firstName, firstName) ||
                other.firstName == firstName) &&
            (identical(other.lastName, lastName) ||
                other.lastName == lastName) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.password, password) ||
                other.password == password) &&
            (identical(other.city, city) || other.city == city) &&
            (identical(other.country, country) || other.country == country) &&
            (identical(other.website, website) || other.website == website) &&
            (identical(other.desc, desc) || other.desc == desc) &&
            (identical(other.discovery, discovery) ||
                other.discovery == discovery) &&
            (identical(other.nickId, nickId) || other.nickId == nickId) &&
            (identical(other.lat, lat) || other.lat == lat) &&
            (identical(other.lon, lon) || other.lon == lon) &&
            (identical(other.ipAddress, ipAddress) ||
                other.ipAddress == ipAddress) &&
            (identical(other.updateDate, updateDate) ||
                other.updateDate == updateDate) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.hasVotePost, hasVotePost) ||
                other.hasVotePost == hasVotePost) &&
            (identical(other.freeStyle, freeStyle) ||
                other.freeStyle == freeStyle) &&
            (identical(other.isPremium, isPremium) ||
                other.isPremium == isPremium) &&
            (identical(other.rewardDate, rewardDate) ||
                other.rewardDate == rewardDate) &&
            (identical(other.transferedXP, transferedXP) ||
                other.transferedXP == transferedXP) &&
            (identical(other.transferedInSo, transferedInSo) ||
                other.transferedInSo == transferedInSo) &&
            const DeepCollectionEquality().equals(other.likes, likes) &&
            const DeepCollectionEquality().equals(other.follows, follows) &&
            const DeepCollectionEquality()
                .equals(other.userActions, userActions) &&
            const DeepCollectionEquality().equals(other.actions, actions));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        uid,
        walletAddress,
        avatar,
        firstName,
        lastName,
        email,
        password,
        city,
        country,
        website,
        desc,
        discovery,
        nickId,
        lat,
        lon,
        ipAddress,
        updateDate,
        timestamp,
        status,
        hasVotePost,
        freeStyle,
        isPremium,
        rewardDate,
        transferedXP,
        transferedInSo,
        const DeepCollectionEquality().hash(likes),
        const DeepCollectionEquality().hash(follows),
        const DeepCollectionEquality().hash(userActions),
        const DeepCollectionEquality().hash(actions)
      ]);

  @override
  String toString() {
    return 'UserModel(id: $id, uid: $uid, walletAddress: $walletAddress, avatar: $avatar, firstName: $firstName, lastName: $lastName, email: $email, password: $password, city: $city, country: $country, website: $website, desc: $desc, discovery: $discovery, nickId: $nickId, lat: $lat, lon: $lon, ipAddress: $ipAddress, updateDate: $updateDate, timestamp: $timestamp, status: $status, hasVotePost: $hasVotePost, freeStyle: $freeStyle, isPremium: $isPremium, rewardDate: $rewardDate, transferedXP: $transferedXP, transferedInSo: $transferedInSo, likes: $likes, follows: $follows, userActions: $userActions, actions: $actions)';
  }
}

/// @nodoc
abstract mixin class $UserModelCopyWith<$Res> {
  factory $UserModelCopyWith(UserModel value, $Res Function(UserModel) _then) =
      _$UserModelCopyWithImpl;
  @useResult
  $Res call(
      {String? id,
      String? uid,
      String? walletAddress,
      String? avatar,
      String? firstName,
      String? lastName,
      String? email,
      String? password,
      String? city,
      String? country,
      String? website,
      String? desc,
      String? discovery,
      String? nickId,
      double? lat,
      double? lon,
      String? ipAddress,
      DateTime? updateDate,
      DateTime? timestamp,
      String? status,
      bool? hasVotePost,
      bool? freeStyle,
      bool? isPremium,
      int? rewardDate,
      int? transferedXP,
      int? transferedInSo,
      List<String>? likes,
      List<String>? follows,
      List<String>? userActions,
      List<UserActionModel>? actions});
}

/// @nodoc
class _$UserModelCopyWithImpl<$Res> implements $UserModelCopyWith<$Res> {
  _$UserModelCopyWithImpl(this._self, this._then);

  final UserModel _self;
  final $Res Function(UserModel) _then;

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? uid = freezed,
    Object? walletAddress = freezed,
    Object? avatar = freezed,
    Object? firstName = freezed,
    Object? lastName = freezed,
    Object? email = freezed,
    Object? password = freezed,
    Object? city = freezed,
    Object? country = freezed,
    Object? website = freezed,
    Object? desc = freezed,
    Object? discovery = freezed,
    Object? nickId = freezed,
    Object? lat = freezed,
    Object? lon = freezed,
    Object? ipAddress = freezed,
    Object? updateDate = freezed,
    Object? timestamp = freezed,
    Object? status = freezed,
    Object? hasVotePost = freezed,
    Object? freeStyle = freezed,
    Object? isPremium = freezed,
    Object? rewardDate = freezed,
    Object? transferedXP = freezed,
    Object? transferedInSo = freezed,
    Object? likes = freezed,
    Object? follows = freezed,
    Object? userActions = freezed,
    Object? actions = freezed,
  }) {
    return _then(_self.copyWith(
      id: freezed == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      uid: freezed == uid
          ? _self.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String?,
      walletAddress: freezed == walletAddress
          ? _self.walletAddress
          : walletAddress // ignore: cast_nullable_to_non_nullable
              as String?,
      avatar: freezed == avatar
          ? _self.avatar
          : avatar // ignore: cast_nullable_to_non_nullable
              as String?,
      firstName: freezed == firstName
          ? _self.firstName
          : firstName // ignore: cast_nullable_to_non_nullable
              as String?,
      lastName: freezed == lastName
          ? _self.lastName
          : lastName // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _self.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      password: freezed == password
          ? _self.password
          : password // ignore: cast_nullable_to_non_nullable
              as String?,
      city: freezed == city
          ? _self.city
          : city // ignore: cast_nullable_to_non_nullable
              as String?,
      country: freezed == country
          ? _self.country
          : country // ignore: cast_nullable_to_non_nullable
              as String?,
      website: freezed == website
          ? _self.website
          : website // ignore: cast_nullable_to_non_nullable
              as String?,
      desc: freezed == desc
          ? _self.desc
          : desc // ignore: cast_nullable_to_non_nullable
              as String?,
      discovery: freezed == discovery
          ? _self.discovery
          : discovery // ignore: cast_nullable_to_non_nullable
              as String?,
      nickId: freezed == nickId
          ? _self.nickId
          : nickId // ignore: cast_nullable_to_non_nullable
              as String?,
      lat: freezed == lat
          ? _self.lat
          : lat // ignore: cast_nullable_to_non_nullable
              as double?,
      lon: freezed == lon
          ? _self.lon
          : lon // ignore: cast_nullable_to_non_nullable
              as double?,
      ipAddress: freezed == ipAddress
          ? _self.ipAddress
          : ipAddress // ignore: cast_nullable_to_non_nullable
              as String?,
      updateDate: freezed == updateDate
          ? _self.updateDate
          : updateDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      timestamp: freezed == timestamp
          ? _self.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      status: freezed == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as String?,
      hasVotePost: freezed == hasVotePost
          ? _self.hasVotePost
          : hasVotePost // ignore: cast_nullable_to_non_nullable
              as bool?,
      freeStyle: freezed == freeStyle
          ? _self.freeStyle
          : freeStyle // ignore: cast_nullable_to_non_nullable
              as bool?,
      isPremium: freezed == isPremium
          ? _self.isPremium
          : isPremium // ignore: cast_nullable_to_non_nullable
              as bool?,
      rewardDate: freezed == rewardDate
          ? _self.rewardDate
          : rewardDate // ignore: cast_nullable_to_non_nullable
              as int?,
      transferedXP: freezed == transferedXP
          ? _self.transferedXP
          : transferedXP // ignore: cast_nullable_to_non_nullable
              as int?,
      transferedInSo: freezed == transferedInSo
          ? _self.transferedInSo
          : transferedInSo // ignore: cast_nullable_to_non_nullable
              as int?,            
      likes: freezed == likes
          ? _self.likes
          : likes // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      follows: freezed == follows
          ? _self.follows
          : follows // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      userActions: freezed == userActions
          ? _self.userActions
          : userActions // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      actions: freezed == actions
          ? _self.actions
          : actions // ignore: cast_nullable_to_non_nullable
              as List<UserActionModel>?,
    ));
  }
}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _UserModel implements UserModel {
  _UserModel(
      {this.id,
      this.uid,
      this.walletAddress,
      this.avatar,
      this.firstName,
      this.lastName,
      this.email,
      this.password,
      this.city,
      this.country,
      this.website,
      this.desc,
      this.discovery,
      this.nickId,
      this.lat,
      this.lon,
      this.ipAddress,
      this.updateDate,
      this.timestamp,
      this.status,
      this.hasVotePost,
      this.freeStyle,
      this.isPremium,
      this.rewardDate,
      this.transferedXP,
      this.transferedInSo,
      final List<String>? likes,
      final List<String>? follows,
      final List<String>? userActions,
      final List<UserActionModel>? actions})
      : _likes = likes,
        _follows = follows,
        _userActions = userActions,
        _actions = actions;
  factory _UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  @override
  final String? id;
  @override
  final String? uid;
  @override
  final String? walletAddress;
  @override
  final String? avatar;
  @override
  final String? firstName;
  @override
  final String? lastName;
  @override
  final String? email;
  @override
  final String? password;
  @override
  final String? city;
  @override
  final String? country;
  @override
  final String? website;
  @override
  final String? desc;
  @override
  final String? discovery;
  @override
  final String? nickId;
  @override
  final double? lat;
  @override
  final double? lon;
  @override
  final String? ipAddress;
  @override
  final DateTime? updateDate;
  @override
  final DateTime? timestamp;
  @override
  final String? status;
  @override
  final bool? hasVotePost;
  @override
  final bool? freeStyle;
  @override
  final bool? isPremium;
  @override
  final int? rewardDate;
  @override
  final int? transferedXP;
  @override
  final int? transferedInSo;
  final List<String>? _likes;
  @override
  List<String>? get likes {
    final value = _likes;
    if (value == null) return null;
    if (_likes is EqualUnmodifiableListView) return _likes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<String>? _follows;
  @override
  List<String>? get follows {
    final value = _follows;
    if (value == null) return null;
    if (_follows is EqualUnmodifiableListView) return _follows;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<String>? _userActions;
  @override
  List<String>? get userActions {
    final value = _userActions;
    if (value == null) return null;
    if (_userActions is EqualUnmodifiableListView) return _userActions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<UserActionModel>? _actions;
  @override
  List<UserActionModel>? get actions {
    final value = _actions;
    if (value == null) return null;
    if (_actions is EqualUnmodifiableListView) return _actions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$UserModelCopyWith<_UserModel> get copyWith =>
      __$UserModelCopyWithImpl<_UserModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$UserModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _UserModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.uid, uid) || other.uid == uid) &&
            (identical(other.walletAddress, walletAddress) ||
                other.walletAddress == walletAddress) &&
            (identical(other.avatar, avatar) || other.avatar == avatar) &&
            (identical(other.firstName, firstName) ||
                other.firstName == firstName) &&
            (identical(other.lastName, lastName) ||
                other.lastName == lastName) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.password, password) ||
                other.password == password) &&
            (identical(other.city, city) || other.city == city) &&
            (identical(other.country, country) || other.country == country) &&
            (identical(other.website, website) || other.website == website) &&
            (identical(other.desc, desc) || other.desc == desc) &&
            (identical(other.discovery, discovery) ||
                other.discovery == discovery) &&
            (identical(other.nickId, nickId) || other.nickId == nickId) &&
            (identical(other.lat, lat) || other.lat == lat) &&
            (identical(other.lon, lon) || other.lon == lon) &&
            (identical(other.ipAddress, ipAddress) ||
                other.ipAddress == ipAddress) &&
            (identical(other.updateDate, updateDate) ||
                other.updateDate == updateDate) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.hasVotePost, hasVotePost) ||
                other.hasVotePost == hasVotePost) &&
            (identical(other.freeStyle, freeStyle) ||
                other.freeStyle == freeStyle) &&
            (identical(other.isPremium, isPremium) ||
                other.isPremium == isPremium) &&
            (identical(other.rewardDate, rewardDate) ||
                other.rewardDate == rewardDate) &&
            (identical(other.transferedXP, transferedXP) ||
            other.transferedXP == transferedXP) &&
            (identical(other.transferedInSo, transferedInSo) ||
            other.transferedInSo == transferedInSo) &&
            const DeepCollectionEquality().equals(other._likes, _likes) &&
            const DeepCollectionEquality().equals(other._follows, _follows) &&
            const DeepCollectionEquality()
                .equals(other._userActions, _userActions) &&
            const DeepCollectionEquality().equals(other._actions, _actions));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        uid,
        walletAddress,
        avatar,
        firstName,
        lastName,
        email,
        password,
        city,
        country,
        website,
        desc,
        discovery,
        nickId,
        lat,
        lon,
        ipAddress,
        updateDate,
        timestamp,
        status,
        hasVotePost,
        freeStyle,
        isPremium,
        rewardDate,
        transferedXP,
        transferedInSo,
        const DeepCollectionEquality().hash(_likes),
        const DeepCollectionEquality().hash(_follows),
        const DeepCollectionEquality().hash(_userActions),
        const DeepCollectionEquality().hash(_actions)
      ]);

  @override
  String toString() {
    return 'UserModel(id: $id, uid: $uid, walletAddress: $walletAddress, avatar: $avatar, firstName: $firstName, lastName: $lastName, email: $email, password: $password, city: $city, country: $country, website: $website, desc: $desc, discovery: $discovery, nickId: $nickId, lat: $lat, lon: $lon, ipAddress: $ipAddress, updateDate: $updateDate, timestamp: $timestamp, status: $status, hasVotePost: $hasVotePost, freeStyle: $freeStyle, isPremium: $isPremium, rewardDate: $rewardDate, transferedXP: $transferedXP, transferedInSo: $transferedInSo, likes: $likes, follows: $follows, userActions: $userActions, actions: $actions)';
  }
}

/// @nodoc
abstract mixin class _$UserModelCopyWith<$Res>
    implements $UserModelCopyWith<$Res> {
  factory _$UserModelCopyWith(
          _UserModel value, $Res Function(_UserModel) _then) =
      __$UserModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String? id,
      String? uid,
      String? walletAddress,
      String? avatar,
      String? firstName,
      String? lastName,
      String? email,
      String? password,
      String? city,
      String? country,
      String? website,
      String? desc,
      String? discovery,
      String? nickId,
      double? lat,
      double? lon,
      String? ipAddress,
      DateTime? updateDate,
      DateTime? timestamp,
      String? status,
      bool? hasVotePost,
      bool? freeStyle,
      bool? isPremium,
      int? rewardDate,
      int? transferedXP,
      int? transferedInSo,
      List<String>? likes,
      List<String>? follows,
      List<String>? userActions,
      List<UserActionModel>? actions});
}

/// @nodoc
class __$UserModelCopyWithImpl<$Res> implements _$UserModelCopyWith<$Res> {
  __$UserModelCopyWithImpl(this._self, this._then);

  final _UserModel _self;
  final $Res Function(_UserModel) _then;

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = freezed,
    Object? uid = freezed,
    Object? walletAddress = freezed,
    Object? avatar = freezed,
    Object? firstName = freezed,
    Object? lastName = freezed,
    Object? email = freezed,
    Object? password = freezed,
    Object? city = freezed,
    Object? country = freezed,
    Object? website = freezed,
    Object? desc = freezed,
    Object? discovery = freezed,
    Object? nickId = freezed,
    Object? lat = freezed,
    Object? lon = freezed,
    Object? ipAddress = freezed,
    Object? updateDate = freezed,
    Object? timestamp = freezed,
    Object? status = freezed,
    Object? hasVotePost = freezed,
    Object? freeStyle = freezed,
    Object? isPremium = freezed,
    Object? rewardDate = freezed,
    Object? transferedXP = freezed,
    Object? transferedInSo = freezed,
    Object? likes = freezed,
    Object? follows = freezed,
    Object? userActions = freezed,
    Object? actions = freezed,
  }) {
    return _then(_UserModel(
      id: freezed == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      uid: freezed == uid
          ? _self.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String?,
      walletAddress: freezed == walletAddress
          ? _self.walletAddress
          : walletAddress // ignore: cast_nullable_to_non_nullable
              as String?,
      avatar: freezed == avatar
          ? _self.avatar
          : avatar // ignore: cast_nullable_to_non_nullable
              as String?,
      firstName: freezed == firstName
          ? _self.firstName
          : firstName // ignore: cast_nullable_to_non_nullable
              as String?,
      lastName: freezed == lastName
          ? _self.lastName
          : lastName // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _self.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      password: freezed == password
          ? _self.password
          : password // ignore: cast_nullable_to_non_nullable
              as String?,
      city: freezed == city
          ? _self.city
          : city // ignore: cast_nullable_to_non_nullable
              as String?,
      country: freezed == country
          ? _self.country
          : country // ignore: cast_nullable_to_non_nullable
              as String?,
      website: freezed == website
          ? _self.website
          : website // ignore: cast_nullable_to_non_nullable
              as String?,
      desc: freezed == desc
          ? _self.desc
          : desc // ignore: cast_nullable_to_non_nullable
              as String?,
      discovery: freezed == discovery
          ? _self.discovery
          : discovery // ignore: cast_nullable_to_non_nullable
              as String?,
      nickId: freezed == nickId
          ? _self.nickId
          : nickId // ignore: cast_nullable_to_non_nullable
              as String?,
      lat: freezed == lat
          ? _self.lat
          : lat // ignore: cast_nullable_to_non_nullable
              as double?,
      lon: freezed == lon
          ? _self.lon
          : lon // ignore: cast_nullable_to_non_nullable
              as double?,
      ipAddress: freezed == ipAddress
          ? _self.ipAddress
          : ipAddress // ignore: cast_nullable_to_non_nullable
              as String?,
      updateDate: freezed == updateDate
          ? _self.updateDate
          : updateDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      timestamp: freezed == timestamp
          ? _self.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      status: freezed == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as String?,
      hasVotePost: freezed == hasVotePost
          ? _self.hasVotePost
          : hasVotePost // ignore: cast_nullable_to_non_nullable
              as bool?,
      freeStyle: freezed == freeStyle
          ? _self.freeStyle
          : freeStyle // ignore: cast_nullable_to_non_nullable
              as bool?,
      isPremium: freezed == isPremium
          ? _self.isPremium
          : isPremium // ignore: cast_nullable_to_non_nullable
              as bool?,
      rewardDate: freezed == rewardDate
          ? _self.rewardDate
          : rewardDate // ignore: cast_nullable_to_non_nullable
              as int?,
      transferedXP: freezed == transferedXP
          ? _self.transferedXP
          : transferedXP // ignore: cast_nullable_to_non_nullable
      as int?,
      transferedInSo: freezed == transferedInSo
          ? _self.transferedInSo
          : transferedInSo // ignore: cast_nullable_to_non_nullable
      as int?,
      likes: freezed == likes
          ? _self._likes
          : likes // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      follows: freezed == follows
          ? _self._follows
          : follows // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      userActions: freezed == userActions
          ? _self._userActions
          : userActions // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      actions: freezed == actions
          ? _self._actions
          : actions // ignore: cast_nullable_to_non_nullable
              as List<UserActionModel>?,
    ));
  }
}

/// @nodoc
mixin _$UserActionModel {
  String? get postId;
  String? get postUserId;
  bool? get value;
  String? get type;
  String? get description;
  DateTime? get timestamp;

  /// Create a copy of UserActionModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $UserActionModelCopyWith<UserActionModel> get copyWith =>
      _$UserActionModelCopyWithImpl<UserActionModel>(
          this as UserActionModel, _$identity);

  /// Serializes this UserActionModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is UserActionModel &&
            (identical(other.postId, postId) || other.postId == postId) &&
            (identical(other.postUserId, postUserId) ||
                other.postUserId == postUserId) &&
            (identical(other.value, value) || other.value == value) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, postId, postUserId, value, type, description, timestamp);

  @override
  String toString() {
    return 'UserActionModel(postId: $postId, postUserId: $postUserId, value: $value, type: $type, description: $description, timestamp: $timestamp)';
  }
}

/// @nodoc
abstract mixin class $UserActionModelCopyWith<$Res> {
  factory $UserActionModelCopyWith(
          UserActionModel value, $Res Function(UserActionModel) _then) =
      _$UserActionModelCopyWithImpl;
  @useResult
  $Res call(
      {String? postId,
      String? postUserId,
      bool? value,
      String? type,
      String? description,
      DateTime? timestamp});
}

/// @nodoc
class _$UserActionModelCopyWithImpl<$Res>
    implements $UserActionModelCopyWith<$Res> {
  _$UserActionModelCopyWithImpl(this._self, this._then);

  final UserActionModel _self;
  final $Res Function(UserActionModel) _then;

  /// Create a copy of UserActionModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? postId = freezed,
    Object? postUserId = freezed,
    Object? value = freezed,
    Object? type = freezed,
    Object? description = freezed,
    Object? timestamp = freezed,
  }) {
    return _then(_self.copyWith(
      postId: freezed == postId
          ? _self.postId
          : postId // ignore: cast_nullable_to_non_nullable
              as String?,
      postUserId: freezed == postUserId
          ? _self.postUserId
          : postUserId // ignore: cast_nullable_to_non_nullable
              as String?,
      value: freezed == value
          ? _self.value
          : value // ignore: cast_nullable_to_non_nullable
              as bool?,
      type: freezed == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      timestamp: freezed == timestamp
          ? _self.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _UserActionModel implements UserActionModel {
  _UserActionModel(
      {this.postId,
      this.postUserId,
      this.value,
      this.type,
      this.description,
      this.timestamp});
  factory _UserActionModel.fromJson(Map<String, dynamic> json) =>
      _$UserActionModelFromJson(json);

  @override
  final String? postId;
  @override
  final String? postUserId;
  @override
  final bool? value;
  @override
  final String? type;
  @override
  final String? description;
  @override
  final DateTime? timestamp;

  /// Create a copy of UserActionModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$UserActionModelCopyWith<_UserActionModel> get copyWith =>
      __$UserActionModelCopyWithImpl<_UserActionModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$UserActionModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _UserActionModel &&
            (identical(other.postId, postId) || other.postId == postId) &&
            (identical(other.postUserId, postUserId) ||
                other.postUserId == postUserId) &&
            (identical(other.value, value) || other.value == value) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, postId, postUserId, value, type, description, timestamp);

  @override
  String toString() {
    return 'UserActionModel(postId: $postId, postUserId: $postUserId, value: $value, type: $type, description: $description, timestamp: $timestamp)';
  }
}

/// @nodoc
abstract mixin class _$UserActionModelCopyWith<$Res>
    implements $UserActionModelCopyWith<$Res> {
  factory _$UserActionModelCopyWith(
          _UserActionModel value, $Res Function(_UserActionModel) _then) =
      __$UserActionModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String? postId,
      String? postUserId,
      bool? value,
      String? type,
      String? description,
      DateTime? timestamp});
}

/// @nodoc
class __$UserActionModelCopyWithImpl<$Res>
    implements _$UserActionModelCopyWith<$Res> {
  __$UserActionModelCopyWithImpl(this._self, this._then);

  final _UserActionModel _self;
  final $Res Function(_UserActionModel) _then;

  /// Create a copy of UserActionModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? postId = freezed,
    Object? postUserId = freezed,
    Object? value = freezed,
    Object? type = freezed,
    Object? description = freezed,
    Object? timestamp = freezed,
  }) {
    return _then(_UserActionModel(
      postId: freezed == postId
          ? _self.postId
          : postId // ignore: cast_nullable_to_non_nullable
              as String?,
      postUserId: freezed == postUserId
          ? _self.postUserId
          : postUserId // ignore: cast_nullable_to_non_nullable
              as String?,
      value: freezed == value
          ? _self.value
          : value // ignore: cast_nullable_to_non_nullable
              as bool?,
      type: freezed == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      timestamp: freezed == timestamp
          ? _self.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
mixin _$UserCountryModel {
  String? get name;
  String? get code;

  /// Create a copy of UserCountryModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $UserCountryModelCopyWith<UserCountryModel> get copyWith =>
      _$UserCountryModelCopyWithImpl<UserCountryModel>(
          this as UserCountryModel, _$identity);

  /// Serializes this UserCountryModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is UserCountryModel &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.code, code) || other.code == code));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, name, code);

  @override
  String toString() {
    return 'UserCountryModel(name: $name, code: $code)';
  }
}

/// @nodoc
abstract mixin class $UserCountryModelCopyWith<$Res> {
  factory $UserCountryModelCopyWith(
          UserCountryModel value, $Res Function(UserCountryModel) _then) =
      _$UserCountryModelCopyWithImpl;
  @useResult
  $Res call({String? name, String? code});
}

/// @nodoc
class _$UserCountryModelCopyWithImpl<$Res>
    implements $UserCountryModelCopyWith<$Res> {
  _$UserCountryModelCopyWithImpl(this._self, this._then);

  final UserCountryModel _self;
  final $Res Function(UserCountryModel) _then;

  /// Create a copy of UserCountryModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = freezed,
    Object? code = freezed,
  }) {
    return _then(_self.copyWith(
      name: freezed == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      code: freezed == code
          ? _self.code
          : code // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _UserCountryModel implements UserCountryModel {
  _UserCountryModel({this.name, this.code});
  factory _UserCountryModel.fromJson(Map<String, dynamic> json) =>
      _$UserCountryModelFromJson(json);

  @override
  final String? name;
  @override
  final String? code;

  /// Create a copy of UserCountryModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$UserCountryModelCopyWith<_UserCountryModel> get copyWith =>
      __$UserCountryModelCopyWithImpl<_UserCountryModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$UserCountryModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _UserCountryModel &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.code, code) || other.code == code));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, name, code);

  @override
  String toString() {
    return 'UserCountryModel(name: $name, code: $code)';
  }
}

/// @nodoc
abstract mixin class _$UserCountryModelCopyWith<$Res>
    implements $UserCountryModelCopyWith<$Res> {
  factory _$UserCountryModelCopyWith(
          _UserCountryModel value, $Res Function(_UserCountryModel) _then) =
      __$UserCountryModelCopyWithImpl;
  @override
  @useResult
  $Res call({String? name, String? code});
}

/// @nodoc
class __$UserCountryModelCopyWithImpl<$Res>
    implements _$UserCountryModelCopyWith<$Res> {
  __$UserCountryModelCopyWithImpl(this._self, this._then);

  final _UserCountryModel _self;
  final $Res Function(_UserCountryModel) _then;

  /// Create a copy of UserCountryModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? name = freezed,
    Object? code = freezed,
  }) {
    return _then(_UserCountryModel(
      name: freezed == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      code: freezed == code
          ? _self.code
          : code // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

// dart format on
