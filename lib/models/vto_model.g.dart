// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vto_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_VTOCellModel _$VTOCellModelFromJson(Map<String, dynamic> json) =>
    _VTOCellModel(
      title: json['title'] as String?,
      image: json['image'] as String?,
      desc: json['desc'] as String?,
    );

Map<String, dynamic> _$VTOCellModelToJson(_VTOCellModel instance) =>
    <String, dynamic>{
      'title': instance.title,
      'image': instance.image,
      'desc': instance.desc,
    };

_VTOGroupModel _$VTOGroupModelFromJson(Map<String, dynamic> json) =>
    _VTOGroupModel(
      name: json['name'] as String?,
      list:
          (json['list'] as List<dynamic>?)
              ?.map((e) => VTOCellModel.fromJson(e as Map<String, dynamic>))
              .toList(),
    );

Map<String, dynamic> _$VTOGroupModelToJson(_VTOGroupModel instance) =>
    <String, dynamic>{'name': instance.name, 'list': instance.list};
