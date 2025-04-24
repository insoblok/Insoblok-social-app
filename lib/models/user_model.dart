import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:insoblok/services/services.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
abstract class UserModel with _$UserModel {
  @JsonSerializable(fieldRename: FieldRename.snake)
  factory UserModel({
    String? id,
    String? uid,
    String? walletAddress,
    String? avatar,
    String? firstName,
    String? lastName,
    double? lat,
    double? lon,
    String? ipAddress,
    String? regdate,
    String? updateDate,
    String? status,
    List<String>? likes,
    List<String>? follows,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}

extension UserModelExt on UserModel {
  String get fullName {
    var f = (firstName ?? '--').trim();
    var l = (lastName ?? '--').trim();
    return '${f[0].toUpperCase()}${f.substring(1)} ${l[0].toUpperCase()}${l.substring(1)}';
  }

  Widget avatarStatusView({double? width, double? height}) {
    return ClipOval(
      child: AIImage(avatar, width: width ?? 60.0, height: height ?? 60.0),
    );
  }
}
